package Editor
{
	import Editor.EditorConstants;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.ByteArray;
	import flash.net.FileReference;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author David
	 */
	public class EditWorld extends LoadableWorld 
	{
		public var tileOpts : TileOptions;
		
		// The seclected tile.
		public var selected : int =  -1;
		public var x1 : int = -1;
		public var y1 : int = -1; 
		
		public function EditWorld(l : Level) 
		{
			super(l);
		}
		
		override public function begin():void 
		{
			super.begin();
			EditorConstants.init();
			
			add(level);
			tileOpts = new TileOptions();
			add(tileOpts);
			
			FP.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
		}
		
		override public function update():void 
		{
			if (Input.mousePressed)
			{
				if (tileOpts.visible)
				{
					selected = tileOpts.getTile(mouseX, mouseY);
					if (selected != -1)
					{
						tileOpts.visible = false;
					}
				}
				else if (selected == -1)
				{
					tileOpts.visible = true;
				}
				else
				{
					if (x1 != -1 && y1 != -1)
					{						
						// Set the tiles 
						level.setTiles(x1, y1, level.getTileX(mouseX), level.getTileY(mouseY), selected);
						
						// Set the original position back to -1, -1.
						x1 = -1;
						y1 = -1;
					}
					else
					{
						x1 = level.getTileX(mouseX);
						y1 = level.getTileY(mouseY);
					}
				}
			}
			if (Input.released(Key.SHIFT))
			{
				selected = -1;
				tileOpts.visible = true;
			}
			else if (Input.released(Key.E))
			{
				remove(level);
				level.updateCollisions();
				FP.world = new GameWorld(level);
			}
			
			if (EditorConstants.scrollOn)
			{
				scrollHorizontal(EditorConstants.halfWidth * 2);
				scrollVertical(EditorConstants.halfHeight * 2);
			}
			super.update();
		}
		
		private function keyDownListener(e : KeyboardEvent):void
		{
			if (e.ctrlKey || e.shiftKey)
			{
				if (e.keyCode == Key.S)
				{
					save();
				}
				else if (e.keyCode == Key.L)
				{
					load();
				}
			}
		}
		
		public function load():void 
		{
			var file : FileReference = new FileReference();
			
			file.addEventListener(Event.SELECT, fileSelect);
			file.browse();

			function fileSelect (event:Event):void
			{
				file.addEventListener(Event.COMPLETE, loadComplete);
				file.load();
			}

			function loadComplete (event:Event):void
			{
				level.setLevel(file.data.toString());
			}
		}
		
		public function save():void 
		{
			new FileReference().save(level.getSaveData());
		}
	}

}
