package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import Editor.LoadableWorld;
	
	public class Wall extends Entity
	{
		public var allButtons:Array = [];
		public var pressedButtons:Array = [];
		private var exists:Boolean = true;
		public var ident:int;
		
		public function Wall(data:Object):void
		{
			var r:Array = data.rect;
			x = r[0] * GC.tileWidth;
			y = r[1] * GC.tileHeight;
			setHitbox(r[2] * GC.tileWidth, r[3] * GC.tileHeight);
			ident = data.type;
			graphic = Image.createRect(r[2] * GC.tileWidth, r[3] * GC.tileHeight, GC.wallColours[ident + 1]);
			type = "wall" + ident;
			// buttons
			if (data.buttons !== undefined) {
				for each (var buttonGroup:Array in data.buttons) {
					allButtons.push(buttonGroup.slice());
					var pressedButtonsGroup:Array = [];
					pressedButtons.push(pressedButtonsGroup);
					for each (var b:int in buttonGroup) {
						pressedButtonsGroup.push(b);
					}
				}
			}
		}
		
		public function toggle(b:Switch):void {
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

		public override function removed():void
		{
			super.removed();
			if ((world as LoadableWorld).editting)
			{
				for each (var s:Switch in allButtons)
				{
					s.removeLink(this);
				}
				trace("links removed");
			}
		}

		public function removeLink(s: Switch):void
		{
			if (allButtons.indexOf(s) >= 0)
			{
				allButtons.splice(allButtons.indexOf(s),1);
			}			
		}
	}
}
