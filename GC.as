package
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Key;
	import flash.utils.ByteArray;
	import com.adobe.serialization.json.JSON;

	/**
	 * ...
	 * @author David R. Walton
	 */
	import net.flashpunk.graphics.Image;
	public class GC
	{
		[Embed(source = 'leveldata.json', mimeType = "application/octet-stream")] private static const LEVELDATA:Class;
		public static var levelData:Array;
		private static var isLoaded:Boolean = false;

		public static var windowHeight:int = 540;
		public static var windowWidth:int = 960;
		public static var FPS:int = 60;

		public static var tileWidth:int = 20;
		public static var tileHeight:int = 20;
		public static var tiles:Image;
		[Embed(source = 'assets/tilemap.png')] public static const TILES:Class;
		public static var wallColours:Array = [0xdd0000, 0x5dd368, 0x38c9d1];
		
		public static var gravity:Number = .7;
		public static var playerDamp:Array = [.7, .9]; //Damping when onGround
		public static var playerAirDamp:Array = [.9, .9]; //Damping when !onGround
		public static var littleJump:Number = 10;
		public static var moveSpeed:Number = 1.5;
		public static var airSpeed:Number = .5;
		public static var littleJumpSpeed:Number = 2;
		public static var jumpSpeed:Number = 8;
		
		public static var moveKeys:Array = [
			{
				up: [Key.W, 188],
				left: [Key.A],
				down: [Key.S, Key.O],
				right: [Key.D, Key.E]
			}, {
				up: [Key.UP],
				left: [Key.LEFT],
				down: [Key.DOWN],
				right: [Key.RIGHT]
			}
		];
		
		// Editor stuff
		// The scrolling constants
		public static var scrollOn : Boolean; // Whether the scrolling is on or not
		public static var scrollSpeed : Number; // Pixels per frame.
		public static var scrollSens : Number; // How close to the edge of the screen before scrolling starts.
		
		// players are arrays of velocities
		// wall.rect are [x, y, width, height], measured in tiles
		public static var levels:Array = [
			{
				players: [[0, 5], [10, 0]],
				targets: [{
					type: 0,
					pos: [15, 10]
				}, {
					type: 1,
					pos: [16, 10]
				}], walls: [{
					type: 1,
					rect: [0, 20, 2, 3],
					buttons: [[0, 1], [2]]
				}, {
					type: 0,
					rect: [0, 10, 2, 3]
				}], switches: [{
					type: 0,
					pos: [8, 6],
					walls: [0]
				}, {
					type: 0,
					pos: [9, 6],
					walls: [0]
				}]
			}
		];

		public function GC ():void
		{
			
		}

		public static function loadLevelData():void {
			if (!isLoaded) {
				levelData = com.adobe.serialization.json.JSON.decode((new LEVELDATA() as ByteArray).toString()) as Array;
				isLoaded = true;
			}
		}
		
	}

}
