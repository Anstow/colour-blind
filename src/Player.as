package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class Player extends Entity
	{
		private var isPlayer1:Boolean;
		[Embed(source = 'assets/P1.png')] private const PLAYER1:Class;
		[Embed(source = 'assets/P2.png')] private const PLAYER2:Class;
		
		public function Player(isPlayer1:Boolean):void
		{
			this.isPlayer1 = isPlayer1;
			if (isPlayer1) {
				graphic = new Image(PLAYER1);
			}
			else {
				graphic = new Image(PLAYER2);
			}
			type = "player";
		}
		
		override public function update():void
		{
			
			super.update();
		}
	}
}