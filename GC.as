package
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
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

		// graphics
		public static var tileWidth:int = 20;
		public static var tileHeight:int = 20;
		public static var tiles:Image;
		[Embed(source = 'assets/tilemap.png')] public static const TILES:Class;
		[Embed(source = 'assets/gridpic.png')] public static const GRID:Class;
		public static var wallColours:Array = [0xcf4759, 0x5dd368, 0x38c9d1];

		// gameplay
		public static var gravity:Number = .7;
		public static var playerDamp:Array = [.7, .9]; //Damping when onGround
		public static var playerAirDamp:Array = [.9, .9]; //Damping when !onGround
		public static var littleJump:Number = 9;
		public static var moveSpeed:Number = 1.5;
		public static var airSpeed:Number = .5;
		public static var littleJumpSpeed:Number = 1.6;
		public static var jumpSpeed:Number = 6;

		// menus
		public static var levelSelectThumbPadding:int = 2;
		
		public static var inputKeys:Object = {
			// The keys for player 0
			up0: [Key.W, 188],
			left0: [Key.A],
			down0: [Key.S, Key.O],
			right0: [Key.D, Key.E],
			// The keys for player 1
			up1: [Key.UP],
			left1: [Key.LEFT],
			down1: [Key.DOWN],
			right1: [Key.RIGHT],
			// Other used keys
			skip: [191, 192],
			restart: [Key.R, Key.P],
			editor: [Key.F2],
			mute: [Key.M]
		};
		
		// Editor stuff
		public static var numTextSize:int = tileHeight / 2;
		public static var numTextColour:int = 0x000000;
		// The scrolling constants
		public static var scrollOn : Boolean; // Whether the scrolling is on or not
		public static var scrollSpeed : Number; // Pixels per frame.
		public static var scrollSens : Number; // How close to the edge of the screen before scrolling starts.

		public function GC ():void
		{
			
		}

		public static function loadLevelData():void {
			if (!isLoaded) {
				levelData = com.adobe.serialization.json.JSON.decode((new LEVELDATA() as ByteArray).toString()) as Array;
				isLoaded = true;
			}
			// also sneakily define key aliases in here
			for (var k:String in inputKeys) {
				var args:Array = inputKeys[k].slice();
				args.unshift(k);
				Input.define.apply(null, args);
				
			}
		}
		
	}
}

// vim: foldmethod=indent:cindent
