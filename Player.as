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
		[Embed(source = 'sfx/win.mp3')] private const WIN:Class;
		private var jump:Sfx;
		private var win:Sfx = new Sfx(WIN);
		
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

		public function moveCollide (e:Entity, axis:int):Boolean {
			// other player
			if (e is Player) {
				var v:Number = (vel[axis] + (e as Player).vel[axis]) / 2;
				vel[axis] = v;
				(e as Player).vel[axis] = v;
			}
			else if (e is Wall) {
				if ((e as Wall).ident == -1) {
					(world as Level).reset();
					return false;
				}
			}
			// targets
			else if (e is Target) {
				world.remove(e);
				// check for remaining targets
				var nLeft:int = 0;
				var es:Array;
				for (var i:int = 0; i < (world as Level).nPlayers; i++) {
					es = [];
					world.getType("target" + i, es);
					nLeft += es.length;
				}
				if (nLeft == 1) (world as Level).win();
				return false;
			}
			return true;
		}
		
		override public function moveCollideY (e:Entity):Boolean {
			if (!moveCollide(e, 1)) {
				return false;
			}
			if (vel[1] > 0) onGround = true;
			return true;
		}
		
		override public function moveCollideX (e:Entity):Boolean {
			return moveCollide(e, 0);
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
			var types:Array = ["level", "wall" + ident, "target" + ident, "wall-1"];
			for (var i:int = 0; i < (world as Level).nPlayers; i++) {
				if (i != ident) {
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
<<<<<<< HEAD
			//Targets
			var t:Entity = collide("target" + ident, x, y);
			if (t) {
				win.play();
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
=======
>>>>>>> 38dc0969433439e9798b0ceea612b32080f6fdb8
		}	
	}
}
