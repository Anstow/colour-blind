package Editor
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.graphics.Text;

	/**
	 * ...
	 * @author David
	 */
	public class EditEventBox extends Entity
	{
		public static const SELECTING:int = 0;
		public static const EDITING:int = 1;
		private var events:Array = [];
		private var lastX:int;
		private var lastY:int;
		private var currentEvent:EditEvent;
		private var mode:int = 0;
		private var currentStr:String = "";
		private var textToAdd:Text;
		private var lowerRect:Image;

		public function EditEventBox(events:Array) {
			super();
			setHitbox(400,20);
			for (var i:int = 0; i < events.length; i++) {
				this.events.push(new EditEvent(events[i],x,y+20+i*20));
			}
			addGraphic(Image.createRect(400, 20 + events.length * 20, 0x4b4b40));
			addGraphic(Image.createRect(400, 20, 0x000040));
			textToAdd = new Text("");
			addGraphic(textToAdd);
			type="EventBox";
			layer=-20;
		}
		
		public override function added():void {
			super.added();
			for each (var event:EditEvent in events) {
				world.add(event);
			}
		}

		public override function update():void {
			super.update();
			if (mode == SELECTING) {
				if (currentEvent) {
					if (Input.released(Key.LEFT)) {
						currentEvent.moveSelection(LogicBlock.LEFT);
					} else if (Input.released(Key.RIGHT)) {
						currentEvent.moveSelection(LogicBlock.RIGHT);
					} else if (Input.released(Key.DOWN)) {
						currentEvent.moveSelection(LogicBlock.DESCEND);
					} else if (Input.released(Key.UP)) {
						currentEvent.moveSelection(LogicBlock.ASSCEND);
					}
				}
			} else if (mode == EDITING) {
				if (Input.released(Key.A) && Input.check(Key.SHIFT)) {
					currentStr += LogicBlock.AND_S;
					textToAdd.text = "Edit: " + currentStr + "_";
				} else if (Input.released(Key.O) && Input.check(Key.SHIFT)) {
					currentStr += LogicBlock.OR_S;
					textToAdd.text = "Edit: " + currentStr + "_";
				} else if (Input.released(Key.O) && Input.check(Key.SHIFT)) {
					currentStr += LogicBlock.NOT_S;
					textToAdd.text = "Edit: " + currentStr + "_";
				} else if (Input.released(Key.DIGIT_0)) {
					currentStr += "0";
					textToAdd.text = "Edit: " + currentStr + "_";
				} else if (Input.released(Key.DIGIT_1)) {
					currentStr += "1";
					textToAdd.text = "Edit: " + currentStr + "_";
				} else if (Input.released(Key.DIGIT_2)) {
					currentStr += "2";
					textToAdd.text = "Edit: " + currentStr + "_";
				} else if (Input.released(Key.DIGIT_3)) {
					currentStr += "3";
					textToAdd.text = "Edit: " + currentStr + "_";
				} else if (Input.released(Key.DIGIT_4)) {
					currentStr += "4";
					textToAdd.text = "Edit: " + currentStr + "_";
				} else if (Input.released(Key.DIGIT_5)) {
					currentStr += "5";
					textToAdd.text = "Edit: " + currentStr + "_";
				} else if (Input.released(Key.DIGIT_6)) {
					currentStr += "6";
					textToAdd.text = "Edit: " + currentStr + "_";
				} else if (Input.released(Key.DIGIT_7)) {
					currentStr += "7";
					textToAdd.text = "Edit: " + currentStr + "_";
				} else if (Input.released(Key.DIGIT_8)) {
					currentStr += "8";
					textToAdd.text = "Edit: " + currentStr + "_";
				} else if (Input.released(Key.DIGIT_9)) {
					currentStr += "9";
					textToAdd.text = "Edit: " + currentStr + "_";
				} else if (Input.released(Key.BACKSPACE) && currentStr.length > 0) {
					currentStr = currentStr.slice(0,currentStr.length - 1);
					textToAdd.text = "Edit: " + currentStr + "_";
				} else if (Input.released(Key.B)) {
					currentStr += "b";
					textToAdd.text = "Edit: " + currentStr + "_";
				} else if (Input.released(Key.SPACE)) {
					currentStr += " ";
					textToAdd.text = "Edit: " + currentStr + "_";
				}
			}

			if (Input.released(Key.ENTER)) {
				if (mode == SELECTING) {
					mode = EDITING;
					currentStr = "";
					textToAdd.text = "Edit: " + currentStr;
				} else {
					mode = SELECTING;
					if (currentStr != "") {
						if (currentEvent) {
							currentEvent.addString(currentStr);
						} else {
							var tempEvent:GameEvent = new GameEvent(new Object());
							tempEvent.changeString(currentStr);
							if (world) {
								tempEvent.attachSwitches(world as LoadableWorld);
							}
							trace("here");
							events.push(new EditEvent(tempEvent, x, y+20+20*events.length));
							graphic = null;
							addGraphic(Image.createRect(400, 20 + events.length * 20, 0x4b4b40));
							addGraphic(Image.createRect(400, 20, 0x000040));
							addGraphic(textToAdd);
							world.add(events[events.length - 1]);
						}
					}
					currentStr = "";
					textToAdd.text = "";
				}
			}
		}

		public function clickedOn(e:EditEvent):void {
			if (currentEvent) {
				currentEvent.setClickedOn(false);
			}
			if (currentEvent != e) {
				currentEvent = e;
			} else { 
				currentEvent = null;
			}
			if (currentEvent) {
				currentEvent.setClickedOn(true);
			}
		}
		
		public function setVisibility(visibility:Boolean):void {
			visible = visibility;
			collidable = visibility;
			for each (var event:EditEvent in events) {
				event.setVisibility(visibility);
			}
		}

		public function moving(mouseX:int, mouseY:int):void{
			if (lastX != -1 && lastX != -1)
			{
				var x_diff:int = mouseX - lastX;
				var y_diff:int = mouseY - lastY;
				x += x_diff;
				y += y_diff;
				for each (var e:EditEvent in events) {
					e.updatePos(x_diff,y_diff);
				}
		   	}
			lastX = mouseX;
			lastY = mouseY;
		}
		
		public function stopped():void{
			lastX = -1;
			lastY = -1;
		}
	}
}

// vim: foldmethod=indent:cindent
