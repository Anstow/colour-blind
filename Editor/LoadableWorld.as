package Editor
{
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Input;

	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.net.FileReference;
	import com.adobe.serialization.json.JSON;
	
	/**
	 * ...
	 * @author David
	 */
	public class LoadableWorld extends World 
	{
		public var currentMap : Map; // I also think it would be useful to have a handle to my level
		protected var data:Object;
		public var walls:Array = new Array();
		public var playersStart: Array = new Array();
		public var switches:Array = new Array();
		public var targets:Array = new Array();
		public var editting :Boolean = false;

		public var ident:int = 0;
		
		public function LoadableWorld(id:int, data:Object)
		{
			EditorConstants.init();
			ident = id;
			init(data);
		}

		public function init(data:Object):void {
			this.data = data;
			
			for (var i:int = 0; i < 2; i++) {
				playersStart.push(data.players[i]);
			}
			for each (var wData:Object in data.walls) {
				walls.push(new Wall(wData));
			}
			for (i = 0; i < data.switches.length; i++) {
				trace("c", data.switches[i].walls);
				switches.push(new Switch(i, data.switches[i]));
			}
			for each (var target:Object in data.targets) {
				targets.push(new Target(target));
			}

			for each (var w:Wall in walls) {
				add(w);
				for each (var bgs:Array in [w.allButtons, w.pressedButtons]) {
					for each (var bs:Array in bgs) {
						for (i = 0; i < bs.length; i++) {
							bs[i] = switches[bs[i]];
						}
					}
				}
			}
			for each (var s:Switch in switches) {
				add(s);
				trace("a", this is EditWorld, s.ident, s.walls.length, s.walls[0]);
				for (i = 0; i < s.walls.length; i++) {
					s.walls[i] = walls[s.walls[i]];
				}
				trace(" ", this is EditWorld, s.ident, s.walls.length, s.walls[0]);
			}
			for each (var t:Target in targets) {
				add(t);
			}
			currentMap = new Map();
			currentMap.setLevel(data.tilemap);
			add(currentMap);
		}
		
		//{ Scroll Functions
		public function scrollHorizontal(bound : Number):Boolean
		{
			// The extra FP.camera.x terms are becase mouseX is based on the camera location 
			if (mouseX - FP.camera.x > 0 && mouseX - FP.camera.x <= FP.width)
			{
				// Valid mouse position
				var speed : Number;
				
				if (mouseX - FP.camera.x < GC.scrollSens)
				{
					// We would like to scroll left (-'ve)
					speed = - GC.scrollSpeed * (1 -(mouseX - FP.camera.x)/ GC.scrollSens);
					currentMap.scrollHorizontal(speed, bound);
					return true;
				}
				else if (mouseX - FP.camera.x > FP.width - GC.scrollSens)
				{
					// We would like to scroll right (+'ve)
					speed = GC.scrollSpeed * (1 - (FP.width - (mouseX - FP.camera.x)) / GC.scrollSens);
					currentMap.scrollHorizontal(speed, bound);
					return true;					
				}
			}
			
			return false;
		}
		

		public function scrollVertical(bound : Number):Boolean
		{
			// The extra FP.camera.y terms are becase mouseY is based on the camera location 
			if (mouseY - FP.camera.y > 0 && mouseY - FP.camera.y <= FP.height)
			{
				// Valid mouse position
				var speed : Number;
				
				if (mouseY - FP.camera.y < GC.scrollSens)
				{
					// We would like to scroll left (-'ve)
					speed = - GC.scrollSpeed * (1 -(mouseY - FP.camera.y)/ GC.scrollSens);
					currentMap.scrollVertical(speed, bound);
					return true;
				}
				else if (mouseY - FP.camera.y > FP.height - GC.scrollSens)
				{
					// We would like to scroll right (+'ve)
					speed = GC.scrollSpeed * (1 - (FP.height - (mouseY - FP.camera.y)) / GC.scrollSens);
					currentMap.scrollVertical(speed, bound);
					return true;
				}
			}
			
			return false;
		}
		
		//} Scroll functions
		
		public function load():void
		{
			var file : FileReference = new FileReference();
			
			file.addEventListener(Event.SELECT, fileSelect);
			file.browse();

			function fileSelect (event:Event):void
			{
				file.addEventListener(Event.COMPLETE, loadComplete);
				file.load();
			}

			function loadComplete (event:Event):void
			{
				FP.world = new EditWorld(ident, com.adobe.serialization.json.JSON.decode(file.data.toString()) as Object);
			}
		}

		public function generateData():Object {
			var data:Object = {};
			data.tilemap = currentMap.getSaveData();
			data.players = playersStart;
			var ts:Array = [];
			for each (var t:Target in targets) {
				ts.push({type: t.ident, pos: [t.x / GC.tileWidth, t.y / GC.tileHeight]});
			}
			data.targets = ts;
			var ws:Array = [];
			var ss:Array;
			for each (var w:Wall in walls) {
				for each (var bs:Array in w.allButtons) {
					for (var i:int = 0; i < bs.length; i++) {
						bs[i] = switches.indexOf(bs[i]);
					}
				}
				ws.push({
					type: w.ident,
					rect: [w.x / GC.tileWidth, w.y / GC.tileHeight, w.width / GC.tileWidth, w.height / GC.tileHeight],
					buttons: w.allButtons
				});
			}
			data.walls = ws;
			ss = [];
			ws = [];
			for each (var s:Switch in switches) {
				trace("b", s.ident, s.walls.length, s.walls[0], walls.indexOf(s.walls[0]));
				for (i = 0; i < s.walls.length; i++) {
					s.walls[i] = walls.indexOf(s.walls[i]);
				}
				ss.push({
					type: s.player,
					pos: [s.x / GC.tileWidth, s.y / GC.tileHeight],
					walls: s.walls
				});
			}
			data.switches = ss;
			return data;
		}

		public function save():void {
			new FileReference().save(com.adobe.serialization.json.JSON.encode(generateData()));
		}
	}
}
