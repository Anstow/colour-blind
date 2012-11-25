package Editor
{
	import Editor.EditorConstants;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import net.flashpunk.utils.Key;
	import net.flashpunk.Entity;

	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author David
	 */
	public class EditWorld extends LoadableWorld 
	{
		public var tileOpts : TileOptions;
		
		// The seclected tile.
		public var selected : int =  -1;
		public var x1 : int = -1;
		public var y1 : int = -1;

		public function EditWorld (id:int, data:Object) {
			super(id, data);
			for (var i:int = 0; i < 2; i++) {
				add(new Start(i, playersStart[i]));
			}
		}
		
		override public function begin():void 
		{
			super.begin();
			EditorConstants.init();
			
			add(currentMap);
			tileOpts = new TileOptions();
			add(tileOpts);
			
			FP.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
		}
		
		override public function update():void 
		{
			if (Input.mousePressed)
			{
				if (tileOpts.visible)
				{
					selected = tileOpts.getTile(mouseX, mouseY);
					if (selected != -1)
					{
						tileOpts.visible = false;
					}
				} else {
					mousePress();
				}
			}
			if (Input.released(Key.SHIFT))
			{
				selected = -1;
				x1 = -1;
				y1 = -1;
				tileOpts.visible = true;
			}
			else if (Input.released(Key.F5))
			{
				currentMap.updateCollisions();
				FP.world = new Level(ident, generateData());
				removeAll();
			}
			
			if (EditorConstants.scrollOn)
			{
				scrollHorizontal(EditorConstants.halfWidth * 2);
				scrollVertical(EditorConstants.halfHeight * 2);
			}
			super.update();
		}

		private function mousePress():void
		{
			if (x1 != -1 && y1 != -1)
			{
				var leftSide : int;
				var topSide : int;
				var tmpW : int;
				var tmpH : int;

				if (x1 > currentMap.getTileX(mouseX))
				{
					leftSide = currentMap.getTileX(mouseX);
					tmpW =  x1 - leftSide + 1;
				}
				else
				{
					leftSide = x1;
					tmpW = currentMap.getTileX(mouseX) - leftSide + 1;
				}
				
				if (y1 > currentMap.getTileY(mouseY))
				{
					topSide = currentMap.getTileY(mouseY);
					tmpH = y1 - topSide + 1;
				}
				else
				{
					topSide = y1;
					tmpH = currentMap.getTileY(mouseY) - topSide + 1;
				}
			}
			else
			{
				var ent:Entity = FP.world.collidePoint("wall" + (selected - 3), mouseX, mouseY);
				if (ent)
				{
					if (walls.indexOf(ent) >= 0)
					{
						FP.world.remove(ent);
						walls.splice(walls.indexOf(ent), 1);
						return;
					}
				}
			}

			var tmpArray:Array = new Array();

			switch(selected)
			{
				case -1:
					tileOpts.visible = true;
					break;
				case 2:
					// Lava hacked
				case 3:
					// Color 0 hacked
				case 4:
					// Color 1 hacked
					if (x1 != -1 && y1 != -1)
					{						
						// Set the tiles 
						var tmp :Wall = new Wall({type: selected-3, rect: [leftSide, topSide, tmpW, tmpH]});
						walls.push(tmp);
						FP.world.add(tmp);
						
						// Set the original position back to -1, -1.
						x1 = -1;
						y1 = -1;
					}
					else
					{
						x1 = currentMap.getTileX(mouseX);
						y1 = currentMap.getTileY(mouseY);
					}
					break;
				case 5:
					// Player 0 target position hacked
				case 6:
					// Player 1 target position hacked
					FP.world.getType("target" + (selected - 5),tmpArray);
					if (tmpArray.length >=0)
					{
						tmpArray[0].updateXY([currentMap.getTileX(mouseX), currentMap.getTileY(mouseY)]);
					}
					break;
				case 7:
					// Player 0 start position hacked
				case 8:
					// Player 1 start position hacked
					playersStart[selected - 7] = [currentMap.getTileX(mouseX), currentMap.getTileY(mouseY)];

					tmpArray;
					FP.world.getType("startplayer" + (selected - 7),tmpArray);
					if (tmpArray.length >=0)
					{
						tmpArray[0].updateXY([currentMap.getTileX(mouseX), currentMap.getTileY(mouseY)]);
					}
					break;
				case 9:
				case 10:
					// Player 0 switch hacked
					// Player 1 switch hacked
					ent = FP.world.collidePoint("switch" + (selected - 9), mouseX, mouseY);
					trace(ent);
					if (ent) // Clicked on a switch
					{
						// Removes the switches 
						if (switches.indexOf(ent) >= 0)
						{
							FP.world.remove(ent);
							switches.splice(switches.indexOf(ent),1);
						}
					}
					else // Not clicked on a switch
					{
						var tmpSwitch:Switch = new Switch(GC.highestSwitchId + 1, {type:(selected - 9), pos:[currentMap.getTileX(mouseX), currentMap.getTileY(mouseY)]});
						switches.push(tmpSwitch);
						FP.world.add(tmpSwitch);
					}
					break;
				case 11:
					// Switch-wall conection hacked
				default: // I.e. 0 No walls OR 1 Walls
					if (x1 != -1 && y1 != -1)
					{						
						// Set the tiles 
						currentMap.setTiles(x1, y1, currentMap.getTileX(mouseX), currentMap.getTileY(mouseY), selected);
						
						// Set the original position back to -1, -1.
						x1 = -1;
						y1 = -1;
					}
					else
					{
						x1 = currentMap.getTileX(mouseX);
						y1 = currentMap.getTileY(mouseY);
					}
					break;
			}
		}
		
		private function keyDownListener(e : KeyboardEvent):void
		{
			if (e.ctrlKey || e.shiftKey)
			{
				if (e.keyCode == Key.S)
				{
					save();
				}
				else if (e.keyCode == Key.L)
				{
					load();
				}
			}
		}
	}
}
