package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	public class Wall extends Entity
	{
		private var allButtons:Array = [];
		private var pressedButtons:Array = [];
		private var exists:Boolean = true;
		
		public function Wall(data:Object):void
		{
			var r:Array = data.rect;
			x = r[0] * GC.tileWidth;
			y = r[1] * GC.tileHeight;
			setHitbox(r[2] * GC.tileWidth, r[3] * GC.tileHeight);
			graphic = Image.createRect(r[2] * GC.tileWidth, r[3] * GC.tileHeight, GC.playerColours[data.type]);
			type = "wall" + data.type;
			// buttons
			if (data.buttons !== undefined) {
				for each (var buttonGroup:Array in data.buttons) {
					allButtons.push(buttonGroup);
					var pressedButtonsGroup:Array = [];
					pressedButtons.push(pressedButtonsGroup);
					for each (var b:int in buttonGroup) {
						pressedButtonsGroup.push(b);
					}
				}
			}
		}
		
		public function toggle(b:int):void {
			var newExists:Boolean = true;
			for (var i:int = 0; i < allButtons.length; i++) {
				var bs:Array = pressedButtons[i];
				if (allButtons[i].indexOf(b) != -1) {
					var j:int = bs.indexOf(b);
					if (j == -1) {
						bs.push(b);
					} else {
						bs.splice(j, 1);
					}
				}
				if (bs.length == 0) {
					newExists = false;
				}
			}
			if (newExists != exists) {
				if (newExists) {
					visible = true;
					collidable = true;
				} else {
					visible = false;
					collidable = false;
				}
				exists = newExists;
			}
		}
	}
}
