package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;

	public class Target extends Entity
	{
		public var ident : int;
		[Embed(source = 'assets/P1Target.png')] private const TARGET1:Class;
		[Embed(source = 'assets/P2Target.png')] private const TARGET2:Class;

		public function Target (data:Object):void {
			ident = data.type;
			x = data.pos[0] * GC.tileWidth;
			y = data.pos[1] * GC.tileHeight;
			type = "target" + ident;
			if (ident == 0) {
				graphic = new Image(TARGET1);
			} else {
				graphic = new Image(TARGET2);
			}
			setHitbox(GC.tileWidth, GC.tileHeight);
		}

		public function updateXY(pos:Array):void
		{
			x = pos[0] * GC.tileWidth;
			y = pos[1] * GC.tileHeight;
		}
	}
}
