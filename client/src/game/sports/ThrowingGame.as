package game.sports 
{
	import assets.*;
	
	import avatar.corredorMC;
	
	import com.qb9.flashlib.geom.Vector2D;
	
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	import game.Avatar;
	import game.Throwie;
	
	import utils.Utils;
	
	public class ThrowingGame extends Sport 
	{

		// TODO esto tendría que estar adentro del Throwie
		private var screenPoint:Point = new Point(-47,0);
		private var bullet:Throwie;
		
		
		protected var throwMeters:int;
		protected var line:MovieClip;
		protected var base:MovieClip;
		protected var arena:MovieClip;
		
		public function ThrowingGame(sportDefinition:Object) 
		{
			currentSport = sportDefinition; 			
			create();
		}
		
		override protected function create():void 
		{
			levelDefinition = new assets.throwingMC;
			arena = levelDefinition.arena;
			base = levelDefinition.base;
			line = levelDefinition.line;
		
			camera.addChild(arena);
			camera.addChild(line);
			camera.addChild(base);
			
			player = new Avatar();			
			player.x = base.x;
			player.y = base.y;
			player.setMode(Avatar.PLAYER);	
			player.setMaxSpeed(currentSport.maxPower);
			player.setSpeedIncrement(currentSport.powerIncrement);
			camera.addChild(player);
			
			
			throwMeters = currentSport.maxMeters;
			
			assets.pizza;
			
			var throwieMc:Class = getDefinitionByName("assets." + currentSport.throwable) as Class;
			bullet = new Throwie(new throwieMc());
			bullet.addEventListener(Throwie.ON_REACH, onReach);

			player.addChild(bullet);
			player.setReadyToThrow();
			// TODO NO INTENTE ESTO EN CASA !!!
			// solo un programador profesional puede intentarlo
			bullet.x = -47;
			bullet.y = -14;			
			
			
		}
		
		
		override public  function initialize():void
		{
			// este juego no usa contdown. inicia aca.
			start();
		}
		
	
	    
		override public function start():void
		{
			player.setSpinning();
			playing = true;
		}
		
		override public function update():void 
		{
			if (!playing) return;			
			if(true){ 				
				camera.x = -(bullet.x -screenPoint.x);				
				bg.follow(camera.x);
			}
			
			player.update();

		}
		
		
		override public function getPlayerMeters():int
		{
			if(player.lookingRight) return bullet.x /Sport.UNITS_PER_METER;
			return 0;
		}

		
		override public function onKeyUp(key:KeyboardEvent):void 
		{
			
		}
		override public function onKeyDown(key:KeyboardEvent):void 
		{
			if (bullet.shot) return;
			
			if (key.keyCode == Keyboard.SPACE)
			{
				
				releasePizza();
				if(player.lookingRight){
					player.throwing();	
				}else{
					player.collide();
				}
			}
			
			else if (key.keyCode == Keyboard.LEFT && !leftKeyPressed)
			{
				leftKeyPressed = true;
				player.accelerateSpin();
			}
			else if (key.keyCode == Keyboard.RIGHT && leftKeyPressed)
			{
				leftKeyPressed = false;
				player.accelerateSpin();
			}
		}
		
		private function releasePizza():void
		{
			audio.fx.play("lanza");
			screenPoint = player.localToGlobal(new Point(bullet.x, bullet.y));				
			camera.addChild(bullet);			
			bullet.animate();
			bullet.x = screenPoint.x;
			bullet.y = screenPoint.y;				
			bullet.shoot(player.percentage, true); //player.lookingRight
		}
		
		public function onReach(e:Event):void
		{
			trace("onReach");
			bullet.stop();
			setTimeout(checkWin, 1000);			
		}
		
		private function checkWin():void
		{			
			trace("distance: ", bullet.x);
			if(bullet.x > 0 && bullet.x < Throwie.MAX_DISTANCE / 3) badge = BADGE_BRONCE;
			if(bullet.x > Throwie.MAX_DISTANCE / 3 && bullet.x < Throwie.MAX_DISTANCE / 3 * 2) badge = BADGE_SILVER;
			if(bullet.x > Throwie.MAX_DISTANCE / 3 * 2) badge = BADGE_GOLD;
			if(!player.lookingRight) badge = BADGE_LOOSER;
			
			if(badge != BADGE_LOOSER){
				audio.fx.play("bu");
			}else{
				audio.fx.play("ovacion");
			}
			
			super.competitionEnds();
		}
		

		
	}

}