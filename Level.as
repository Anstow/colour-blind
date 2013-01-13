package
{
	import net.flashpunk.World;
	import Editor.LoadableWorld;
	import Editor.EditWorld;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.graphics.Spritemap;
	
	public class Level extends LoadableWorld
	{
		public var nPlayers:int = 2;
		public var players:Array = [];
		private var savedData:Array;
		private var winning:Boolean = false;
		public var input:GameInput;

		public function Level (id:int, data:Object, mode:int=0) {
			super(id, data);
			// The game input is defined here 0 is the normal mode
			input = new GameInput(mode);
			add(input);

			var p:Player;
			for (var i:int = 0; i < 2; i++) {
				p = new Player(i, playersStart[i],input);
				add(p);
				players.push(p);
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
			FP.world = new Level(i, GC.levelData[i]);
		}

		public function reset():void {
			FP.world = new Level(ident, data);
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
			if (input.released("editor"))
			{
				removeAll();
				FP.world = new EditWorld(ident, data);
			}
		}
	}
}

// vim: foldmethod=indent:cindent
