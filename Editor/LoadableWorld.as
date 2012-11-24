package  Editor
{
	import net.flashpunk.FP;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author David
	 */
	public class LoadableWorld extends World 
	{
		public var currentMap : Map; // I also think it would be usefull to have a handle to my level
		public var walls : Array = new Array();
		public var playersStart: Array = new Array();
		public var playersTarget: Array = new Array();
		public var targets:Array = new Array();

		public var ident:int = 0;
		
		public function LoadableWorld(l : Map = null, id : int = -1) 
		{
			EditorConstants.init();
			ident = id;
			currentMap = l;
		}
		
		//{ Scroll Functions		
		public function scrollHorizontal(bound : Number):Boolean
		{
			// The extra FP.camera.x terms are becase mouseX is based on the camera location 
			if (mouseX - FP.camera.x > 0 && mouseX - FP.camera.x <= FP.width)
			{
				// Valid mouse position
				var speed : Number;
				
				if (mouseX - FP.camera.x < GC.scrollSens)
				{
					// We would like to scroll left (-'ve)
					speed = - GC.scrollSpeed * (1 -(mouseX - FP.camera.x)/ GC.scrollSens);
					currentMap.scrollHorizontal(speed, bound);
					return true;
				}
				else if (mouseX - FP.camera.x > FP.width - GC.scrollSens)
				{
					// We would like to scroll right (+'ve)
					speed = GC.scrollSpeed * (1 - (FP.width - (mouseX - FP.camera.x)) / GC.scrollSens);
					currentMap.scrollHorizontal(speed, bound);
					return true;					
				}
			}
			
			return false;
		}
		

		public function scrollVertical(bound : Number):Boolean
		{
			// The extra FP.camera.y terms are becase mouseY is based on the camera location 
			if (mouseY - FP.camera.y > 0 && mouseY - FP.camera.y <= FP.height)
			{
				// Valid mouse position
				var speed : Number;
				
				if (mouseY - FP.camera.y < GC.scrollSens)
				{
					// We would like to scroll left (-'ve)
					speed = - GC.scrollSpeed * (1 -(mouseY - FP.camera.y)/ GC.scrollSens);
					currentMap.scrollVertical(speed, bound);
					return true;
				}
				else if (mouseY - FP.camera.y > FP.height - GC.scrollSens)
				{
					// We would like to scroll right (+'ve)
					speed = GC.scrollSpeed * (1 - (FP.height - (mouseY - FP.camera.y)) / GC.scrollSens);
					currentMap.scrollVertical(speed, bound);
					return true;					
				}
			}			
			
			return false;
		}
		
		//} Scroll functions 
	}

}
