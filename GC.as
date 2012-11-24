package
{
	import net.flashpunk.graphics.Image;

	/**
	 * ...
	 * @author David R. Walton
	 */
	import net.flashpunk.graphics.Image;
	public class GC
	{
		public static var windowHeight:int = 540;
		public static var windowWidth:int = 960;
		public static var FPS:int = 60;

		public static var tileWidth:int = 20;
		public static var tileHeight:int = 20;
		public static var tiles:Image;
		[Embed(source = 'assets/tilemap.png')] public static const TILES:Class;
		public static var playerColours:Array = [0x5dd368, 0x38c9d1];

		// players are arrays of velocities
		// walls are arrays of [type, [x, y, width, height]], width and height
		// measured in tiles
		public static var levels:Array = [
			{
				players: [[0, 0], [0, 100]],
				walls: [[1, [0, 20, 2, 3]], [0, [0, 10, 2, 3]]]
			}
		];
		
		public static var gravity:Number = .7;
		public static var playerDamp:Array = [.9, .9];
		
		public function GC ():void
		{
			
		}
		
	}

}
