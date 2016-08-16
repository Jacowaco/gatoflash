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
		private var screenPoint:Point = new Point(-47,-74);
		private var bullet:Throwie;
		
		protected var line:MovieClip;
		protected var base:MovieClip;
		protected var arena:MovieClip;
		protected var catcher:MovieClip;
		
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
			
			assets.pizza;
			assets.mozo;
			
			var throwieMc:Class = getDefinitionByName("assets." + currentSport.throwable) as Class;
			bullet = new Throwie(new throwieMc());
			bullet.addEventListener(Throwie.ON_REACH, onReach);

			player.addChild(bullet);
			player.setReadyToThrow();
			// TODO NO INTENTE ESTO EN CASA !!!
			// solo un programador profesional puede intentarlo
			bullet.x = -47;
			bullet.y = -14;			
			
			
			var catcherMc:Class = getDefinitionByName("assets." + currentSport.catcher) as Class;
			catcher = new catcherMc();
			catcher.x = 1000;
			catcher.y = 360;
			catcher.gotoAndStop("stand");
			camera.addChild(catcher);
			
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
			if(player.lookingRight){ 				
				camera.x = -(bullet.x -screenPoint.x);		
				if(bullet.x > catcher.x + currentSport.catchPh.x){
					catcher.x = bullet.x - currentSport.catchPh.x;
					activateCatcher();
				}
				bg.follow(camera.x);
			}
			
			player.update();

		}
		
		private function activateCatcher():void
		{
			if(catcher.currentLabel != "move") catcher.gotoAndPlay("move");
		}
		
		
		override public function getPlayerMeters():int
		{
			if(player.lookingRight) return bullet.x / Sport.UNITS_PER_METER;
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
			screenPoint = player.localToGlobal(new Point(bullet.x, bullet.y));// bullet.y				
			camera.addChild(bullet);			
			bullet.animate();
			bullet.x = screenPoint.x;
			bullet.y = screenPoint.y;
			// TODO ENGANIA PICHANGA
//			bullet.shoot(player.percentage, player.lookingRight); //
			var diff:Number =  currentSport.catchPh.y;
			trace(currentSport.maxMeters);
			bullet.shoot(1 * currentSport.maxMeters, camera.localToGlobal(new Point(0, catcher.dish.y )).y + diff, true);
		}
		
		public function onReach(e:Event):void
		{			
			bullet.stop();
			catcher.stop();
			setTimeout(checkWin, 1000);			
		}
		
		private function checkWin():void
		{			
			trace("distance: ", bullet.x);
			
			
			if(bullet.x > 0 && bullet.x < currentSport.maxMeters / 3) badge = BADGE_BRONCE;
			if(bullet.x > currentSport.maxMeters / 3 && bullet.x < currentSport.maxMeters / 3 * 2) badge = BADGE_SILVER;
			if(bullet.x > currentSport.maxMeters / 3 * 2) badge = BADGE_GOLD;
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