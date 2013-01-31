package
{
	import net.flashpunk.utils.Input;
	import net.flashpunk.Entity;
	import mx.utils.ObjectUtil;

	/**
	 * Collecting all the input detection (for the game not the editor)
	 * in one place to make it easier to implement recordings and change
	 * input keys
	 */
	public class GameInput extends Entity
	{
		public static const GAME_PLAY:int=0;
		public static const RECORD:int=1;
		public static const PLAYBACK: int=2;
		public static const FREEZE:int=3;

		public var mode:int;
		public var frame:int;

		private var lastControls:Object = {};
		private var controls:Object = {};
		private var data:Object = {};

		public function GameInput(mode:int=0):void {
			this.mode=mode;
			frame=0;
			updateControl();
			trace(mode);
		}

		public function loadPlaybackData(data:Object):void {
			this.data = data;
		}

		public function getPlaybackData():Object {
			if (mode == RECORD) {
				return data;
			} else {
				return null;
			}
		}

		public override function update():void {
			frame++;
			updateControl();
		}

		public function updateControl():void {
			if (mode == FREEZE) {
				// If we're frozen we don't want any input to happen
				return;
			} else if (mode == PLAYBACK) {
				// Here we are in playback mode
				// Update the lastControls
				lastControls = ObjectUtil.copy(controls);
				for each (var i:String in controls) {
					lastControls[i] = controls[i];
					if (i == "down0") {
						trace (controls[i]);
					}
				}
				if (data[frame]) {
					var tempVec:Array = data[frame];
					for each (var s:String in tempVec) {
						controls[s] = !controls[s];
					}
				}
				return;
			} else {
				tempVec = [];
				// We are in RECORD or GAME_PLAY mode so 
				for (i in GC.inputKeys) {
					// The funny syntax here is to correct probelms with controls[i] being undefined
					lastControls[i] = controls[i] ? true : false;
					controls[i] = false;
					var v:Array = GC.inputKeys[i];
					for each (var k:int in v) {
						if (Input.check(k)) {
							controls[i] = true;
							break;
						}
					}
					if (lastControls[i] != controls[i] && mode == RECORD) {
						tempVec.push(i);
					}
				}
				if (mode == RECORD && tempVec.length > 0) {
					// Store the controls
					data[frame] = tempVec;
				}
			}
		}

		public function check(str:String):Boolean {
			return controls[str];
		}

		public function pressed(str:String):Boolean {
			if (controls[str] && !lastControls[str]) {
				trace(str, controls[str], !lastControls[str]);
			}
			return controls[str] && !lastControls[str];
		}

		public function released(str:String):Boolean {
			return !controls[str] && lastControls[str];
		}
	}
}

// vim: foldmethod=indent:cindent	
