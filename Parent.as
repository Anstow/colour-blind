package
{
	import Editor.LoadableWorld;

	public interface Parent
	{
		function addData(data:Array):void;
		function moveSelection(d:int):Parent;
		function toggled():void;
		function attachSwitches(world:LoadableWorld):Boolean;
	}
}

// vim: foldmethod=indent:cindent
