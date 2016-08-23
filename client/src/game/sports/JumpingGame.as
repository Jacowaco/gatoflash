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
	
	import utils.Utils;
	
	
	public class JumpingGame extends Sport 
	{
		protected var departure:MovieClip;
		protected var line:MovieClip;
		protected var limit:MovieClip;		
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
			line = levelDefinition.getChildByName("line") as MovieClip;
			limit = levelDefinition.getChildByName("goal") as MovieClip;
			arena = levelDefinition.getChildByName("arena") as MovieClip;
			
			if(currentSport.idMenuButton == "highJump_btn"){
				mode = HIGH_JUMP;
			}else{
				mode = LONG_JUMP;
			}
			
			camera.addChild(departure);
			camera.addChild(arena);			
			camera.addChild(line);			
			camera.addChild(limit);
			
			if(mode == HIGH_JUMP){
				gatulongo = levelDefinition.getChildByName("longo") as MovieClip;
				gatulongo.gotoAndStop(Math.random() * 3 + 1);			
				camera.addChild(gatulongo);		
				if( Game.attempts <  3 ) {
					gatulongo.gotoAndStop(Game.attempts + 1);
				}else{
					gatulongo.gotoAndStop(3);
				}
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
			player.setSpeedDamping(currentSport.damping);
			player.setSpeedIncrement(currentSport.powerIncrement);			
			player.addEventListener(Avatar.ON_LANDING, onLanding);
			camera.addChild(player);
		}
		
		override public function start():void
		{

			playing = true;
			player.setJumpRunning();
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
			switch(mode){
				case LONG_JUMP:
					if(!player.isIdle() && !player.isJumping() && player.x >= limit.x){
						onFault(null);
					}	
					break;
				case HIGH_JUMP:					
					var minx:Number = gatulongo.x - gatulongo.width/2 ;
					var maxx:Number = gatulongo.x + gatulongo.width/2 ;
					var top:Number = gatulongo.y - (gatulongo.height * 0.9);
					
					
//					trace("y:" , player.y , top);
//					trace("x: ", player.x , minx, maxx);
//					!player.isIdle() && !player.isJumping() 
					if(player.x >= minx && player.x < maxx && player.y > top){  // si me lo llevo puesto
						trace("choque frontal");
						onFault(null);
					}
					
					
					break;	
			}
			
			
			
		}
		
		private function onFault(e:Event):void
		{
			player.crash();
			player.killJump();
			player.removeEventListener(Avatar.ON_LANDING, onLanding);
			badge = BADGE_LOOSER;
			super.competitionEnds();
		}
		
		override public function onKeyDown(key:KeyboardEvent):void 
		{
			if(!playing) return;
			
			if (key.keyCode == Keyboard.SPACE )
			{
				trace(">>>>>>>>>> jump");
				player.jump(currentSport.jump);
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
		
		private function onLanding(e:Event):void
		{
			trace("onLanding");
			var value:Number = Utils.map((player.x - limit.x), currentSport.jump.minx * Sport.UNITS_PER_METER, currentSport.jump.maxx * Sport.UNITS_PER_METER, 0.0, 1.0);
			setbadge(value);
			player.setIdle();
			competitionEnds();
		}
		
		private function setbadge(value:Number):void
		{			
			
			if(mode == LONG_JUMP){
				if(value < 0) badge = BADGE_LOOSER;
				if(value >= 0 && value < 1/3 ) badge = BADGE_BRONCE;
				if(value > 1/3 && value < 2/3 ) badge = BADGE_SILVER;
				if(value > 2/3 ) badge = BADGE_GOLD;
	
			}
			
			if(mode == HIGH_JUMP){
				if(Game.attempts == 0) badge = BADGE_BRONCE;
				if(Game.attempts == 1) badge = BADGE_SILVER;
				if(Game.attempts == 2) badge = BADGE_GOLD;
				Game.attempts += 1;
			}
			
			
		}
		
		override public function getPlayerMeters():int
		{
//			trace(player.x, limit.x); 
			if(player.x > ( limit.x)) return (player.x - limit.x) / Sport.UNITS_PER_METER;
			return 0;
		}
		
	}

}