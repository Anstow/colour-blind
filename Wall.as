package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.TiledImage;
	import Editor.LoadableWorld;
	
	public class Wall extends Entity implements Parent
	{
		public var allButtons:Array = [];
		public var pressedButtons:Array = [];
		public var logicBlock:LogicBlock;
		private var exists:Boolean = true;
		public var ident:int;
		[Embed(source = 'assets/wall0.png')] private const WALL0:Class;
		[Embed(source = 'assets/GreenCheck.png')] private const WALL1:Class;
		[Embed(source = 'assets/BlueCheck.png')] private const WALL2:Class;
		
		public function Wall(data:Object):void {
			var r:Array = data.rect;
			x = r[0] * GC.tileWidth;
			y = r[1] * GC.tileHeight;
			setHitbox(r[2] * GC.tileWidth, r[3] * GC.tileHeight);
			ident = data.type;
			if (ident == -1) {
				graphic = new TiledImage(WALL0, r[2] * GC.tileWidth, r[3] * GC.tileHeight);
			} else if (ident == 0) {
				graphic = new TiledImage(WALL1, r[2] * GC.tileWidth, r[3] * GC.tileHeight);
			} else {
				graphic = new TiledImage(WALL2, r[2] * GC.tileWidth, r[3] * GC.tileHeight);
			}
			type = "wall" + ident;
			// logicBlock
			if (data.logicBlock !== undefined && data.logicBlock != "") {
				var str:String = data.logicBlock;
				trace("logicBlock:", str);
				logicBlock = new LogicBlock(str.split(" "), this);
			}
			// buttons
			else if (data.buttons !== undefined) {
				for each (var buttonGroup:Array in data.buttons) {
					allButtons.push(buttonGroup.slice());
					var pressedButtonsGroup:Array = [];
					pressedButtons.push(pressedButtonsGroup);
					for each (var b:int in buttonGroup) {
						pressedButtonsGroup.push(b);
					}
				}
			}
		}
		
		/* Depricated
		public function toggle(b:Switch):void {
			/*
			var newExists:Boolean = true;
			for (var i:int = 0; i < allButtons.length; i++) {
				var bs:Array = pressedButtons[i];
				if (allButtons[i].indexOf(b) != -1) {
					var j:int = bs.indexOf(b);
					if (j == -1) {
						bs.push(b);
					} else {
						bs.splice(j, 1);
					}
				}
				if (bs.length == 0) {
					newExists = false;
				}
			}
			///
			//*
			var newExists :Boolean = logicBlock.checkStatus();
			///

			if (newExists != exists) {
				if (newExists) {
					visible = true;
					collidable = true;
				} else {
					visible = false;
					collidable = false;
				}
				exists = newExists;
			}
		}
		//*/

		public override function removed():void {
			super.removed();
			/* Depricated
			if ((world as LoadableWorld).editting)
			{
				for each (var ss:Array in allButtons)
				{
					for each (var s:Switch in ss)
					{
						s.removeLink(this);
					}
				}
			}
			//*/
		}

		public function removeLink(s: Switch):void {
			if (allButtons.indexOf(s) >= 0)
			{
				allButtons.splice(allButtons.indexOf(s),1);
			}			
		}

		public function loadStr(str:String):void {
			logicBlock = new LogicBlock(str.split(" "), this);
		}

		public function updateSwitches():void {
		}
		
		// Handles the toggling of switches
		public function toggled():void {
			var newExists :Boolean = logicBlock.currentState;
			trace("toggled, wall", logicBlock.currentState);
			if (newExists != exists) {
				if (newExists) {
					visible = true;
					collidable = true;
				} else {
					visible = false;
					collidable = false;
				}
				exists = newExists;
			}
		}
		
		// Attaches the switches
		public function attachSwitches(world:LoadableWorld):Boolean
		{
			if (!logicBlock || logicBlock.attachSwitches(world)) {
				visible = true;
				collidable = true;
				exists = true;
			} else {
				visible = false;
				collidable = false;
				exists = false;
			}
			return exists;
		}
		
		// Gets the String
		public function getLogicString():String
		{
			if (logicBlock) {
				return logicBlock.toString();
			} else {
				return "NOT b-1"
			}
		}

	}
}

// vim: foldmethod=indent:cindent
