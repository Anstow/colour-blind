package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import Editor.LoadableWorld;
	import net.flashpunk.utils.Draw

	public class Switch extends Entity
	{
		public var ident : int;
		public var walls:Array;
		public var player:int;
		public var inverted:Boolean;
		private var isOn:Boolean = false;
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
			// See if the switch has any walls
			if (data.walls == undefined){
				walls = new Array();
				trace("switch" + ident + " has no walls");
			} else {
				// add the walls
				walls = data.walls.slice();
			}
			// If the inverted property of a switch is undefined the switch isn't inverted
			if(data.inverted == undefined){
				trace("not inverted");
				inverted = false;
			} else {
				// Set the inverted property
				inverted = (data.inverted as Boolean);
				trace("inverted: ", inverted);
			}
			// Set the graphics layer
			layer = -1;
		}

		public function toggle ():void {
			for each (var w:Wall in walls) {
				w.toggle(this);
			}
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
		}

		public override function render():void
		{
			super.render();
			if ((world as LoadableWorld).editting)
			{
				for each (var w :Wall in walls)
				{
					Draw.line(x,y, w.x, w.y);
				}
			}
		}

		public override function removed():void
		{
			super.removed();
			if ((world as LoadableWorld).editting)
			{
				for each (var w:Wall in walls)
				{
					w.removeLink(this);
				}
			}
		}

		public function removeLink(w: Wall):void
		{
			if (walls.indexOf(w) >= 0)
			{
				walls.splice(walls.indexOf(w),1);
			}			
		}
	}
}
