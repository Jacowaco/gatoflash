package game.sports 
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import ui.GuiEvents;
	
	public class PlainRace extends Race 
	{
		
		public function PlainRace() 
		{	
			// TODO habilitar que la carrera pueda levantar settings individuales
			currentSport = "sport1"; // esto es lo único que debería hardcodear...
			finalMetres = settings.sports[currentSport].metres;			
			playersMaxSpeed = 	settings.sports[currentSport].maxSpeed;
			playersSpeedIncrement  = settings.sports[currentSport].speedIncrement;
			super.create();
			
			
		}
		override public function init():void
		{
			trace("game ready. start");
			dispatchEvent(new Event(GuiEvents.COUNTDOWN)); // el countdown me avisa cuando arrancar
		}
		override public function onKeyUp(key:KeyboardEvent):void
		{
			
		}
		
		override public function onKeyDown(key:KeyboardEvent):void 
		{			
//			if (key.keyCode == Keyboard.SPACE) player.jumpHurdle();			
			super.onKeyDown(key);			
		}
		
	}

}