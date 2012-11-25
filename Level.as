package {
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
		private var players:Array = [];
		private var savedData:Array;

		public function Level (id:int, data:Object) {
			super(id, data);
			var p:Player;
			for (var i:int = 0; i < 2; i++) {
				p = new Player(i, playersStart[i]);
				add(p);
				players.push(p);
			}
		}

		public function win():void {
			if (ident < GC.levelData.length - 1) {
				FP.world = new Level(ident + 1, data);
			} else {
				//**Make last level win screen :)**
				FP.world = new Level(0, data);
			}
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
			// This enables the editor it should be removed in the final version
			if (Input.released(Key.F2))
			{
				removeAll();
				FP.world = new EditWorld(ident, data);
			}
		}
	}
}
