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
			// TODO: make a recorded level for the background
			level = new Level(0, GC.levelData[0], Level.M_BUFFER);
			level.begin();
			graphic = (addGraphic(new Image(level.worldBuffer)).graphic as Image);
		}

		public function menu():void {
			// TODO: implement a menu and move to it
			removeAll();
// 			FP.world = new Level(0, GC.levelData[0]);
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
	}
}
				

// vim: foldmethod=indent:cindent
