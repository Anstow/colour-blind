package
{
	import net.flashpunk.Entity;

	public class Target extends Entity
	{
		public var targetType : int;

		public function Target (targetData:Array):void {
			targetType = targetData[0];
			x = targetData[1][0];
			y = targetData[1][1];

			type = "Taget" + (targetType as String);
		}

		override public function update():void
		{
			super.update();
			// TODO: player collision removal
		}
	}
}
