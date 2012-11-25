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
		private var savedData:Array;

		public function Level (id:int, data:Object) {
			super(id, data);
			for (var i:int = 0; i < 2; i++) {
				add(new Player(i, playersStart[i]));
			}
		}

		public function win():void {
			trace("yay");
		}

		public function reset():void {
			FP.world = new Level(ident, data);
		}

		override public function update():void
		{
			super.update();
			// This enables the editor it should be removed in the final version
			if (Input.released(Key.F5))
			{
				removeAll();
				FP.world = new EditWorld(ident, data);
			}
		}
	}
}
