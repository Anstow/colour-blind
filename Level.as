package
{
	import net.flashpunk.World;
	
	public class Level extends World
	{
		public function Level ():void {
			add(new Player(true,110,100));
			add(new Player(false,150,100));
		}
	}
}
