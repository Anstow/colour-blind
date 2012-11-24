package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.Sfx;
	
	public class Player extends Entity
	{
		private var ident:int;
		private var vel:Array = [0, 0];
		private var onGround:Boolean = false;
		private var input:Object;
		[Embed(source = 'assets/P1s.png')] private const PLAYER1:Class;
		[Embed(source = 'assets/P2s.png')] private const PLAYER2:Class;
		[Embed(source = 'sfx/jump1.mp3')] private const JUMP1:Class;
		[Embed(source = 'sfx/jump2.mp3')] private const JUMP2:Class;
		private var jump:Sfx;
		
		private var isJumping:Boolean = false;
		private var jumpCounter:Number = 0;
		
		public function Player(ident:int, pos:Array)
		{
			this.ident = ident;
			if (ident == 0) {
				graphic = new Image(PLAYER1);
				jump = new Sfx(JUMP1);
			}
			else { // ident == 1
				graphic = new Image(PLAYER2);
				jump = new Sfx(JUMP2);
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
				var v:Number = (vel[1] + (e as Player).vel[1]) / 2;
				vel[1] = v;
				(e as Player).vel[1] = v;
			}
			if (vel[1] > 0) onGround = true;
			return true;
		}
		
		override public function moveCollideX (e:Entity):Boolean {
			if (e is Player) {
				var v:Number = (vel[0] + (e as Player).vel[0]) / 2;
				vel[0] = v;
				(e as Player).vel[0] = v;
			}
			return true;
		}
		
		override public function update():void
		{
			super.update();

			//Horizontal
			if (Input.check("left" + ident)) {
				if (onGround) {
					vel[0] -= GC.moveSpeed;
				} else {
					vel[0] -= GC.airSpeed;
				}
			}
			if (Input.check("right"+ident)) {
				if (onGround) {
					vel[0] += GC.moveSpeed;
				} else {
					vel[0] += GC.airSpeed;
				}
			}
			
			//**Jumping**
			if(!isJumping) {
				if (onGround && Input.pressed("up"+ident)) {
					jumpCounter = 0;
					isJumping = true;
					vel[1] -= GC.jumpSpeed;
					jump.play();
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
			if (onGround) {
				vel[0] *= GC.playerDamp[0];
				vel[1] *= GC.playerDamp[1];
			}
			else {
				vel[0] *= GC.playerAirDamp[0];
				vel[1] *= GC.playerAirDamp[1];
			}
			var types:Array = ["level"];
			for (var i:int = 0; i < (world as Level).nPlayers; i++) {
				if (i == ident) {
					types.push("wall" + i);
				} else {
					types.push("player" + i);
				}
			}
			onGround = false;
			moveBy(vel[0], vel[1], types);
			
			//Pushing switches
			if (Input.pressed("down"+ident)) {
				var ss:Array = [];
				collideTypesInto(["switch" + ident], x, y, ss);
				for each (var s:Entity in ss) {
					(s as Switch).toggle();
				}
			}
			//Targets
			var t:Entity = collide("target" + ident, x, y);
			if (t) {
				world.remove(t);
				// check for remaining targets
				var nLeft:int = 0;
				var es:Array;
				for (i = 0; i < (world as Level).nPlayers; i++) {
					es = [];
					world.getType("target" + i, es);
					nLeft += es.length;
				}
				if (nLeft == 1) (world as Level).win();
			}
		}	
	}
}
