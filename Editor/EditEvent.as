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

		private var currentBlock:Parent;
		private var clickedOn:Boolean = false;

		public function EditEvent(event:GameEvent,x:int,y:int) {
			super(x,y);
			this.event = event;
			currentBlock = event;
			layer=-21;
			cursorPosition = -1;
			type = "Event";
			setHitbox(400,20);
		}

		public override function added():void {
			text = new Text(event.toString(world as LoadableWorld));
			graphic = text;
			//addGraphic(text);
		}

		public function addString(str:String):void {
			if (currentBlock) {
				currentBlock.changeString(str);
			}
			text.text = event.toString(world as LoadableWorld, currentBlock);
			graphic = text;
		}
		
		public function updatePos(x_diff:int,y_diff:int):void {
			x += x_diff;
			y += y_diff;
		}

		public function setVisibility(visibility:Boolean):void {
			visible = visibility;
			collidable = visibility;
			if (visibility) {
				text = new Text(event.toString(world as LoadableWorld));
				graphic = text;
				trace(collidable);
			}
		}
		
		// Select this Event to edit
		public function setClickedOn(clickedOn:Boolean):void {
			this.clickedOn = clickedOn;
			trace("edit event swap");
			if (clickedOn) {
				trace(currentBlock);
				text.text = event.toString(world as LoadableWorld, currentBlock);
				graphic = text;
				trace(text.text);
			} else {
				text.text = event.toString(world as LoadableWorld);
				graphic = text;
			}
		}

		// Move the selected block
		public function moveSelection(d:int):void {
			if (clickedOn) {
				currentBlock = currentBlock.moveSelection(d);
				text.text = event.toString(world as LoadableWorld, currentBlock);
				graphic = text;
			}
		}
	}
}

// vim: foldmethod=indent:cindent
