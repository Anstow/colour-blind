package
{
	import Editor.LoadableWorld;
	import flash.utils.getQualifiedClassName;
	import net.flashpunk.Entity;
	
	public class GameEvent implements Parent
	{
		public static const NONE : int = -1;
		public static const TOGGLE : int = 0;
		public static const TOGGLE_STR : String = "WT";
		public static const TOGGLE_INVERT : int = 1;
		public static const TOGGLE_INVERT_STR : String = "WTI";	

		// gets the affect string from the affect int 
		public static function getAffectStr(affect:int):String {
			switch (affect) {
				case TOGGLE:
					return TOGGLE_STR;
				case TOGGLE_INVERT:
					return TOGGLE_INVERT_STR;
				case NONE:
				default:
					return "-1";
			}
		}
		// gets the affect int from the affect string
		public static function getAffect(affectStr:String):int {
			switch (affectStr) {
				case TOGGLE_STR:
					return TOGGLE;
				case TOGGLE_INVERT_STR:
					return TOGGLE_INVERT;
				case "-1":
				default:
					return NONE;
			}
		}
		// gets the affect string from the affect int 
		public static function getAffectTemplatete(affect:String):Array {
			switch (affect) {
				case TOGGLE_STR:
					return [TOGGLE, -1];
				case TOGGLE_INVERT_STR:
					return [TOGGLE_INVERT_STR, -1];
				case "-1":
				default:
					return [-1];
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
						case TOGGLE:
						case TOGGLE_INVERT:
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
					trace(str);
					affects[section - 1] = getAffectTemplatete(str);
				} else {
					switch (affects[section - 1][0]) {
						case NONE:
							// You shouldn't be able to get here
							subSection = 0;
							break;
						case TOGGLE:
						case TOGGLE_INVERT:
							if (subSection > 1) {
								// You shouldn't be able to get here either
								subSection = 1;
								break;
							}
							affects[section-1][1]= getEntity(str);
							break;
					}	
				}
			}
		}

		// At some point affects may act on something other than walls then we'll need
		// a new fuction to add that type of effect.
		public function newEntityEffect(w:Entity,effect:int = TOGGLE):void {
			affects.push([effect, w]);
			switch (effect) {
				case TOGGLE:
					w.visible = state;
					w.collidable = state;
					break;
				case TOGGLE_INVERT:
					w.visible = !state;
					w.collidable = !state;
					break;
			}
		}

		// gets the entity from the string code returns null if no entity
		public function getEntity(newEntity:String):Entity {
			if (world) {
				switch (newEntity.charAt()) {
					case 'W':
						var entNum :int = Number(newEntity.slice(1));
						trace(entNum);
						if (entNum < 0 || !world.walls[entNum]) {
							return null;
						}
						return world.walls[entNum];
				}
			}
			return null;
		}

		public function toggled():void {
			state = !state;
			// Deal with the walls
			for each (var a:Array in affects) {
				switch (a[0])
				{
					case TOGGLE:
						a[1].visible = state;
						a[1].collidable = state;
						trace("toggle");
						break;
					case TOGGLE_INVERT:
						a[1].visible = !state;
						a[1].collidable = !state;
						trace("i toggle");
						break;
				}
			}
		}

		// Fuction that attaches the switches to the logicBlock,
		// and attaches the walls in affects
		// Make sure this is run after the walls have been added to the world 
		public function attachSwitches(world:LoadableWorld):Boolean {
			this.world = world;
			if (!logicBlock || logicBlock.attachSwitches(world)) {
				state = true;
			} else {
				state = false;
			}
			
			// Add the affected
			affects.filter(function(obj:Object,index:int,array:Array):Boolean {
					var elt:Array = obj as Array;
					switch (elt[0]) {
						case TOGGLE:
						case TOGGLE_INVERT:
							if (!elt[1]) {
								return false;
							} else if (getQualifiedClassName(elt[1]) != "String") {
								return true;
							}
							elt[1] = getEntity(elt[1]);
							if (elt[1]) {
								if (elt[0] == TOGGLE) {
									elt[1].visible = state;
									elt[1].collidable = state;
								} else {
									elt[1].visible = !state;
									elt[1].collidable = !state;
								}
								return true;
							}
							return false;
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
							case TOGGLE:
							case TOGGLE_INVERT:
								var index : int = world.walls.indexOf(affects[i][1]);
								if (l == this) {
									if (i + 1 == section && subSection == 0) {
										eA += "([{" + getAffectStr(affects[i][0]) + "}, W" +  index  + "]), ";
									} else if (i + 1 == section && subSection == 1) {
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
				if (l == this) {
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
						case TOGGLE:
						case TOGGLE_INVERT:
							if (e[1].type.substr(0,4) == "wall") {
								var index : int = world.walls.indexOf(e[1]);
							} else {
								index = -1;
							}
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
