package Editor
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;

	/**
	 * ...
	 * @author David
	 */
	public class EditEventBox extends Entity
	{
		public var events:Array = [];
		private var lastX:int;
		private var lastY:int;

		public function EditEventBox(events:Array) {
			super();
			setHitbox(200,20);
			for (var i:int = 0; i < events.length; i++)
			{
				this.events.push(new EditEvent(events[i],x,y+20+i*20));
			}
			
			addGraphic(Image.createRect(200, 20 + events.length * 20, 0x4b4b40));
			addGraphic(Image.createRect(200, 20, 0x000040));
			type="EventBox";
			layer=-20;
		}
		
		public override function added():void {
			super.added();
			for each (var event:EditEvent in events) {
				world.add(event);
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
