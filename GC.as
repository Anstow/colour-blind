package  
{
	import net.flashpunk.graphics.Image;

	/**
	 * ...
	 * @author David R. Walton
	 */
	public class GC
	{
		public static var windowHeight:int = 540;
		public static var windowWidth:int = 960;
		public static var FPS:int = 60;

		public static var tileWidth:int = 20;
		public static var tileHeight:int = 20;
		public static var tiles : Image;
		[Embed(source = 'assets/tilemap.png')] public static const TILES: Class;
		

		public static var levels:Array = [
			{
				players: [[0, 30], [0, 0]]
			}
		];

		public function GC() 
		{
			
		}
		
	}

}
