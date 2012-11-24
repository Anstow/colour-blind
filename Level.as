package
{
	import net.flashpunk.World;
	
	public class Level extends World
	{
		private var ident:int = 0;
		public function Level ():void {
			init();
		}

		public function init ():void {
			for (var i:int = 0; i < 2; i++) {
				add(new Player(i, GC.levels[ident].players[i]));
			}

			add(new Map());
		}
	}
}
