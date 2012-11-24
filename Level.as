package
{
	import net.flashpunk.World;
	
	public class Level extends World
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

			add(new Map());
		}
	}
}
