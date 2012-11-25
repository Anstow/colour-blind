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
			this.ident = ident;
			GC.checkSwitchId(ident);
			player = data.type;
			if (player == 0) {
				graphic = new Image(SWITCH1);
			} else {
				graphic = new Image(SWITCH2);
			}
			on = new Sfx(SWITCHON);
			off = new Sfx(SWITCHOFF);
			x = data.pos[0] * GC.tileWidth;
			y = data.pos[1] * GC.tileHeight;
			setHitbox(GC.tileWidth, GC.tileHeight);
			type = "switch" + player;
			if (data.walls == undefined){
				walls = new Array();
			} else {
				walls = data.walls.slice();
			}

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
