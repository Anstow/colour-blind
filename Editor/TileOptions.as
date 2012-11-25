package Editor 
{
	import net.flashpunk.Entity;
	import Editor.EditorConstants;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	
	/**
	 * ...
	 * @author David
	 */
	public class TileOptions extends Entity 
	{
		public var tiles : Tilemap;
		public var noTiles : int;
		
		public function TileOptions() 
		{
			super();
			
			noTiles = (EditorConstants.tiles.width / EditorConstants.tileWidth) * ( EditorConstants.tiles.height / EditorConstants.tileHeight);
			
			if (noTiles <= EditorConstants.tilesAcross)
			{				
				setHitbox(noTiles * EditorConstants.tileWidth, 1 * EditorConstants.tileHeight, -5, -5);
			}
			else
			{
				setHitbox(EditorConstants.tilesAcross * EditorConstants.tileWidth, Math.ceil(noTiles / EditorConstants.tilesAcross) * EditorConstants.tileHeight, -5, -5);
			}
			
			
			tiles = new Tilemap(EditorConstants.TILES, width, height, EditorConstants.tileWidth, EditorConstants.tileHeight);			
			for (var i : int = 0; i < noTiles; i++)
			{
				tiles.setTile(i % EditorConstants.tilesAcross, int(i / EditorConstants.tilesAcross), i);
			}
			
			layer = -5;
			
			x = EditorConstants.halfWidth - halfWidth - 5;
			y = EditorConstants.halfHeight - halfHeight - 5;
			
			tiles.x = 5;
			tiles.y = 5;
			
			addGraphic(Image.createRect(width + 10, height + 10, 0x000040));
			addGraphic(tiles);
			type = "tileChoice";
		}
		
		public function getTile(clickX : Number, clickY : Number) : int
		{
			if (collidePoint(x, y, clickX, clickY))
			{
				// The put the click position relative to the rectangles
				// 0 based
				
				clickX -= x  - originX;
				clickY -= y - originY;
				
				// The across component, then the down component
				var toReturn : int = Math.floor(clickX / EditorConstants.tileWidth) + Math.floor(clickY / EditorConstants.tileHeight) * EditorConstants.tilesAcross;
				
				// The equals is because toReturn is 0 based and noTiles in 1 based 
				if (toReturn >= noTiles)
				{
					// If you've not clicked on a tile return -1 but in the right area
					return -1;
				}
				else
				{
					return toReturn;
				}
			}
			return -1;
		}
		
	}

}
