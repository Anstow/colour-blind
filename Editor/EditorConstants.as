package Editor 
{
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author David
	 */
	public class EditorConstants 
	{
		public static var tilesAcross : uint = 5;
		
		public static var tileWidth : Number;
		public static var tileHeight : Number;
		public static var tiles : Image;
		public static var TILES: Class;
		
		public static var halfWidth : Number;
		public static var halfHeight : Number;
		
		// The scrolling constants
		public static var scrollOn : Boolean; // Whether the scrolling is on or not
		public static var scrollSpeed : Number; // Pixels per frame.
		public static var scrollSens : Number; // How close to the edge of the screen before scrolling starts.
		
		public static function init():void
		{			
			// TODO: Update this function when using editor.
			tileWidth = GameConstant.tileWidth;
			tileHeight = GameConstant.tileHeight;
			TILES = GameConstant.TILES;
			tiles = new Image(TILES);
			halfWidth = GameConstant.halfWidth;
			halfHeight = GameConstant.halfHeight;
			
			scrollOn = true;
			scrollSpeed = GameConstant.scrollSpeed;
			scrollSens = GameConstant.scrollSens;
		}
		
	}

}