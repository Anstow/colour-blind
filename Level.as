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
		// Muted
		public static const M_MUTED:int = 1;
		// Buffered
		public static const M_BUFFERED:int = 2;
		// ONCE
		public static const M_ONCE:int = 4;
		// Playback
		public static const M_PLAYBACK:int = 8;
		// Record
		public static const M_RECORD:int = 16;

		public var nPlayers:int = 2;
		public var players:Array = [];
		public var nTargets:int;
		private var winning:Boolean = false;
		private var input:GameInput;

		public var worldBuffer:BitmapData;
		private var mode:int;
		private var loadLevelCallback:Function;

		public function Level (id:int, data:Object, mode:int=0, loadLevelCallback:Function = null) {
			// The game input is defined here 0 is the normal mode
			this.mode = mode;
			if (mode & M_BUFFERED) {
				worldBuffer = new BitmapData(FP.width, FP.height, false, 0xFF202020);
			}
			if (mode & M_PLAYBACK) {
				input = new GameInput(GameInput.PLAYBACK);
				if (data.replay !== undefined) {
					input.loadPlaybackData(data.replay);
				}
			} else if (mode & M_RECORD) {
				input = new GameInput(GameInput.RECORD);
			} else {
				input = new GameInput(GameInput.GAME_PLAY);
			}

			super(id, data);
			nTargets = targets.length;
			add(input);

			this.loadLevelCallback = loadLevelCallback;	

			var p:Player;
			for (var i:int = 0; i < 2; i++) {
				p = new Player(i, playersStart[i], input, 0 != (mode & M_MUTED));
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
				// TODO: go back to title screen
				i = 1;
			}
			if (mode & M_BUFFERED) {
				loadLevelCallback(new Level(i, GC.levelData[i]));
			} else if (mode & M_RECORD) {
				if (input.getPlaybackData()) {
					data.replay = input.getPlaybackData();
				}
				FP.world = new EditWorld(ident, data);
			} else if (mode & M_PLAYBACK) { // We're playing back but we're not buffered
				FP.world = new EditWorld(ident, data);
			} else {
				FP.world = new Level(i, GC.levelData[i]);
			}
		}

		public function reset():void {
			if (mode & M_BUFFERED) {
				loadLevelCallback(new Level(ident, data));
			} else if (mode & M_RECORD) {
				if (input.getPlaybackData()) {
					data.replay = input.getPlaybackData();
				}
				FP.world = new EditWorld(ident, data);
			} else if (mode & M_PLAYBACK) { // We're playing back but we're not buffered
				FP.world = new EditWorld(ident, data);
			} else {
				FP.world = new Level(ident, data);
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
			// skip level key - remove in the final version
			if (input.pressed("skip")) {
				win();
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
			// editor
			if (input.released("editor")) {
				removeAll();
				if (mode & M_BUFFERED) {
					loadLevelCallback(new EditWorld(ident, data));
				} else if (mode & M_RECORD) {
					if (input.getPlaybackData()) {
						data.replay = input.getPlaybackData();
					}
					FP.world = new EditWorld(ident, data);
				} else if (mode & M_PLAYBACK) { // We're playing back but we're not buffered
					FP.world = new EditWorld(ident, data);
				} else {
					FP.world = new EditWorld(ident, data);
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
