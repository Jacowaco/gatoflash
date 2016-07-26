package gameobject
{
	import flash.events.KeyboardEvent;

	public interface IControllable
	{
		function onKeyPressed(ke:KeyboardEvent):void;
		function onKeyReleased(ke:KeyboardEvent):void;
	}
}