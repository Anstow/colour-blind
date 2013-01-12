package
{
	import Editor.LoadableWorld;
	import flash.utils.getQualifiedClassName;
	
	public class GameEvent implements Parent
	{
		public static const NONE : int = -1;
		public static const W_TOGGLE : int = 0;
		public static const W_TOGGLE_STR : String = "WT";
		public static const W_TOGGLE_INVERT : int = 1;
		public static const W_TOGGLE_INVERT_STR : String = "WTI";	

		public static function getAffectStr(affect:int):String {
			switch (affect) {
				case W_TOGGLE:
					return W_TOGGLE_STR;
				case W_TOGGLE_INVERT:
					return W_TOGGLE_INVERT_STR;
				case NONE:
				default:
					return "-1";
			}
		}

		public var logicBlock:LogicBlock;
		private var affects:Array = [];
		public var state:Boolean = false;
		private var section:int = 0;
		private var subSection:int=0;
		private var world:LoadableWorld;

		public function GameEvent(data:Object) {
			// logicBlock
			section = 0;
			if (data.logicBlock !== undefined && data.logicBlock != "") {
				addData(data.logicBlock.split(" "));
			}
			if (data.affects !== undefined && data.affects != "") {
				for each (var a:Array in data.affects) {
					switch (a[0]) {
						case W_TOGGLE:
						case W_TOGGLE_INVERT:
							if (a[1] !== undefined) {
								affects.push([a[0], a[1]]);
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
			if (section == 0) {
				// We want to add the data to the first element
				if (!logicBlock) {
					logicBlock = new LogicBlock(str.split(" "),this);
				}
			} else {
				if (subSection == 0) {
					// Change the type of affect
					var tempType:int = Number(str);
					affects[section - 1][0] = 0;
					// TODO: Make this actually do something
				} else {
				}
			}
		}

		// At some point affects may act on something other than walls then we'll need
		// a new fuction to add that type of effect.
		public function newWallEffect(w:Wall,effect:int = W_TOGGLE):void {
			affects.push([effect, w]);
			switch (effect) {
				case W_TOGGLE:
					w.toggle(state);
					break;
				case W_TOGGLE_INVERT:
					w.toggle(!state);
					break;
			}
		}

		// Change affect type of the affect
		public function changeAffect(newAffect:int):void {
		}

		public function toggled():void {
			state = !state;
			// Deal with the walls
			for each (var a:Array in affects) {
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
		// and attaches the walls in affects
		// Make sure this is run after the walls have been added to the world 
		public function attachSwitches(world:LoadableWorld):Boolean {
			world = world;
			if (!logicBlock || logicBlock.attachSwitches(world)) {
				state = true;
			} else {
				state = false;
			}
			
			affects.filter(function(obj:Object,index:int,array:Array):Boolean {
					var elt:Array = obj as Array;
					switch (elt[0]) {
						case W_TOGGLE:
						case W_TOGGLE_INVERT:
							elt[1] = Number(elt[1].slice(1));
							if (elt[1] < 0 || !world.walls[elt[1]]) {
								return false;
							}
							if (getQualifiedClassName(elt[1]) == "Wall") {
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
					} else if (subSection > 0) {
						// Else we are in a subSection and want to move left within it
						subSection -= 1;
					}
					break;
				case LogicBlock.ASSCEND:
					if (section > 0 && subSection + 1 < affects[section - 1].length) {
						// We are in a subSection and want to move right within it 
						subSection++;
					}
					break;
				case LogicBlock.LEFT:
					if (section > 0) {
						if (affects[section - 1][0] == NONE) {
							// if the section we've moved from is empty remove it
							affects = affects.filter(function(item:Object, index:int, array:Array):Boolean {
										return (index != section - 1);
									});
						}
						// We want to move our section left
						section--;
						subSection=0;
					}
					break;
				case LogicBlock.RIGHT:
					if (section < affects.length) {
						// We want to move our section right or remove the section
						if (section > 0 && affects[section - 1][0] == NONE) {
							// If the section moved from is empty removed it
							affects = affects.filter(function(item:Object, index:int, array:Array):Boolean {
										return index != section - 1;
									});
						} else {
							// If the section moved from isn't empty move to the next section
							section++;
						}
						subSection=0;
					}
				   	else if (affects.length == 0 || affects[affects.length - 1][0] != NONE) {
						// We want to add a new section and move to it
						section=affects.length + 1;
						subSection=0;
						affects.push([NONE]);
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
					for (var i:int = 0; i < affects.length; i++) {
						switch (affects[i][0]) {
							case W_TOGGLE:
							case W_TOGGLE_INVERT:
								var index : int = world.walls.indexOf(affects[i][1]);
								if (l == this) {
									if (i + 1 == section && subSection == 0) {
										eA += "([{" + getAffectStr(affects[i][0]) + "}, W" +  index  + "]), ";
									} else if (i + 1 == section && subSection == 0) {
										eA += "([" + getAffectStr(affects[i][0]) + ", {W" +  index  + "}]), ";
									} else {
										eA += "([" + getAffectStr(affects[i][0]) + ", W" +  index  + "]), ";
									}
								} else {
									eA += "[" + getAffectStr(affects[i][0]) + ", W" +  index  + "], ";
								}
								break;
							case NONE:
								index = world.walls.indexOf(affects[i][1]);
								if (l == this) {
									if (i + 1 == section && subSection == 0) {
										eA += "([{" + affects[i][0] + "}])";
									} else {
										eA += "([" + affects[i][0] + "]), ";
									}
								} else {
									eA += "[" + affects[i][0] + "], ";
								}
								break;
						}
					}
				}
				trace(l == this);
				if (l == this) {
					trace("here");
					if (section == 0) {
						return  "logicBlock: {" + logicBlock.toString(l) + "}, affects: " + eA;
					} else {
						return  "logicBlock: (" + logicBlock.toString(l) + "), affects: " + eA;
					}
				}
				return  "logicBlock: " + logicBlock.toString(l) + ", affects: " + eA;
			} 
			return "";
		}

		// Gets the data
		public function getData(world:LoadableWorld):Object {
			if (logicBlock) {
				var eA : Array = [];
				for each (var e:Array in affects) {
					switch (e[0]) {
						case W_TOGGLE:
						case W_TOGGLE_INVERT:
							var index : int = world.walls.indexOf(e[1]);
							if (index >= 0) {
								eA.push([e[0], "W" + index]);
							}
							break;
					}
				}
				if (eA.length > 0) {
					return {
						affects: eA,
						logicBlock: logicBlock.toString()
					};
				}
			} 
			return {};
		}
	}
}

// vim: foldmethod=indent:cindent
