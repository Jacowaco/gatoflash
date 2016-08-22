package game.sports 
{
	import assets.*;
	
	import avatar.corredorMC;
	
	import com.qb9.flashlib.geom.Vector2D;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import game.Avatar;
	import game.Throwie;
	
	import ui.GuiEvents;
	
	
	public class JumpingGame extends Sport 
	{
		protected var departure:MovieClip;
		protected var limit:MovieClip;
		protected var goal:MovieClip;		
		
		
		public function JumpingGame(currentSport:Object) 
		{			
			this.currentSport = currentSport;
			create(); // en este caso llamo yo a create
		}
		
		
		
		override protected function create():void 
		{
			levelDefinition = new assets.jumpsMC;
			
			departure = levelDefinition.getChildByName("start") as MovieClip;
			limit = levelDefinition.getChildByName("line") as MovieClip;
			goal = levelDefinition.getChildByName("goal") as MovieClip;
			
			camera.addChild(departure);
			camera.addChild(limit);
			camera.addChild(goal);
			
			createPlayer();
		}
		
		override public function initialize():void
		{			
			// como es una carrera voy a iniciar con cuenta regresiva.
			// entonces overrideo este metodo a modo de hook.
			dispatchEvent(new Event(GuiEvents.COUNTDOWN)); 
			// el countdown dispara un evento que me avisa cuando arrancar
			// y es ahí donde se llama a Sport.initialize(); ;)
		}
		
		private function createPlayer():void
		{
			player = new Avatar();			
			player.x = departure.x;
			player.y = departure.y;
			player.setMode(Avatar.PLAYER);					
			player.setMaxSpeed(currentSport.maxPower);
			player.setSpeedIncrement(currentSport.powerIncrement);			
			camera.addChild(player);
		}
		
		override public function start():void
		{
			trace("jumping start");
			playing = true;
			player.go();
			timer.go();
			super.start(); // disparo el evento de que la carrera inicio
		}

		
		override public function update():void 
		{
			if (!playing) return;	
			player.update();
			camera.x += (playerScreenPosition - player.localToGlobal(new Point(0,0)).x);									
			bg.follow(camera.x);			
//			checkIfWin();
			
		}
		
		override public function onKeyDown(key:KeyboardEvent):void 
		{
			if (key.keyCode == Keyboard.LEFT && !leftKeyPressed)
			{
				leftKeyPressed = true;
				player.increasePower();
			}
			
			if (key.keyCode == Keyboard.RIGHT && leftKeyPressed)
			{
				leftKeyPressed = false;
				player.increasePower();
			}
		}
		
		public function playerReached(e:Event):void
		{

		}
		
		override protected function assignBadge():void 
		{

		}
		
	}

}