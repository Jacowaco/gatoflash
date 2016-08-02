package game.sports 
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class Metres400 extends Metres100 
	{
		
		public function Metres400() 
		{	
			currentSport = "sport1"; // esto es lo único que debería hardcodear...
			finalMetres = settings.sports[currentSport].metres;			
			playersMaxSpeed = 	settings.sports[currentSport].maxSpeed;
			
			super.create();
			
			// TODO aca seguro va a haber que poner una cuenta regresiva
			start();
		}
		
		override public function onKeyUp(key:KeyboardEvent):void
		{
			
		}
		
		override public function onKeyDown(key:KeyboardEvent):void 
		{			
			if (key.keyCode == Keyboard.SPACE) player.jumpHurdle();			
			super.onKeyDown(key);			
		}
		
	}

}