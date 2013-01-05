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

		private var section:int = 0;

		public function LogicBlock(data:Array, parentBlock:Parent, leftChild:LogicBlock = null, rightChild:LogicBlock = null, but:int = -1) {
			var operationType : int;
			if (!data || data.length <= 0) {
				operation = NORMAL;
			}
			switch(data[0]) {
				case AND_S:
					operationType = AND;
					break;
				case OR_S:
					operationType = OR;
					break;
				case NOT_S:
					operationType = NOT;
					break;
				default:
					// If the element is a button number we add the button
					var tempStr : String= data[0].slice(1);
					if (tempStr) { // Check if there is an element to add
						var switchIndex : int = Number(tempStr);
						if (tempStr == "0" || switchIndex > 0) {
							button = switchIndex;
						}
					}
			}
			// Add the data
			data = data.slice(1);
			operation = operationType;

			if (operation != 0 && data.length > 0) {
				// Add left child
				leftChild = new LogicBlock( data, this);
				if (operationType != 1 && data.length > 0)				{
					rightChild = new LogicBlock(data, this);
				}
			}
			
			this.parentBlock = parentBlock;
			
			if (operation == 0 && but !=  -1) {
				button = but;
			} else if (leftChild) {
				this.leftChild = leftChild;
				if (rightChild) {
					this.rightChild = rightChild;
				}
			}
		}

		// Checks whether this is currently true or false and attaches the switches
		public function attachSwitches(world:LoadableWorld):Boolean {
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
						trace("DESCEND left");
						return leftChild;
					} else if (section == 2 && rightChild) {
						trace("DESCEND right");
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
			if (this == l) { trace(operation); };
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

		// Changes the left block to a block of type blockType
		public function changeLeftBlockTo(blockType:int=0):void {
			leftChild = new LogicBlock([ blockType.toString() ], this, leftChild ? leftChild.leftChild : null, leftChild ? leftChild.rightChild : null, leftChild ? leftChild.button : null);
		}

		// Changes the right block to a block of type blockType
		public function changeRightBlockTo(blockType:int=0):void {
			rightChild = new LogicBlock([ blockType.toString() ], this, rightChild ? rightChild.leftChild : null, rightChild ? rightChild.rightChild : null, rightChild ? rightChild.button : null);
		}
	}
}

// vim: foldmethod=indent:cindent
