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
	import game.LevelEvents;
	import game.Throwie;
	
	public class DiscusThrow extends Sport 
	{
		private var pizza:Throwie;
		// TODO esto tendría que estar adentro del Throwie
		private var screenPoint:Point = new Point();
		
		protected var line:MovieClip;
		protected var throwMeters:int;
		private var base:MovieClip;
		
		public function DiscusThrow() 
		{
			currentSport = "sport2"; // esto es lo único que debería hardcodear...			
			create();
		}
		
		override public  function init():void
		{
			start();
		}
		
		protected function create():void 
		{
			levelDefinition = new assets.throwingMC;
			base = levelDefinition.base;
			camera.addChild(base);
			
			player = new Avatar(new avatar.corredorMC);			
			player.x = base.x;
			player.y = base.y;
			player.setMode(Avatar.PLAYER);	
			player.setMaxSpeed(settings.sports[currentSport].maxSpeed);
			player.setSpeedIncrement(settings.sports[currentSport].speedIncrement);
			camera.addChild(player);
			
			
			throwMeters = 5;
			
			pizza = new Throwie(new assets.discusMC());
			pizza.addEventListener(Throwie.ON_REACH, onReach);
			player.addChild(pizza);
			
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
				camera.x = screenPoint.x - this.localToGlobal(new Point(pizza.x, pizza.y)).x;
				bg.follow(camera.x);
			}
			
			player.update();

		}
		
		override public function getPlayerMeters():int
		{
			if(player.lookingRight) return pizza.x /Sport.UNITS_PER_METER;
			return 0;
		}

		
		override public function onKeyUp(key:KeyboardEvent):void 
		{
			
		}
		override public function onKeyDown(key:KeyboardEvent):void 
		{
			if (pizza.shot) return;
			
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
			screenPoint = player.localToGlobal(new Point(pizza.x, pizza.y));				
			addChild(pizza);
			pizza.animate();
			pizza.x = screenPoint.x;
			pizza.y = screenPoint.y;				
			player.lookingRight = true; //ENGANIA
			pizza.shoot(player.percentage, 0, player.lookingRight);
			
		}
		
		public function onReach(e:Event):void
		{
			trace("onReach");
			pizza.stop();
//			win();
		}
		
		override protected function assignBadge():void 
		{
//			if (meters >= 0) 						badge = BADGE_BRONCE;
//			if (meters >= Ball.MAX_DISTANCE * 0.5)  badge = BADGE_SILVER;
//			if (meters >= Ball.MAX_DISTANCE) 	    badge = BADGE_GOLD;
		}
		
	}

}