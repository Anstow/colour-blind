package
{
	import net.flashpunk.World;
	import Editor.LoadableWorld;
	
	public class Level extends LoadableWorld
	{
		private var ident:int = 0;
		public var nPlayers:int = 2;

		public function Level ():void {
			init();
		}

		public function init ():void {
			var data:Object = GC.levels[ident];
			for (var i:int = 0; i < 2; i++) {
				add(new Player(i, data.players[i]));
			}
			for each (var wData:Array in data.walls) {
				add(new Wall(wData[0], wData[1]));
			}

			currentMap = new Map(ident);
			add(currentMap);
		}

		override public function update():void
		{
			// This enables the editor it should be removed in the final version
			if (Input.released(Key.F5))
			{
				remove(currentMap);
				FP.world = new EditorWorld(currentMap);
			}
		}
	}
}
