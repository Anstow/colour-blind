package
{
	import Editor.EditorConstants;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	
	/**
	 * ...
	 * @author David
	 */
	public class Map extends Entity 
	{
		public var tiles: Tilemap;

		// Level width and height code
		public static var levelWidth : int = GC.windowWidth;
		public static var levelHeight : int = GC.windowHeight;
		public static var scrollable : Boolean = false;

		
		public function Map(level : int)
		{
			super();
			tiles = new Tilemap(GC.TILES, levelWidth, levelHeight, GC.tileWidth, GC.tileHeight);
			
			tiles.setRect(0, 0, tiles.columns, tiles.rows);
			tiles.setRect(0, 30, tiles.columns, 5, 1);
			//setLevel(level);
			
			addGraphic(tiles);
			layer = 1;
			
			mask = tiles.createGrid( [ 1 ], null);
			type = "level";
		}
		
		public function updateColisions() : void 
		{
			mask = tiles.createGrid( [ 1 ], null);
		}
		
		//{ Creating level code
		
		//	CONFIG::debug
		public function	setLevel(data : int):void
		{
			tiles.loadFromString(data as String);
		}
		
		// 	CONFIG::debug
		public function getSaveData():String
		{
			return tiles.saveToString();
		}
		
		// 	CONFIG::debug
		public function setTiles(x1:int, y1:int, x2:int, y2:int, tile : int = 0):void
		{
			tiles.setRect(Math.min(x1, x2), Math.min(y1, y2), Math.abs(x1 - x2) + 1, Math.abs(y1 - y2) + 1, tile);
		}
		
		//}
		
		/**
		 * Finds the x component of the selected position in the level.
		 * @param	clickX : The x component of the point selected.
		 * @return
		 */
		public function getTileX(clickX : Number):int
		{
			// Sets the click relative to the origin of the shape
			clickX -= x - originX;
			
			return Math.floor(clickX / EditorConstants.tileWidth);
		}
		
		/**
		 * Finds the y component of the selected position in the level.
		 * @param	clickY : The y component of the point selected.
		 * @return
		 */
		public function getTileY(clickY : Number):int
		{
			// Sets the click relative to the origin of the shape
			clickY -= y  - originY;
			
			return Math.floor(clickY / EditorConstants.tileHeight);
		}
	
		//{ Level scrollable
		public function scrollHorizontal(speed : Number, boundRight : Number):void
		{
			if (scrollable)
			{
				if (speed > 0) 
				{
					// Moving right
					if (FP.camera.x + speed >= tiles.width - boundRight)
					{
						// If the movement would move us outside the allowed area limit it to the allowed area
						FP.camera.x = tiles.width - boundRight;
					}
					else
					{
						FP.camera.x += speed;
					}
				}
				else if (speed < 0)
				{
					// Moving left
					if (FP.camera.x + speed <= 0)
					{
						// If the movement would take us outside the left bound limmit it to 0
						FP.camera.x = 0;
					}
					else
					{
						FP.camera.x += speed;
					}
				}
			}
		}
		
		public function scrollVertical(speed : Number, boundBot : Number):void
		{
			if (scrollable)
			{
				if (speed > 0) 
				{
					// Moving down
					if (FP.camera.y + speed >= tiles.height - boundBot)
					{
						// If the movement would move us outside the allowed area limit it to the allowed area
						FP.camera.y = tiles.height - boundBot;
					}
					else
					{
						FP.camera.y += speed;
					}
				}
				else if (speed < 0)
				{
					// Moving up
					if (FP.camera.y + speed <= 0)
					{
						// If the movement would take us outside the left bound limmit it to 0
						FP.camera.y = 0;
					}
					else
					{
						FP.camera.y += speed;
					}
				}
			}
		}
		//}
	}

}
