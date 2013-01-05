package
{
	import Editor.LoadableWorld;

	public class LogicBlock implements Parent
	{
		public static const DESCEND:int=0;
		public static const ASSCEND:int=1;
		public static const LEFT:int=2;
		public static const RIGHT:int=3;

		public static const NORMAL : int = 0; // A way to add buttons into the logic with NORMAL
		public static const NOT : int = 1;
		public static const NOT_S : String = "NOT";
		public static const AND : int = 2;
		public static const AND_S : String = "AND";
		public static const OR : int = 3;
		public static const OR_S : String = "OR";

		public var parentBlock : Parent;
		public var leftChild : LogicBlock; // The logic block on the left of the statement, this is the block used for NOT
		public var rightChild : LogicBlock; // The logic block on the right of the statement
		public var button : int = -1; // A way to add buttons into the logic when using NORMAL
		public var operation : int  = 0; // The operation this should be NORMAL, AND, OR or NOT
		public var currentState:Boolean;

		private var world:LoadableWorld;
		private var section:int;

		public function LogicBlock(data:Array, parentBlock:Parent) {
			section = 0;
			addData(data);
			this.parentBlock = parentBlock;
		}

		public function changeString(str:String):void {
			switch (section) {
				case 0:
					switch(str) {
						case AND_S:
							operation= AND;
							break;
						case OR_S:
							operation= OR;
							break;
						case NOT_S:
							operation= NOT;
							break;
						default:
							// If the element is a button number we add the button
							var tempStr : String = str.slice(1);
							if (tempStr) { // Check if there is an element to add
								var switchIndex : int = Number(tempStr);
								if (tempStr == "0" || switchIndex > 0) {
									button = switchIndex;
								}
							}
							operation = NORMAL;
					}
					break;
				case 1:
					if (leftChild) {
						leftChild.removed();
					}
					leftChild = new LogicBlock(str.split(" "), this);
				case 2:
					if (rightChild) {
						rightChild.removed();
					}
					rightChild = new LogicBlock(str.split(" "), this);
			}
		}
					

		// Checks whether this is currently true or false and attaches the switches
		public function attachSwitches(world:LoadableWorld):Boolean {
			this.world = world;
			var left:Boolean = false;
			var right:Boolean = false;
			switch (operation)
			{
				case AND:
					if (leftChild) {
						left = leftChild.attachSwitches(world)
					}
					if (rightChild) {
						right = rightChild.attachSwitches(world);
					}
					currentState = left && right;
					break;
				case OR:
					if (leftChild) {
						left = leftChild.attachSwitches(world)
					}
					if (rightChild) {
						right = rightChild.attachSwitches(world);
					}
					currentState = left || right;
					break;
				case NOT:
					if (leftChild){
						left = leftChild.attachSwitches(world)
					}
					currentState = !left;
					break;
				default: // NORMAL
					if (world.switches[button]) {
						currentState = world.switches[button].isOn;
						world.switches[button].parentsAffected.push(this);
					} else {
						currentState = false;
					}
			}
			return currentState;
		}

		// Toggles the block
		public function toggled():void {
			var newState : Boolean = currentState;
			switch (operation)
			{
				case AND:
					newState = (leftChild ? leftChild.currentState : false) && (rightChild ? rightChild.currentState : false);
					break;
				case OR:
					newState = (leftChild ? leftChild.currentState : false) || (rightChild ? rightChild.currentState : false);
					break;
				case NOT:
					newState = !leftChild.currentState;
					break;
				default: // NORMAL
					// Toggle the button
					newState = !currentState;
			}

			if (newState != currentState) {
				currentState = newState;
				parentBlock.toggled();
			}
		}

		// Moves the selected block
		public function moveSelection(d:int):Parent {
			switch (d) {
				case DESCEND:
					if (section == 1 && leftChild) {
						return leftChild;
					} else if (section == 2 && rightChild) {
						return rightChild;
					}
					break;
				case ASSCEND:
					return parentBlock;
					break;
				case LEFT:
					if (section > 0) {
						section--;
					}
					break;
				case RIGHT:
					switch (operation)
					{
						case AND:
						case OR:
							if (section < 2) {
								section++;
							}
							break;
						case NOT:
							if (section < 1) {
								section++;
							}
							break;
						default:
					}
					break;
			}
			return this;
		}

		// Converts the logic block into a string
		public function toString(l:Parent = null):String {
			switch (operation) {
				case AND:
					if (this == l) {
						if (section == 0) {
							return "{ " + AND_S + " } ( " + (leftChild ? leftChild.toString(l) : "b-1") + " ) ( " + (rightChild ? rightChild.toString(l) : "b-1") + " )";
						} else if (section == 1) {
							return "( " + AND_S + " ) { " + (leftChild ? leftChild.toString(l) : "b-1") + " } ( " + (rightChild ? rightChild.toString(l) : "b-1") + " )";
						} else if (section == 2) {
							return "( " + AND_S + " ) ( " + (leftChild ? leftChild.toString(l) : "b-1") + " ) { " + (rightChild ? rightChild.toString(l) : "b-1") + " }";
						} else {
							return "( " + AND_S + " ) ( " + (leftChild ? leftChild.toString(l) : "b-1") + " ) ( " + (rightChild ? rightChild.toString(l) : "b-1") + " )";
						}
					}
					return AND_S + " " + (leftChild ? leftChild.toString(l) : "b-1") + " " + (rightChild ? rightChild.toString(l) : "b-1");
				case OR:
					if (this == l) {
						if (section == 0) {
							return "{ " + OR_S + " } ( " + (leftChild ? leftChild.toString(l) : "b-1") + " ) ( " + (rightChild ? rightChild.toString(l) : "b-1") + " )";
						} else if (section == 1) {
							return "( " + OR_S + " ) { " + (leftChild ? leftChild.toString(l) : "b-1") + " } ( " + (rightChild ? rightChild.toString(l) : "b-1") + " )";
						} else if (section == 2) {
							return "( " + OR_S + " ) ( " + (leftChild ? leftChild.toString(l) : "b-1") + " ) { " + (rightChild ? rightChild.toString(l) : "b-1") + " }";
						} else {
							return "( " + OR_S + " ) ( " + (leftChild ? leftChild.toString(l) : "b-1") + " ) ( " + (rightChild ? rightChild.toString(l) : "b-1") + " )";
						}
					}
					return OR_S + " " + (leftChild ? leftChild.toString(l) : "b-1") + " " + (rightChild ? rightChild.toString(l) : "b-1 ");
				case NOT:
					if (this == l) {
						if (section == 0) {
							return "{ " + NOT_S + " } ( " + (leftChild ? leftChild.toString(l) : "b-1") + " )";
						} else if (section == 1) {
							return "( " + NOT_S + " ) { " + (leftChild ? leftChild.toString(l) : "b-1") + " }";
						} else {
							return "( " + NOT_S + " ) ( " + (leftChild ? leftChild.toString(l) : "b-1") + " )";
						}
					}
					return NOT_S + " " + (leftChild ? leftChild.toString(l) : "b-1"); 
				default:
					if (this == l) {
						if (section == 0) {
							return "{ b" + button + " }";
						} else {
							return "( b" + button + " )";
						}
					}
					return "b" + button;
			}
		}

		// Converts the logic block into a human readable string
		public function toStringH():String {
			switch (operation) {
				case AND:
					return "(" + (leftChild ? leftChild.toStringH() : "b-1 ") + AND_S + " " + (rightChild ? rightChild.toStringH() : "b-1 ") + ") ";
				case OR:
					return "(" + (leftChild ? leftChild.toStringH() : "b-1 ") + OR_S + " " + (rightChild ? rightChild.toStringH() : "b-1 ") + ") ";
				case NOT:
					return "(" + NOT_S + " " + (leftChild ? leftChild.toStringH() : "b-1 ") + ") "; 
				default:
					return (button ? "b" + button + " " : "b-1 ")
			}
		}

		// This adds data to the selected element
		public function addData(data:Array):void {
			switch (section)
			{ 
				case 1:
					if (leftChild) {
						leftChild.addData(data);
					} else {
						leftChild = new LogicBlock(data, this);
						if (world) {
							leftChild.attachSwitches(world);
						}
					}
				case 2:
					if (rightChild) {
						rightChild.addData(data);
					} else {
						rightChild = new LogicBlock(data, this);
						if (world) {
							rightChild.attachSwitches(world);
						}
					}
				default:
					removed();
					section = 0;
					if (!data || data.length <= 0) {
						operation = NORMAL;
						return;
					}
					changeString(data[0]);
					// Add the data
					data = data.slice(1);
					if (operation != 0 && data.length > 0) {
						// Add left child
						leftChild = new LogicBlock(data, this);
						if (operation != 1 && data.length > 0) {
							rightChild = new LogicBlock(data, this);
						}
					}
					if (world) {
						attachSwitches(world);
					}
					break;
			}
		}
		
		// Updates the number of the switch
		public function updateSwitchNumber(n:int):void {
			button = n;
		}
		
		// LogicBlock removed
		public function removed():void {
			if (leftChild) {
				leftChild.removed();
			}
			if (rightChild) {
				rightChild.removed();
			}
			if (button >= 0 && world) {
				if (button < world.switches.length)
				{
					world.switches[button].parentsAffected.filter(
						function(obj:Object,index:int,array:Array):Boolean {
							return !(obj as LogicBlock == this);
						});
				}
			}
		}
	}
}

// vim: foldmethod=indent:cindent
