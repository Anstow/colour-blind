package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class Player extends Entity
	{
		private var isPlayer1:Boolean;
		
		public function Player(isPlayer1:Boolean):void
		{
			this.isPlayer1 = isPlayer1;
			if (isPlayer1) {
				
			}
			else {
				
			}
			type = "player";
		}
		
		override public function update():void
		{
			
			super.update();
		}
	}
}