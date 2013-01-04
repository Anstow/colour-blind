package
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	[SWF(width = '960', height = '540')]
	public class Main extends Engine
	{
		[Embed(source = 'sfx/music.mp3')] private const MUSIC:Class;
		private var music:Sfx;

		public function Main():void
		{
			GC.loadLevelData();
			super(GC.windowWidth, GC.windowHeight, GC.FPS, true);
			music = new Sfx(MUSIC);
			//music.loop();
			FP.world = new Level(0, GC.levelData[0]);
		}
	}
}

// vim: foldmethod=indent:cindent
