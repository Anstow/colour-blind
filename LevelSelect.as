package
{
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	public class LevelSelect extends World
	{
		private var levels:Array = [];
		
		public function LevelSelect () {
			var level:Level;
			var thumb:Image;
			level = new Level(0, GC.levelData[0], Level.M_BUFFER);
			level.begin();
			thumb = addGraphic(new Image(level.worldBuffer)).graphic as Image;
			thumb.scale = .5;
			levels.push([level, thumb]);

			level = new Level(1, GC.levelData[1], Level.M_BUFFER);
			level.begin();
			thumb = addGraphic(new Image(level.worldBuffer)).graphic as Image;
			thumb.scale = .5;
			thumb.x = 960 / 2;
			levels.push([level, thumb]);

			level = new Level(2, GC.levelData[2], Level.M_BUFFER);
			level.begin();
			thumb = addGraphic(new Image(level.worldBuffer)).graphic as Image;
			thumb.scale = .5;
			thumb.y = 540 / 2;
			levels.push([level, thumb]);

			level = new Level(3, GC.levelData[3], Level.M_BUFFER);
			level.begin();
			thumb = addGraphic(new Image(level.worldBuffer)).graphic as Image;
			thumb.scale = .5;
			thumb.x = 960 / 2;
			thumb.y = 540 / 2;
			levels.push([level, thumb]);
		}

		override public function update ():void {
			var level:Level;
			var thumb:Image;
			for each (var data:Array in levels) {
				level = data[0];
				thumb = data[1];
				level.update();
				level.updateLists();
				level.render();
				thumb.updateBuffer();
			}
		}
	}
}
