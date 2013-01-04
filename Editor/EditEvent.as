package Editor
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;

	/**
	 * ...
	 * @author David
	 */
	public class EditEvent extends Entity
	{
		public var event:GameEvent;
		public var text:Text;
		public var selected:Boolean;
		public var cursorPosition:int;

		public function EditEvent(event:GameEvent,x:int,y:int) {
			super(x,y);
			this.event = event;
			layer=-21;
			cursorPosition = -1;
		}

		public override function added():void {
			text = new Text(event.toString(world as LoadableWorld));
			addGraphic(text);
		}
		
		public function updatePos(x_diff:int,y_diff:int):void {
			x += x_diff;
			y += y_diff;
		}

		public function setVisibility(visibility:Boolean):void{
			visible = visibility;
			collidable = visibility;
		}
	}
}

// vim: foldmethod=indent:cindent
