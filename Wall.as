package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.TiledImage;
	import Editor.LoadableWorld;
	
	public class Wall extends Entity
	{
		public var allButtons:Array = [];
		public var pressedButtons:Array = [];
		public var ident:int;
		private var numText:EditorNumber;
		[Embed(source = 'assets/wall0.png')] private const WALL0:Class;
		[Embed(source = 'assets/GreenCheck.png')] private const WALL1:Class;
		[Embed(source = 'assets/BlueCheck.png')] private const WALL2:Class;
		
		public function Wall(data:Object):void {
			var r:Array = data.rect;
			x = r[0] * GC.tileWidth;
			y = r[1] * GC.tileHeight;
			setHitbox(r[2] * GC.tileWidth, r[3] * GC.tileHeight);
			ident = data.type;
			if (ident == -1) {
				graphic = new TiledImage(WALL0, r[2] * GC.tileWidth, r[3] * GC.tileHeight);
			} else if (ident == 0) {
				graphic = new TiledImage(WALL1, r[2] * GC.tileWidth, r[3] * GC.tileHeight);
			} else {
				graphic = new TiledImage(WALL2, r[2] * GC.tileWidth, r[3] * GC.tileHeight);
			}
			type = "wall" + ident;
		}

		public function addText ():void {
			if (world) {
				numText = new EditorNumber(ident, (world as LoadableWorld).walls.indexOf(this), x, y);
				world.add(numText);
			}
		}

		public function rmText ():void {
			world.remove(numText);
		}

		public function removeLink(s: Switch):void {
			if (allButtons.indexOf(s) >= 0)
			{
				allButtons.splice(allButtons.indexOf(s),1);
			}			
		}
	}
}

// vim: foldmethod=indent:cindent
