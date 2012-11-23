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
		public var level : Level; // I also think it would be usefull to have a handle to my level
		
		public function LoadableWorld(l : Level = null) 
		{
			EditorConstants.init();
			level = l;
			FP.screen.color = 0x00ffff;			
		}
		
		//{ Scroll Functions		
		public function scrollHorizontal(bound : Number):Boolean
		{
			// The extra FP.camera.x terms are becase mouseX is based on the camera location 
			if (mouseX - FP.camera.x > 0 && mouseX - FP.camera.x <= FP.width)
			{
				// Valid mouse position
				var speed : Number;
				
				if (mouseX - FP.camera.x < GameConstant.scrollSens)
				{
					// We would like to scroll left (-'ve)
					speed = - GameConstant.scrollSpeed * (1 -(mouseX - FP.camera.x)/ GameConstant.scrollSens);
					level.scrollHorizontal(speed, bound);
					return true;
				}
				else if (mouseX - FP.camera.x > FP.width - GameConstant.scrollSens)
				{
					// We would like to scroll right (+'ve)
					speed = GameConstant.scrollSpeed * (1 - (FP.width - (mouseX - FP.camera.x)) / GameConstant.scrollSens);
					level.scrollHorizontal(speed, bound);
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
				
				if (mouseY - FP.camera.y < GameConstant.scrollSens)
				{
					// We would like to scroll left (-'ve)
					speed = - GameConstant.scrollSpeed * (1 -(mouseY - FP.camera.y)/ GameConstant.scrollSens);
					level.scrollVertical(speed, bound);
					return true;
				}
				else if (mouseY - FP.camera.y > FP.height - GameConstant.scrollSens)
				{
					// We would like to scroll right (+'ve)
					speed = GameConstant.scrollSpeed * (1 - (FP.height - (mouseY - FP.camera.y)) / GameConstant.scrollSens);
					level.scrollVertical(speed, bound);
					return true;					
				}
			}			
			
			return false;
		}
		
		//} Scroll functions 
	}

}