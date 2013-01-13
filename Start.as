package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	public class Start extends Entity
	{
		private var ident:int;
		[Embed(source = 'assets/SP1.png')] private const S_PLAYER1:Class;
		[Embed(source = 'assets/SP2.png')] private const S_PLAYER2:Class;
		
		public function Start(ident:int, pos:Array)
		{
			this.ident = ident;
			if (ident == 0) {
				graphic = new Image(S_PLAYER1);
			}
			else { // ident == 1
				graphic = new Image(S_PLAYER2);
			}
			x = pos[0] * GC.tileWidth;
			y = pos[1] * GC.tileHeight;
			type = "startplayer" + ident;
			layer = -1;
		}

		public function updateXY(pos:Array):void
		{
			x = pos[0] * GC.tileWidth;
			y = pos[1] * GC.tileHeight;
		}
	}
}
