package
{
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.graphics.Image;

	public class LevelSelect extends World
	{
		private var levels:Array = [];
		private var currentLevel:int = 0; // 0 in ^levels, which doesn't include the title screen level
		private var levelGrid:Array = [];
		
		public function LevelSelect () {
			// organise in a grid
			var nLevels:int = GC.levelData.length - 1;
			var nCols:int = Math.ceil(Math.sqrt(nLevels));
			var nRows:int = Math.ceil(nLevels / nCols);
			var pad:int = GC.levelSelectThumbPadding;
			// get the scale: take the space available on each axis then round down and take the smallest
			var w:int = (GC.windowWidth - (nCols - 1) * pad) / nCols;
			var h:int = (GC.windowHeight - (nRows - 1) * pad) / nRows;
			var tScaleX:Number = Math.min(w / GC.windowWidth, h / GC.windowHeight);
			w = tScaleX * GC.windowWidth;
			h = tScaleX * GC.windowHeight;
			// scale individually to ensure we end up with integer dimensions and pixel-perfect padding
			tScaleX = w / GC.windowWidth;
			var tScaleY:Number = h / GC.windowHeight;
			var nThisRow:int = 0;
			// centre on the screen
			var x0:int = Math.round((GC.windowWidth - (nCols * w + (nCols - 1) * pad)) / 2);
			var x:int = x0
			var y:int = Math.round((GC.windowHeight - (nRows * h + (nRows - 1) * pad)) / 2);
			// generate levels and initial thumbnails
			var level:Level;
			var thumb:Image;
			var row:Array = [];
			levelGrid.push(row);
			for (var i:int = 1; i < nLevels + 1; i++) {
				row.push(i);
				level = new Level(i, GC.levelData[i], Level.M_BUFFERED | Level.M_PLAYBACK | Level.M_MUTED);
				// get something to render
				level.begin();
				level.updateLists();
				level.render();
				// grab the buffer out as an image
				thumb = addGraphic(new Image(level.worldBuffer)).graphic as Image;
				thumb.scaleX = tScaleX;
				thumb.scaleY = tScaleY;
				thumb.x = x;
				thumb.y = y;
				thumb.updateBuffer();
				levels.push([level, thumb]);
				nThisRow++;
				x += w + pad;
				if (nThisRow == nCols) {
					x = x0;
					y += h + pad;
					nThisRow = 0;
					row = [];
					levelGrid.push(row);
				}
			}
			// last row might be empty
			if (levelGrid[levelGrid.length - 1].length == 0) {
				levelGrid.pop();
			}
		}

		override public function update ():void {
			// input
			if (Input.pressed(Key.SPACE)) {
				// start selected level
				removeAll();
				FP.world = new Level(currentLevel + 1, GC.levelData[currentLevel + 1]);
			}
			// update selected level (TODO: highlight it in some way)
			var level:Level = levels[currentLevel][0];
			level.update();
			level.updateLists();
			level.render();
			levels[currentLevel][1].updateBuffer();
		}
	}
}

// vim: foldmethod=indent:cindent
