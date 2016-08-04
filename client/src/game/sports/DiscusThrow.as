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
//		private var ballOffset:Vector2D = new Vector2D(20, -30);
		
		//protected var ballMovieClip:Class;
		//protected var rotate:Boolean;
		
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
			player.setSpinIncrement(settings.sports[currentSport].spinIncrement);
			camera.addChild(player);
			
			
			//ballMovieClip = assets.discusMC;
			//rotate = false;
			
			throwMeters = 5;
			
			pizza = new Throwie(new assets.discusMC());
			pizza.addEventListener(Throwie.ON_REACH, onReach);
			
//			ball.x = player.x + ballOffset.x;
//			ball.y = player.y + ballOffset.y;
//			ball.addEventListener("reached", ballReached);
//			ball.rotate(false);
			player.addChild(pizza);
			
			//if (rotate) ballOffset = new Vector2D(20, -40);
		}
		
		override public function start():void
		{
			player.setSpinning();
			//player.start();
			playing = true;
		}
		
		override public function update():void 
		{
			if (!playing) return;
			
			if(player.lookingRight){
				camera.x = screenPoint.x - pizza.x;
				bg.follow(camera.x);
			}
												
			
			
			player.update();
//			ball.update(player.x);
			
			/*if (ball.localToGlobal(new Point(0, 0)).x  > Game.SCREEN_WIDTH / 2)
			{			
				camera.x += ((Game.SCREEN_WIDTH / 2) - (ball.localToGlobal(new Point(0, 0)).x));
			}
			
//			if (player.x > line.x)
//			{
//				player.stop();
//				lose();
//			}
			
//			meters = ball.getMeters();
//			hud.updateMeters(meters);
			
			if (!ball.shot)
			{
//				speedBar.percentage = player.percentage;				
				var offsetX:Number = ballOffset.x * ((player.lookingRight) ? 1 : -1);
				ball.x += offsetX;
				ball.y += ballOffset.y;
			}*/
		}
		
		
		override public function onKeyUp(key:KeyboardEvent):void 
		{
			
		}
		var screenPoint:Point = new Point();;
		override public function onKeyDown(key:KeyboardEvent):void 
		{
			if (pizza.shot) return;
			
			if (key.keyCode == Keyboard.SPACE)
			{
				player.throwing();
				screenPoint = player.localToGlobal(new Point(pizza.x, pizza.y));
				trace(screenPoint);
				addChild(pizza);
				pizza.animate();
				pizza.x = screenPoint.x;
				pizza.y = screenPoint.y;
//				speedBar.stop();
				
				pizza.shoot(player.percentage, 0, player.lookingRight);//  
//				if (!rotate) ball.shoot(speedBar.percentage, -ballOffset.y, player.lookingRight);
//				else ball.shoot(speedBar.percentage, 0, player.lookingRight);
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