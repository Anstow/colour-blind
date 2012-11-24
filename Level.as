package {
	import net.flashpunk.World;
	import Editor.LoadableWorld;
	import Editor.EditWorld;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import flash.utils.ByteArray;
	
	public class Level extends LoadableWorld
	{
		public var nPlayers:int = 2;
		private var savedData:Array;
		[Embed(source = 'leveldata.json', mimeType = "application/octet-stream")] private const LEVELDATA:Class;

		public function Level (mapToLoad : Map = null, id : int = -1):void {
			super(mapToLoad, id)
// 			trace((new LEVELDATA() as ByteArray).toString());
			savedData = JSON.parse((new LEVELDATA() as ByteArray).toString()) as Array;
			ident = 0;
			init(mapToLoad);
		}

		public function init (mapToLoad : Map = null):void {
			var data:Object = GC.levels[0];

			for (var i:int = 0; i < 2; i++) {
				playersStart.push(data.players[i]);
			}
			for each (var wData:Object in data.walls) {
				walls.push(new Wall(wData));
			}
			for (i = 0; i < data.switches.length; i++) {
				switches.push(new Switch(i, data.switches[i]));
			}
			for each (var target:Object in data.targets) {
				targets.push(new Target(target));
			}

			for each (var w:Wall in walls){
				add(w);
			}
			for (i = 0; i < 2; i++) {
				add(new Player(i, playersStart[i]));
			}
			for each (var s:Switch in switches) {
				add(s);
			}
			for each (var t:Target in targets) {
				add(t);
			}
			currentMap = new Map();
			loadFromData(savedData[ident]);
			if (mapToLoad) {
				currentMap = mapToLoad;
			}
			add(currentMap);
		}

		override public function update():void
		{
			super.update();
			// This enables the editor it should be removed in the final version
			if (Input.released(Key.F5))
			{
				remove(currentMap);
				FP.world = new EditWorld(currentMap);
			}
		}
	}
}
