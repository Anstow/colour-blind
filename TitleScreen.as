package
{
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	public class TitleScreen extends World 
	{
		
		public function TitleScreen() {
			// TODO: make a recorded level for the background
			addGraphic(new Image(GC.TITLE_SCREEN));

			// TODO: Increase this or change to on click
			FP.alarm(0.5, menu);
		}

		public function menu():void {
			// TODO: implement a menu and move to it
			removeAll();
			FP.world = new Level(0, GC.levelData[0]);
		}
	}
}
				

// vim: foldmethod=indent:cindent
