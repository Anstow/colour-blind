package Editor
{
	import Editor.EditorConstants;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import net.flashpunk.utils.Key;

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
				tileOpts.visible = true;
			}
			else if (Input.released(Key.F5))
			{
				remove(currentMap);
				currentMap.updateCollisions();
				FP.world = new Level(ident, data);
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
					tmpW =  x1 - leftSide;
				}
				else
				{
					leftSide = x1;
					tmpW = currentMap.getTileX(mouseX) - leftSide;
				}
				
				if (y1 > currentMap.getTileY(mouseY))
				{
					topSide = currentMap.getTileY(mouseY);
					tmpH = y1 - topSide;
				}
				else
				{
					topSide = y1;
					tmpH = currentMap.getTileY(mouseY) - topSide;
				}
			}

			// TODO: Sort out putting in Lava etc....

				
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
						walls.push(new Wall({type: selected-3, rect: [leftSide, topSide, tmpW, tmpH]}));
						
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
					// Player 0 start position hacked
					break;
				case 6:
					// Player 1 start position hacked
					break;
				case 7:
					// Player 0 target position hacked
					break;
				case 8:
					// Player 1 target position hacked
					break;
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
