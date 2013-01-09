package
{
	import Editor.LoadableWorld;
	import flash.utils.getQualifiedClassName;
	
	public class GameEvent implements Parent
	{
		public static const W_TOGGLE : int = 0;
		public static const W_TOGGLE_INVERT : int = 1;

		public var logicBlock:LogicBlock;
		private var effects:Array = [];
		public var state:Boolean = false;
		private var section:int = 0;
		private var world:LoadableWorld;

		public function GameEvent(data:Object) {
			// logicBlock
			section = 0;
			if (data.logicBlock !== undefined && data.logicBlock != "") {
				addData(data.logicBlock.split(" "));
			}
			if (data.effects !== undefined && data.effects != "") {
				for each (var a:Array in data.effects) {
					switch (a[0]) {
						case W_TOGGLE:
						case W_TOGGLE_INVERT:
							if (a[1] !== undefined) {
								effects.push([a[0], a[1]]);
							}
							break;
					}
				}
			}
		}

		// Adds the logicBlock data
		public function addData(data:Array):void {
			if (logicBlock) {
				logicBlock.removed();
			}
			logicBlock = new LogicBlock(data, this);
			if (world) {
				logicBlock.attachSwitches(world);
			}
		}
		
		// Adds or changes a String, to add new 
		public function changeString(str:String):void {
			if (section == 0 && !logicBlock) {
				logicBlock = new LogicBlock(str.split(" "),this);
			}
		}

		// At some point effects may act on something other than walls then we'll need
		// a new fuction to add that type of effect.
		public function newWallEffect(w:Wall,effect:int = W_TOGGLE):void {
			effects.push([effect, w]);
			switch (effect) {
				case W_TOGGLE:
					w.toggle(state);
					break;
				case W_TOGGLE_INVERT:
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
					case W_TOGGLE_INVERT:
						a[1].toggle(!state);
						break;
				}
			}
		}

		// Fuction that attaches the switches to the logicBlock,
		// and attaches the walls in effects
		// Make sure this is run after the walls have been added to the world 
		public function attachSwitches(world:LoadableWorld):Boolean {
			world = world;
			if (!logicBlock || logicBlock.attachSwitches(world)) {
				state = true;
			} else {
				state = false;
			}
			
			effects.filter(function(obj:Object,index:int,array:Array):Boolean {
					var elt:Array = obj as Array;
					switch (elt[0]) {
						case W_TOGGLE:
						case W_TOGGLE_INVERT:
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
			return state;
		}

		public function moveSelection(d:int):Parent {
			switch (d) {
				case LogicBlock.DESCEND:
					if (section == 0 && logicBlock) {
						return logicBlock;
					}
					break;
				case LogicBlock.ASSCEND:
					break;
				case LogicBlock.LEFT:
					if (section > 0) {
						section--;
					}
					break;
				case LogicBlock.RIGHT:
					if (section < effects.length * 2) {
						section++;
					}
					break;
			}

			return this;
		}

		// Gets the data as a String
		public function toString(world:LoadableWorld = null, l:Parent = null):String {
			if (logicBlock) {
				var eA : String = "";
				if (world) {
					for (var i:int = 0; i < effects.length; i++) {
						switch (effects[i][0]) {
							case W_TOGGLE:
							case W_TOGGLE_INVERT:
								var index : int = world.walls.indexOf(effects[i][1]);
								if (index >= 0) {
									if (l == this) {
										if (2*i + 1 == section) {
											eA += "[{" + effects[i][0] + "}, (" +  index  + ")]";
										} else if (2*i + 2 == section) {
											eA += "[(" + effects[i][0] + "), {" +  index  + "}]";
										} else {
											eA += "[(" + effects[i][0] + "), (" +  index  + ")]";
										}
									} else {
										eA += "[" + effects[i][0] + ", " +  index  + "]";
									}
								}
								break;
						}
					}
				}
				if (eA.length > 0) {
					if (l == this) {
						if (section == 0) {
							return  "logicBlock: {" + logicBlock.toString(l) + "}, effects: " + eA;
						} else {
							return  "logicBlock: (" + logicBlock.toString(l) + "), effects: " + eA;
						}
					}
					return  "logicBlock: " + logicBlock.toString(l) + ", affects: " + eA;
				} else {
					return logicBlock.toString(l);
				}
			} 
			return "";
		}

		// Gets the data
		public function getData(world:LoadableWorld):Object {
			if (logicBlock) {
				var eA : Array = [];
				for each (var e:Array in effects) {
					switch (e[0]) {
						case W_TOGGLE:
						case W_TOGGLE_INVERT:
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
