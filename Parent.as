package
{
	import Editor.LoadableWorld;

	public interface Parent
	{
		function toggled():void;
		function attachSwitches(world:LoadableWorld):Boolean;
	}
}

// vim: foldmethod=indent:cindent
