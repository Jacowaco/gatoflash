package game.sports 
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import ui.GuiEvents;
	
	public class PlainRace extends Race 
	{
		
		public function PlainRace(sportDefinition:Object) 
		{	
			super(sportDefinition);
			finalMetres = currentSport.metres;			
			super.create();			
		}
		
		override public function initialize():void
		{			
			// como es una carrera voy a iniciar con cuenta regresiva.
			// entonces overrideo este metodo a modo de hook.
			dispatchEvent(new Event(GuiEvents.COUNTDOWN)); // el countdown dispara un evento que me avisa cuando arrancar
		}
		
		override public function onKeyUp(key:KeyboardEvent):void
		{
			
		}
		
		override public function onKeyDown(key:KeyboardEvent):void 
		{						
			super.onKeyDown(key);			
		}
		
	}

}