package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;

	public class EditorNumber extends Entity {
		public function EditorNumber (ident:int, n:int, x:int, y:int):void {
			if (ident == 1) y += GC.tileHeight / 2;
			graphic = new Text(n + "", 0, -1, {"size": GC.numTextSize, "color": GC.numTextColour});
			this.x = x;
			this.y = y;
			layer = -2;
		}
	}
}
