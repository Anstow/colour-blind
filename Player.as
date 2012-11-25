package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.Sfx;
	
	public class Player extends Entity
	{
		private var ident:int;
		private var vel:Array = [0, 0];
		private var onGround:Boolean = false;
		private var input:Object;
		[Embed(source = 'assets/P1.png')] private const PLAYER1:Class;
		[Embed(source = 'assets/P2.png')] private const PLAYER2:Class;
		[Embed(source = 'assets/P1_smile_spritemap.png')] private const MOUTH1:Class;
		[Embed(source = 'assets/P2_smile_spritemap.png')] private const MOUTH2:Class;
		[Embed(source = 'assets/P1_wink_spritemap.png')] private const EYES1:Class;
		[Embed(source = 'assets/P2_wink_spritemap.png')] private const EYES2:Class;
		[Embed(source = 'sfx/jump1.mp3')] private const JUMP1:Class;
		[Embed(source = 'sfx/jump2.mp3')] private const JUMP2:Class;
		[Embed(source = 'sfx/win.mp3')] private const WIN:Class;
		[Embed(source = 'sfx/die.mp3')] private const DIE:Class;
		private var jump:Sfx;
		private var win:Sfx = new Sfx(WIN);
		private var die:Sfx = new Sfx(DIE);
		public var mouth:Spritemap;
		public var eyes:Spritemap;

		// Blinking and winking variables
		private var blinked:Boolean;
		private var winked:Boolean;
		
		private var isJumping:Boolean = false;
		private var jumpCounter:Number = 0;
		
		public function Player(ident:int, pos:Array)
		{
			this.ident = ident;
			if (ident == 0) {
				addGraphic(new Image(PLAYER1));
				mouth = new Spritemap(MOUTH1, 16, 5);
				eyes = new Spritemap(EYES1, 12, 3);
				jump = new Sfx(JUMP1);
			}
			else { // ident == 1
				addGraphic(new Image(PLAYER2));
				mouth = new Spritemap(MOUTH2, 16, 5);
				eyes = new Spritemap(EYES2, 12, 3);
				jump = new Sfx(JUMP2);
			}
			mouth.add("anim", [0, 1, 2, 3, 4, 5, 6, 7, 8]);
			mouth.setAnimFrame("anim", 0);
			mouth.x = 2;
			mouth.y = 14;
			addGraphic(mouth);
			eyes.add("anim", [0, 1, 2, 3]);
			eyes.setAnimFrame("anim", 0);
			eyes.x = 4;
			eyes.y = 5;
			addGraphic(eyes);
			x = pos[0] * GC.tileWidth;
			y = pos[1] * GC.tileHeight;
			input = GC.moveKeys[ident];
			for (var key:String in input) {
				Input.define.apply(null, [key+ident].concat(input[key]));
			}
			
			setHitbox(20, 40);
			type = "player" + ident;
			layer = -2;

			// Start blinking
			FP.alarm(Math.pow(Math.random() * 12.1,3), blink);
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
					die.play();
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
			if (vel[1] > 0 && (!(e is Player) || (e as Player).onGround)) {
				onGround = true;
			}
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
		}

		public function blink():void
		{
			if (blinked)
			{
				eyes.setAnimFrame("anim", 0);
				FP.alarm(Math.pow(Math.random() * 12.1,3), blink);
			}
			else
			{
				winked = false;

				eyes.setAnimFrame("anim", 1);
				FP.alarm(10,blink);
			}

			blinked = !blinked;
		}

		public function wink():void
		{
			if (winked)
			{
				eyes.setAnimFrame("anim",0);
			}
			else
			{
				blinked = false;

				eyes.setAnimFrame("anim", FP.rand(2));
				FP.alarm(0.5,blink);
			}

			winked = !winked;
		}
	}
}
