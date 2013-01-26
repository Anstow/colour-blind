package
{
	import net.flashpunk.World;
	import Editor.LoadableWorld;
	import Editor.EditWorld;
	import net.flashpunk.FP;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import flash.display.BitmapData;
	
	public class Level extends LoadableWorld
	{
		// For normal game play
		public static const M_NORMAL:int=0;
		// For recording gameplay
		public static const M_RECORD:int=1;
		// For rendering to a buffer
		public static const M_BUFFER:int=2;
		// For rendering to a buffer without sound
		public static const M_BUFFER_MUTED:int=3;
		// For rendering to a buffer once
		public static const M_ONCE:int=4;

		public var nPlayers:int = 2;
		public var players:Array = [];
		public var nTargets:int;
		private var savedData:Array;
		private var winning:Boolean = false;
		private var input:GameInput;

		public var worldBuffer:BitmapData;
		private var mode:int;
		private var loadLevelCallback:Function;

		public function Level (id:int, data:Object, mode:int=M_NORMAL, loadLevelCallback:Function = null) {
			super(id, data);
			nTargets = targets.length;
			// The game input is defined here 0 is the normal mode
			this.mode = mode;
			switch (mode) {
				case M_BUFFER:
					input = new GameInput(GameInput.PLAYBACK);
					worldBuffer = new BitmapData(FP.width, FP.height, false, 0xFF202020);
					break;
				case M_RECORD:
					input = new GameInput(GameInput.RECORD);
					break;
				case M_ONCE:
					input = new GameInput(GameInput.FREEZE);
					break;
				case M_NORMAL:
				defined:
					input = new GameInput(GameInput.GAME_PLAY);
					break;
			}
			add(input);

			this.loadLevelCallback = loadLevelCallback;	

			var p:Player;
			for (var i:int = 0; i < 2; i++) {
				p = new Player(i, playersStart[i],input, mode == M_BUFFER_MUTED);
				add(p);
				players.push(p);
			}
			
			// Sets the entities to what they should be
			for each (var e:GameEvent in events) {
				e.toggleEntities();
			}
		}

		public function win():void {
			if (winning) return;
			winning = true;
			var i:int;
			if (ident < GC.levelData.length - 1) {
				i = ident + 1;
			} else {
				//**Make last level win screen :)**
				i = 0;
			}
			if (mode == M_NORMAL || mode == M_RECORD) {
				FP.world = new Level(i, GC.levelData[i]);
			} else if (loadLevelCallback != null) {
				loadLevelCallback(new Level(i, GC.levelData[i]));
			}
		}

		public function reset():void {
			if (mode == M_NORMAL || mode == M_RECORD) {
				FP.world = new Level(ident, data);
			} else if (loadLevelCallback != null) {
				loadLevelCallback(new Level(ident, data));
			}
		}

		override public function update():void
		{
			super.update();
			// set player happiness
			var sep:Number = Math.sqrt(Math.pow(players[1].centerX - players[0].centerX, 2) + Math.pow(players[1].centerY - players[0].centerY, 2));
			var i:int = Math.min(8, Math.max(0, int(.009 * (1000 - sep))));
			for each (var p:Player in players) {
				(p.mouth as Spritemap).setAnimFrame("anim", i);
			}
			// reset key
			if (input.pressed("restart")) {
				reset();
			}
			// mute key
			if (input.pressed("mute")) {
				if (FP.volume == 0) FP.volume = 1;
				else FP.volume = 0;
			}
			// This enables the editor it should be removed in the final version
			if (input.released("editor")) {
				removeAll();
				if (mode == M_NORMAL || mode == M_RECORD) {
					FP.world = new EditWorld(ident, data);
				} else if (loadLevelCallback != null) {
					loadLevelCallback(new EditWorld(ident, data));
				}
			}
		}

		//{ Overriden for advanced buffering functions
		
		// We override the add function to make the entity draw to a buffer
	   	// instead of the screen 
		public override function add(e:Entity):Entity {
			e.renderTarget = worldBuffer;
			return super.add(e);
		}

		//}
	}
}

// vim: foldmethod=indent:cindent
