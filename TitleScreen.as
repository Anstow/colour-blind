package
{
	import net.flashpunk.World;
	import net.flashpunk.FP;
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
			// TODO: Increase this or change to on click
			//FP.alarm(0.5, menu);
		}

		public function menu():void {
			// TODO: implement a menu and move to it
			removeAll();
			FP.world = new Level(0, GC.levelData[0]);
		}

		override public function update():void {
			level.update();
			level.updateLists();
			level.render();
			graphic.updateBuffer();
		}
	}
}
				

// vim: foldmethod=indent:cindent
