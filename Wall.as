package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	public class Wall extends Entity
	{
		private var ident:int;
		
		public function Wall(ident:int, rect:Array):void
		{
			this.ident = ident;
			x = rect[0] * GC.tileWidth;
			y = rect[1] * GC.tileHeight;
			setHitbox(rect[2] * GC.tileWidth, rect[3] * GC.tileHeight);
			graphic = Image.createRect(rect[2] * GC.tileWidth, rect[3] * GC.tileHeight, GC.playerColours[ident]);
			type = "wall" + ident;
		}
	}
}
