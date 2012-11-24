package {
	import net.flashpunk.World;
	import Editor.LoadableWorld;
	import Editor.EditWorld;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class Level extends LoadableWorld
	{
		public var nPlayers:int = 2;

		public function Level (mapToLoad : Map = null, id : int = -1):void {
			super(mapToLoad, id)
			init(mapToLoad);
		}

		public function init (mapToLoad : Map = null):void {
			var data:Object = GC.levels[0];

			for (var i:int = 0; i < 2; i++) {
				playersStart.push(data.players[i]);
			}
			for each (var wData:Array in data.walls) {
				walls.push(new Wall(wData));
			}
			for each (var target:Array in data.targets){
				targets.push(new Target(data.targets));
			}


			for each (var w:Wall in walls){
				add(w);
			}
			for each (var p:Array in playersStart) {
				add(new Player(i, p));
			}
			for each (var t:Target in targets) {
				add(t);
			}

			if (!mapToLoad) {
				currentMap = new Map(ident);
			} else {
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
