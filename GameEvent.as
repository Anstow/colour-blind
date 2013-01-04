package
{
	import Editor.LoadableWorld;
	import flash.utils.getQualifiedClassName;
	
	public class GameEvent implements Parent
	{
		public static const W_TOGGLE : int = 0;
		public static const W_TOGGLE_INVENT : int = 1;

		public var logicBlock:LogicBlock;
		private var effects:Array = [];
		public var state:Boolean = false;

		public function GameEvent(data:Object) {
			// logicBlock
			if (data.logicBlock !== undefined && data.logicBlock != "") {
				logicBlock = new LogicBlock(data.logicBlock.split(" "), this);
			}
			if (data.effects !== undefined && data.effects != "") {
				for each (var a:Array in data.effects) {
					switch (a[0]) {
						case W_TOGGLE:
						case W_TOGGLE_INVENT:
							if (a[1] !== undefined) {
								effects.push([a[0], a[1]]);
							}
							break;
					}
				}
			}
		}

		public function loadLogicStr(str:String):void {
			logicBlock = new LogicBlock(str.split(" "), this);
		}

		// At some point effects may act on something other than walls then we'll need
		// a new fuction to add that type of effect.
		public function newWallEffect(w:Wall,effect:int = W_TOGGLE):void {
			effects.push([effect, w]);
			switch (effect) {
				case W_TOGGLE:
					w.toggle(state);
					break;
				case W_TOGGLE_INVENT:
					w.toggle(!state);
					break;
			}
		}

		public function toggled():void {
			state = !state;
			// Deal with the walls
			for each (var a:Array in effects) {
				switch (a[0])
				{
					case W_TOGGLE:
						a[1].toggle(state);
						break;
					case W_TOGGLE_INVENT:
						a[1].toggle(!state);
						break;
				}
			}
		}

		// Fuction that attaches the switches to the logicBlock,
		// and attaches the walls in effects
		// Make sure this is run after the walls have been added to the world 
		public function attachSwitches(world:LoadableWorld):Boolean {
			if (!logicBlock || logicBlock.attachSwitches(world)) {
				state = true;
			} else {
				state = false;
			}
			trace("here", effects.length);
			
			effects.filter(function(obj:Object,index:int,array:Array):Boolean {
					var elt:Array = obj as Array;
					switch (elt[0]) {
						case W_TOGGLE:
						case W_TOGGLE_INVENT:
							if (elt[1] < 0 || !world.walls[elt[1]]) {
								return false;
							}
							if (getQualifiedClassName(elt[1]) == "Wall")
							{
								return true;
							}
							elt[1] = world.walls[elt[1]];
							if (elt[0] == W_TOGGLE) {
								elt[1].toggle(state);
							} else {
								elt[1].toggle(!state);
							}
							return true;
					}
					return false;
				} 
			);
			trace("effects");
			for each (var a:Array in effects)
			{
				trace(a[0],a[1]);
			}
			return state;
		}

		// Gets the String
		public function getData(world:LoadableWorld):Object
		{
			if (logicBlock) {
				var eA : Array = [];
				for each (var e:Array in effects) {
					switch (e[0]) {
						case W_TOGGLE:
						case W_TOGGLE_INVENT:
							var index : int = world.walls.indexOf(e[1]);
							if (index >= 0) {
								eA.push([e[0], index]);
							}
							break;
					}
				}
				if (eA.length > 0) {
					return {
						effects: eA,
						logicBlock: logicBlock.toString()
					};
				}
			} 
			return {};
		}

	}
}

// vim: foldmethod=indent:cindent
