package Editor
{
	import Editor.EditorConstants;
	import flash.text.GridFitType;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import net.flashpunk.utils.Key;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import flash.events.KeyboardEvent;
	import com.adobe.serialization.json.JSON;
	
	/**
	 * ...
	 * @author David
	 */
	public class EditWorld extends LoadableWorld 
	{
		private var grid:Image = new Image(GC.GRID);
		
		public var tileOpts : TileOptions;
		
		// The seclected tile.
		public var selected : int =  -1;
		public var x1 : int = -1;
		public var y1 : int = -1;
		public var eventBox : EditEventBox;

		public function EditWorld (id:int, data:Object) {
			super(id, data);
			for (var i:int = 0; i < 2; i++) {
				add(new Start(i, playersStart[i]));
			}
			editting = true;
		}
		
		override public function begin():void {
			super.begin();
			EditorConstants.init();
			
			add(currentMap);
			tileOpts = new TileOptions();
			add(tileOpts);
			
			addGraphic(grid);
			eventBox = new EditEventBox(events);
			eventBox.setVisibility(false);
			add(eventBox);

			addNumbers();
		}
		
		public function addNumbers ():void {
			for each (var w:Wall in walls) {
				w.addText();
			}
			for each (var s:Switch in switches) {
				s.addText();
			}
		}
		
		public function rmNumbers ():void {
			for each (var w:Wall in walls) {
				w.rmText();
			}
			for each (var s:Switch in switches) {
				s.rmText();
			}
		}
		
		override public function update():void {
			if (tempLevel != null) {
				FP.world = new EditWorld(ident, com.adobe.serialization.json.JSON.decode(tempLevel) as Object);
				tempLevel = null;
				return;
			}
			if (Input.mousePressed) {
				if (tileOpts.visible) {
					selected = tileOpts.getTile(mouseX, mouseY);
					if (selected != -1) {
						tileOpts.visible = false;
						tileOpts.collidable = false;
						if (selected == 11) {
							eventBox.setVisibility(true);
						}
					}
				} else {
					mousePress();
				}
			}
			if (Input.mouseDown) {
				// If we're in event mode
				if (selected == 11) {
					if (collidePoint("EventBox",mouseX,mouseY)) {
						eventBox.moving(mouseX, mouseY);
					} else {
						eventBox.stopped();
					}
				}
			}
			if (Input.released(Key.ESCAPE)) {
				if (selected == 11) {
					eventBox.stopped();
					events = eventBox.loadEvents();
					eventBox.setVisibility(false);
				}
				selected = -1;
				x1 = -1;
				y1 = -1;
				tileOpts.visible = true;
				tileOpts.collidable = true;
			} else if (Input.released(Key.F2)) {
				editting = false;
				currentMap.updateCollisions();
				FP.world = new Level(ident, generateData());
				removeAll();
			} else if (Input.released(Key.F3)) {
				save();
			} else if (Input.released(Key.F4)) {
				load();
			}
			
			if (EditorConstants.scrollOn) {
				scrollHorizontal(EditorConstants.halfWidth * 2);
				scrollVertical(EditorConstants.halfHeight * 2);
			}
			super.update();
		}

		private function mousePress():void {
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
						rmNumbers();
						FP.world.remove(ent);
						walls.splice(walls.indexOf(ent), 1);
						addNumbers();
						return;
					}
				}
			}

			var tmpArray:Array = new Array();
			switch(selected)
			{
				case -1:
					tileOpts.visible = true;
					tileOpts.collidable = true;
					break;
				case 2:
				case 3:
				case 4:
					// Lava hacked
					// Color 0 hacked
					// Color 1 hacked
					if (x1 != -1 && y1 != -1)
					{
						// Set the tiles
						rmNumbers();
						var tmp:Wall = new Wall({type: selected-3, rect: [leftSide, topSide, tmpW, tmpH]});
						walls.push(tmp);
						FP.world.add(tmp);
						addNumbers();
						
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
				case 6:
					// Player 0 target position hacked
					// Player 1 target position hacked
					ent = FP.world.collidePoint("target" + (selected - 5), mouseX, mouseY);
					if (ent) // Clicked on a target
					{
						FP.world.remove(ent);
						// Removes the target 
						if (targets.indexOf(ent) >= 0)
						{
							targets.splice(targets.indexOf(ent),1);
						}
					}
					else // Not clicked on a target
					{
						var tmpTarget:Target = new Target({type:(selected - 5), pos:[currentMap.getTileX(mouseX), currentMap.getTileY(mouseY)]});
						targets.push(tmpTarget);
						FP.world.add(tmpTarget);
					}
					break;
				case 7:
				case 8:
					// Player 0 start position hacked
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
					if (ent) // Clicked on a switch
					{
						// Removes the switches
						if (switches.indexOf(ent) >= 0)
						{
							rmNumbers();
							FP.world.remove(ent);
							switches.splice(switches.indexOf(ent),1);
							addNumbers();
						}
					}
					else // Not clicked on a switch
					{
						rmNumbers();
						var tmpSwitch:Switch = new Switch(GC.highestSwitchId + 1, {type:(selected - 9), pos:[currentMap.getTileX(mouseX), currentMap.getTileY(mouseY)]});
						switches.push(tmpSwitch);
						FP.world.add(tmpSwitch);
						addNumbers();
					}
					break;
				case 11:
					// Edit events
					var tempEvent:EditEvent = collidePoint("Event",mouseX,mouseY) as EditEvent;
					if (tempEvent) {
						eventBox.clickedOn(tempEvent);
					}
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
	}
}

// vim: foldmethod=indent:cindent
