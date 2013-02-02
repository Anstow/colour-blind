package
{
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.graphics.Image;
	
	public class TitleScreen extends World
	{
		private var level:Level;
		private var graphic:Image;
		
		public function TitleScreen() {
			level = new Level(0, GC.levelData[0], Level.M_BUFFERED | Level.M_PLAYBACK, resetLevel);
			level.begin();
			graphic = (addGraphic(new Image(level.worldBuffer)).graphic as Image);
		}

		public function menu():void {
			// TODO: implement a menu and move to it
			removeAll();
			FP.world = new LevelSelect();
		}

		override public function update():void {
			if (Input.pressed(Key.SPACE)) {
				menu();
			}
			level.update();
			level.updateLists();
			level.render();
			graphic.updateBuffer();
		}

		public function resetLevel(tmp:Level = null):void {
			level.removeAll();
			level.end();
			level.updateLists();
			level = new Level(0, GC.levelData[0], Level.M_BUFFERED | Level.M_PLAYBACK, resetLevel);
			level.begin();
			level.updateLists();
			graphic = (addGraphic(new Image(level.worldBuffer)).graphic as Image);
		}
	}
}
				

// vim: foldmethod=indent:cindent
