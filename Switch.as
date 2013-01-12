package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import Editor.LoadableWorld;
	import net.flashpunk.utils.Draw;

	public class Switch extends Entity
	{
		public var ident : int;
		public var parentsAffected:Array = []; 
		/*public var walls:Array;//*/
		public var player:int;
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

		public function Switch (ident:int, data:Object):void {
			// Set the identity of the switch and player to affect
			this.ident = ident;
			GC.checkSwitchId(ident);
			player = data.type;
			// Graphics
			if (player == 0) {
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
			type = "switch" + player;
			// Set the graphics layer
			layer = -1;
		}

		public function addText ():void {
			numText = new EditorNumber(ident, (FP.world as LoadableWorld).switches.indexOf(this), x, y);
			FP.world.add(numText);
		}

		public function rmText ():void {
			world.remove(numText);
		}

		public function toggle ():void {
			if (isOn) {
				off.play();
				if (player == 0) graphic = new Image(SWITCH1);
				else             graphic = new Image(SWITCH2);
				isOn = false;
				}
			else {
				on.play();
				if (player == 0) graphic = new Image(SWITCH1ON);
				else             graphic = new Image(SWITCH2ON);
				isOn = true;
			}
				trace("here");
			for each (var p:Parent in parentsAffected) {
				p.toggled();
			}
		}

		public override function render():void
		{
			super.render();
		}

		public override function removed():void
		{
			super.removed();
			for each (var p:LogicBlock in parentsAffected) {
				p.updateSwitchNumber(-1);
			}
		}
	}
}

// vim: foldmethod=indent:cindent
