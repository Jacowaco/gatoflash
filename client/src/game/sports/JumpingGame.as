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
		protected var arena:MovieClip;
		protected var gatulongo:MovieClip;
		
		protected var mode:int = 0;
		public static const LONG_JUMP:int = 1;
		public static const HIGH_JUMP:int = 2;
		
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
			arena = levelDefinition.getChildByName("arena") as MovieClip;
			
			if(currentSport.idMenuButton == "highJump_btn"){
				mode = HIGH_JUMP;
			}else{
				mode = LONG_JUMP;
			}
			
			camera.addChild(departure);
			camera.addChild(arena);			
			camera.addChild(limit);			
			camera.addChild(goal);
			
			if(mode == HIGH_JUMP){
				gatulongo = levelDefinition.getChildByName("longo") as MovieClip;
				gatulongo.gotoAndStop(Math.random() * 3 + 1);			
				camera.addChild(gatulongo);					
			}
			
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
			checkIfWin();
			
		}
		
		private function checkIfWin():void
		{
			if(!player.isJumping() && player.x >= goal.x){
				onFault(null);
			}
		}
		
		private function onFault(e:Event):void
		{
			player.stop();
			badge = BADGE_LOOSER;
			super.competitionEnds();
		}
		
		override public function onKeyDown(key:KeyboardEvent):void 
		{
			if(!playing) return;
			
			if (key.keyCode == Keyboard.SPACE )
			{
//				if(mode == HIGH_JUMP) player.jumpHigh();
				if(mode == LONG_JUMP) player.jumpLong(currentSport.jump);
			}
			
			
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