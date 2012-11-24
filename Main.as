package
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	[SWF(width = '960', height = '540')]
	public class Main extends Engine
	{
	[Embed(source = 'sfx/music.mp3')] const	MUSIC:Class;
	var music = new Sfx(MUSIC);
		public function Main():void
		{
			GC.loadLevelData();
			super(GC.windowWidth, GC.windowHeight, GC.FPS, true);
			music.loop();
			FP.world = new Level(0, GC.levelData[0]);
		}
	}
	
}
