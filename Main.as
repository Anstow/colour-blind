package
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	[SWF(width='960', height='540')]
	public class Main extends Engine
	{
		public function Main():void
		{
			super(GC.windowWidth, GC.windowHeight, GC.FPS, true);
			FP.world = new Level();
		}
	}
	
}
