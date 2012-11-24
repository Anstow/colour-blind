package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;

	public class Switch extends Entity
	{
		public var ident : int;
		public var walls:Array;
		public var player:int;
		[Embed(source = 'assets/switch1.png')] private const SWITCH1:Class;
		[Embed(source = 'assets/switch2.png')] private const SWITCH2:Class;

		public function Switch (ident:int, data:Object):void {
			this.ident = ident;
			player = data.type
			if (player == 0) {
				graphic = new Image(SWITCH1);
			} else {
				graphic = new Image(SWITCH2);
			}
			x = data.pos[0] * GC.tileWidth;
			y = data.pos[1] * GC.tileHeight;
			setHitbox(GC.tileWidth, GC.tileHeight);
			type = "switch" + player;
			walls = data.walls;
		}

		public function toggle ():void {
			for each (var i:int in walls) {
				(world as Level).walls[i].toggle(ident);
			}
		}
	}
}
