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
		public var events:Array = new Array();
		protected var tempLevel:String = null;
		public var editting :Boolean = false;

		public var ident:int = 0;
		
		public function LoadableWorld(id:int, data:Object)
		{
			EditorConstants.init();
			ident = id;
			init(data);
		}

		public function init(data:Object):void {
			trace("Loading Level");
			this.data = data;
			
			for (var i:int = 0; i < 2; i++) {
				playersStart.push(data.players[i]);
			}
			for (i = 0; i < data.switches.length; i++) {
				switches.push(new Switch(data.switches[i]));
			}
			for each (var wData:Object in data.walls) {
				var tempWall:Wall = new Wall(wData);
				walls.push(tempWall);
			}
			for each (var target:Object in data.targets) {
				targets.push(new Target(target));
			}
			if (data.events !== undefined) {
				for each (var event:Object in data.events) {
					var e:GameEvent=new GameEvent(event);
					e.attachSwitches(this);
					events.push(e);
				}
			}

			var mainStr:String = "";
			var subStr:String = "";

			for each (var s:Switch in switches) {
				add(s);
			}
			for each (var w:Wall in walls) {
				add(w);
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
				tempLevel = file.data.toString();
			}
		}

		public function generateData():Object {
			var data:Object = {}; // The data
			data.tilemap = currentMap.getSaveData(); // Add the tile map
			data.players = playersStart; // Put the players start positions in
			var ts:Array = []; // An array to put the targets in
			for each (var t:Target in targets) {
				ts.push({type: t.ident, pos: [t.x / GC.tileWidth, t.y / GC.tileHeight]});
			}
			data.targets = ts; // Add the targets
			var ws:Array = []; // An array to put the walls in
			var destBgs:Array; // An array to put the button groups in 
			var destBs:Array;  // An array to put the buttons in a group in
			var logicBlockStr: String = "";
			for each (var w:Wall in walls) {
				// Add the walls
				ws.push({
					type: w.ident,
					rect: [w.x / GC.tileWidth, w.y / GC.tileHeight, w.width / GC.tileWidth, w.height / GC.tileHeight]
				});
			}
			data.walls = ws;
			var es:Array = []; // An array to put the events in
			for each (var e:GameEvent in events) {
				es.push(e.getData(this));
			}
			data.events = es;
			var ss:Array = [];
			for each (var s:Switch in switches) {
				ss.push({
					type: s.ident,
					pos: [s.x / GC.tileWidth, s.y / GC.tileHeight]
				});
			}
			data.switches = ss;
			return data;
		}

		public function save():void {
			var s:String = com.adobe.serialization.json.JSON.encode(generateData());
			new FileReference().save(s);
		}
	}
}

// vim: foldmethod=indent:cindent
