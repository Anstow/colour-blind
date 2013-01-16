package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import Editor.LoadableWorld;
	import net.flashpunk.utils.Draw;

	public class Switch extends Entity
	{
		//public var ident : int;
		public var parentsAffected:Array = []; 
		public var ident:int;
		public var isOn:Boolean = false;
		private var numText:EditorNumber;
		[Embed(source = 'assets/switch1.png')] private const SWITCH1:Class;
		[Embed(source = 'assets/switch2.png')] private const SWITCH2:Class;
		[Embed(source = 'assets/switch1on.png')] private const SWITCH1ON:Class;
		[Embed(source = 'assets/switch2on.png')] private const SWITCH2ON:Class;
		[Embed(source = 'sfx/switchOn.mp3')] private const SWITCHON:Class;
		[Embed(source = 'sfx/switchOff.mp3')] private const SWITCHOFF:Class;
		private var on:Sfx;
		private var off:Sfx;

		public function Switch (data:Object):void {
			// Set the identity of the switch and player to affect
			ident = data.type;
			// Graphics
			if (ident == 0) {
				graphic = new Image(SWITCH1);
			} else {
				graphic = new Image(SWITCH2);
			}
			// Music
			on = new Sfx(SWITCHON);
			off = new Sfx(SWITCHOFF);
			// Set the position hitbox and collision type
			x = data.pos[0] * GC.tileWidth;
			y = data.pos[1] * GC.tileHeight;
			setHitbox(GC.tileWidth, GC.tileHeight);
			type = "switch" + ident;
			// Set the graphics layer
			layer = -1;
		}

		public function addText (world : LoadableWorld):void {
			if (world) {
				numText = new EditorNumber(ident, (world as LoadableWorld).switches.indexOf(this), x, y);
				world.add(numText);
			}
		}

		public function rmText ():void {
			if (numText) {
				world.remove(numText);
			}
		}

		// Toggles the switch the muted is incase we want the switch to be locally muted
		public function toggle (muted:Boolean):void {
			if (isOn) {
				if (!muted) {
					off.play();
				}
				if (ident == 0) graphic = new Image(SWITCH1);
				else             graphic = new Image(SWITCH2);
				isOn = false;
				}
			else {
				if (!muted) {
					on.play();
				}
				if (ident == 0) graphic = new Image(SWITCH1ON);
				else             graphic = new Image(SWITCH2ON);
				isOn = true;
			}
			for each (var p:Parent in parentsAffected) {
				p.toggled();
			}
		}

		public function updateSwitchNumber(i:int):void {
			if (world) {
				for each (var p:LogicBlock in parentsAffected) {
					p.updateSwitchNumber(i);
				}
			}
		}

		public override function removed():void {
			super.removed();
			rmText();
			for each (var p:LogicBlock in parentsAffected) {
				p.updateSwitchNumber(-1);
			}
		}
	}
}

// vim: foldmethod=indent:cindent
