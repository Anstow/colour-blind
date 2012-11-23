package
{
	import net.flashpunk.World;
	
	public class Level extends World
	{
		public function Level ():void {
			add(new Player(true));
			add(new Player(false));
		}
	}
}
