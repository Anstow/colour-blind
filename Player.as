package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import flash.utils.getQualifiedClassName;
	
	public class Player extends Entity
	{
		private var ident:int;
		private var vel:Array = [0, 0];
		private var onGround:Boolean = false;
		private var colTypes:Array;

		private var input:GameInput;

		[Embed(source = 'assets/P1.png')] private const PLAYER1:Class;
		[Embed(source = 'assets/P2.png')] private const PLAYER2:Class;
		[Embed(source = 'assets/P1_smile_spritemap.png')] private const MOUTH1:Class;
		[Embed(source = 'assets/P2_smile_spritemap.png')] private const MOUTH2:Class;
		[Embed(source = 'assets/P1_wink_spritemap.png')] private const EYES1:Class;
		[Embed(source = 'assets/P2_wink_spritemap.png')] private const EYES2:Class;
		public var mouth:Spritemap;
		public var eyes:Spritemap;

		[Embed(source = 'sfx/jump1.mp3')] private const JUMP1:Class;
		[Embed(source = 'sfx/jump2.mp3')] private const JUMP2:Class;
		[Embed(source = 'sfx/win.mp3')] private const WIN:Class;
		[Embed(source = 'sfx/die.mp3')] private const DIE:Class;
		private var jump:Sfx;
		private var win:Sfx = new Sfx(WIN);
		private var die:Sfx = new Sfx(DIE);
		private var muted:Boolean; // This is for when being rendered to a buffer and we don't want sound

		// Blinking and winking variables
		private var blinked:Boolean;
		private var winked:Boolean;
		
		private var isJumping:Boolean = false;
		private var jumpCounter:Number = 0;
		
		public function Player(ident:int, pos:Array, inp:GameInput, muted:Boolean) {
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
			mouth.x = 1;
			mouth.y = 13;
			addGraphic(mouth);
			eyes.add("anim", [0, 1, 2, 3]);
			eyes.setAnimFrame("anim", 0);
			eyes.x = 3;
			eyes.y = 4;
			addGraphic(eyes);
			x = pos[0] * GC.tileWidth + 1;
			y = pos[1] * GC.tileHeight + 1;

			input = inp;
			this.muted = muted;

			setHitbox(18, 38);
			type = "player" + ident;
			layer = -2;
			
			colTypes = ["level", "wall" + ident];
			for (var i:int = 0; i < 2; i++) {
				if (i != ident) {
					colTypes.push("player" + i);
				}
			}

			// Start blinking
			FP.alarm(Math.pow(Math.random() * 12.1,3), blink);
		}
		
		override public function moveCollideY (e:Entity):Boolean {
			if (vel[1] >= 0) {
				// stop moving
				vel[1] = 0;
			}
			// bounce off ceilings
			else if (vel[1] < 0) {
				vel[1] = Math.max(1, -vel[1]);
				isJumping = false;
			}
			return true;
		}
		
		override public function moveCollideX (e:Entity):Boolean {
			// other player
			if (e is Player) {
				var v:Number = (vel[0] + (e as Player).vel[0]) / 2;
				vel[0] = v;
				(e as Player).vel[0] = v;
			} else {
				vel[0] = 0;
			}
			return true;
		}
		
		override public function update():void {
			super.update();

			//Horizontal
			if (input.check("left" + ident)) {
				if (onGround) {
					vel[0] -= GC.moveSpeed;
				} else {
					vel[0] -= GC.airSpeed;
				}
			}
			if (input.check("right"+ident)) {
				if (onGround) {
					vel[0] += GC.moveSpeed;
				} else {
					vel[0] += GC.airSpeed;
				}
			}

			//**Jumping**
			if(!isJumping) {
				if (onGround && input.pressed("up"+ident)) {
					jumpCounter = 0;
					isJumping = true;
					vel[1] -= GC.jumpSpeed;
					if (!muted) {
						jump.play();
					}
				}
			}
			else if(input.check("up"+ident)) {
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

			// move
			onGround = false;
			moveBy(vel[0], vel[1], colTypes);
			// on ground check
			var cols:Array = [];
			collideTypesInto(colTypes, x, y + 1, cols);
			if (cols.length > 0) {
				onGround = true;
				for each (var e:Entity in cols) {
					// friction
					if (e is Player) {
						moveBy((e as Player).vel[0], 0, colTypes);
					}
				}
			}
			// target
			cols = [];
			collideTypesInto(["target" + ident], x, y, cols);
			for each (var t:Target in cols) {
				world.remove(t);
				(world as Level).nTargets -= 1;
				if (!muted) {
					win.play();
				}
			}
			if ((world as Level).nTargets == 0) {
				(world as Level).win();
			}
			// red wall
			cols = [];
			collideTypesInto(["wall-1"], x, y, cols);
			for each (var w:Wall in cols) {
				if (!muted) {
					die.play();
				}
				(world as Level).reset();
			}
			// pushing switches
			cols = [];
			if (input.pressed("down"+ident)) {
				collideTypesInto(["switch" + ident], x, y, cols);
				for each (var s:Entity in cols) {
					(s as Switch).toggle(muted);
				}
			}
		}

		public function blink():void {
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

		public function wink():void {
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

// vim: foldmethod=indent:cindent
