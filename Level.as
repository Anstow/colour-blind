package
{
	import net.flashpunk.World;
	import Editor.LoadableWorld;
	
	public class Level extends LoadableWorld
	{
		private var ident:int = 0;
		public var playerTypes:Array = [];

		public function Level ():void {
			init();
		}

		public function init ():void {
			for (var i:int = 0; i < 2; i++) {
				add(new Player(i, GC.levels[ident].players[i]));
				playerTypes.push("player" + i);
			}

			currentMap = new Map();
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
