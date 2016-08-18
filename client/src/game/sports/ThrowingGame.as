package game.sports 
{
	import assets.*;
	
	import avatar.corredorMC;
	
	import com.qb9.flashlib.easing.Tween;
	import com.qb9.flashlib.geom.Vector2D;
	import com.qb9.flashlib.tasks.TaskEvent;
	
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
		
		protected var faultAnimation:Tween;
		
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
			assets.torta;
			assets.payaso;
			assets.avioncito;
			assets.invisiblecatcher;
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
			catcher.x = currentSport.minMeters * Sport.UNITS_PER_METER;
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
			playing = true;
			
			if(currentSport.idMenuButton == "avioncito_btn"){
				player.setMoonWalk();
				player.setReadyToThrow();
				return;
			}
			
			player.setSpinning();
			
			
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
			player.x += playerMovement;
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
		
		private var playerMovement:Number = 0;
		override public function onKeyDown(key:KeyboardEvent):void 
		{
			if (bullet.shot) return;
			
			if(!faultAnimation){
				trace("init fault: ",  currentSport.timeOut * 1000 );
				var offset:Number = base.width/2;  // te sallis del circulo perdes...				
				faultAnimation = new Tween(player, currentSport.timeOut * 1000, {"x": player.x + offset}, { transition:"linear" } );
				faultAnimation.addEventListener(TaskEvent.COMPLETE, onFault);
				Game.taskRunner().add(faultAnimation);
			}
					
			
			if (key.keyCode == Keyboard.SPACE)
			{				
				throwSomething();
				player.lookingRight = true;
				player.throwing();
			}
			
			else if (key.keyCode == Keyboard.LEFT && !leftKeyPressed)
			{
				leftKeyPressed = true;
				player.increasePower();
			}
			else if (key.keyCode == Keyboard.RIGHT && leftKeyPressed)
			{
				leftKeyPressed = false;
				player.increasePower();
			}
		}
		
		private function throwSomething():void
		{
			audio.fx.play("lanza");
			if(faultAnimation.running) faultAnimation.dispose();
			screenPoint = player.localToGlobal(new Point(bullet.x, bullet.y));// bullet.y				
			camera.addChild(bullet);			
			bullet.animate();
			bullet.x = screenPoint.x;
			bullet.y = screenPoint.y;
			
			var destX:Number = player.percentage * currentSport.maxMeters; 			
			var destY:Number =  destX > catcher.x / Sport.UNITS_PER_METER - 1? camera.localToGlobal(new Point(0, catcher.dish.y )).y + currentSport.catchPh.y : currentSport.catchPh.y;
			bullet.shoot(destX, destY, true); 
		}
		
		public function onReach(e:Event):void
		{			
			bullet.stop();
			catcher.gotoAndStop("stand");			
			trace("distance: ", bullet.x);
			var value:Number = Utils.map(bullet.x, currentSport.minMeters * Sport.UNITS_PER_METER, currentSport.maxMeters * Sport.UNITS_PER_METER, 0, 1);
			
			if(currentSport.idMenuButton == "torta_btn"){
				if(!value < 1/3 ) camera.removeChild(bullet);
				catcher.gotoAndStop("err");
			}
			
			if(currentSport.idMenuButton == "avioncito_btn"){
				bullet.asset.gotoAndStop("err");
			}
			
			audio.fx.play("atajaPizza");
			assingBadge(value);
			super.competitionEnds();
						
		}
		
		
		private function onFault(e:Event):void
		{
		
			badge = BADGE_LOOSER;
			super.competitionEnds();
		}
		
		private function assingBadge(value:Number):void
		{			
			
			trace("value:" , value);
			if(value < 0) badge = BADGE_LOOSER;
			if(value >= 0 && value < 1/3 ) badge = BADGE_BRONCE;
			if(value > 1/3 && value < 2/3 ) badge = BADGE_SILVER;
			if(value > 2/3 ) badge = BADGE_GOLD;

			
		}
		

		
	}

}