package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class Player extends Entity
	{
		private var ident:int;
		[Embed(source = 'assets/P1.png')] private const PLAYER1:Class;
		[Embed(source = 'assets/P2.png')] private const PLAYER2:Class;
		
		public function Player(ident:int, pos:Array):void
		{
			this.ident = ident;
			if (ident == 0) {
				graphic = new Image(PLAYER1);
			}
			else { // ident == 1
				graphic = new Image(PLAYER2);
			}
			x = pos[0];
			y = pos[1];
			type = "player";
		}
		
		override public function update():void
		{
			
			super.update();
		}
	}
}
