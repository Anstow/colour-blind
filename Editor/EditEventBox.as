package Editor
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;

	/**
	 * ...
	 * @author David
	 */
	public class EditEventBox extends Entity
	{
		private var events:Array = [];
		private var lastX:int;
		private var lastY:int;
		private var currentEvent:EditEvent;

		public function EditEventBox(events:Array) {
			super();
			setHitbox(400,20);
			for (var i:int = 0; i < events.length; i++)
			{
				this.events.push(new EditEvent(events[i],x,y+20+i*20));
			}
			
			addGraphic(Image.createRect(400, 20 + events.length * 20, 0x4b4b40));
			addGraphic(Image.createRect(400, 20, 0x000040));
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
		}

		public function clickedOn(e:EditEvent):void {
			if (currentEvent && currentEvent) {
				currentEvent.setClickedOn(false);
			}
			if (currentEvent != e) {
				currentEvent = e;
			} else { 
				currentEvent = null;
			}
			if (currentEvent && currentEvent) {
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
