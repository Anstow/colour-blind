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
		private var vel:Array = [0, 0];
		private var onGround:Boolean = false;
		private var input:Object;
		[Embed(source = 'assets/P1.png')] private const PLAYER1:Class;
		[Embed(source = 'assets/P2.png')] private const PLAYER2:Class;
		
		private var isJumping:Boolean = false;
		private var jumpCounter:Number = 0;
		
		public function Player(ident:int, pos:Array):void
		{
			this.ident = ident;
			if (ident == 0) {
				graphic = new Image(PLAYER1);
			}
			else { // ident == 1
				graphic = new Image(PLAYER2);
			}
			x = pos[0] * GC.tileWidth;
			y = pos[1] * GC.tileHeight;
			input = GC.moveKeys[ident];
			for (var key:String in input) {
				Input.define.apply(null, [key+ident].concat(input[key]));
			}
			
			setHitbox(20, 40);
			type = "player" + ident;
			layer = -1;
		}
		
		override public function moveCollideY (e:Entity):Boolean {
			if (e is Player) {
				// TODO: average velocity
			}
			if (vel[1] > 0) onGround = true;
			return true;
		}
		
		override public function update():void
		{
			super.update();

			//Horizontal
			if (Input.check("left" + ident)) {
				vel[0] -= GC.moveSpeed;
			}
			if (Input.check("right"+ident)) {
				vel[0] += GC.moveSpeed;
			}
			
			//**Jumping**
			if(!isJumping) {
				if (onGround && Input.pressed("up"+ident)) {
					onGround = false;
					jumpCounter = 0;
					isJumping = true;
					vel[1] -= GC.jumpSpeed;
				}
			}
			else if(Input.check("up"+ident)) {
				jumpCounter++;
				if (jumpCounter <= GC.littleJump) {
					vel[1] -= GC.littleJumpSpeed;
				}
				else {
					isJumping = false;
				}
			}
			else {
				isJumping = false;
			}
			
			vel[1] += GC.gravity;
			vel[0] *= GC.playerDamp[0];
			vel[1] *= GC.playerDamp[1];
			var types:Array = ["level"];
			for (var i:int = 0; i < (world as Level).nPlayers; i++) {
				if (i == ident) {
					types.push("wall" + i);
				} else {
					types.push("player" + i);
				}
			}
			moveBy(vel[0], vel[1], types);				
		}	
	}
}
