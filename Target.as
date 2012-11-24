package
{
	import net.flashpunk.Entity;

	public class Target extends Entity
	{
		public var ident : int;

		public function Target (data:Object):void {
			ident = data.type;
			x = data.pos[0];
			y = data.pos[1];
			type = "target" + ident;
		}
	}
}
