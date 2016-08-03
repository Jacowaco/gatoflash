package game.sports 
{
	import assets.*;
	
	import com.qb9.flashlib.geom.Vector2D;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import game.Avatar;
	import game.Ball;
	import game.LevelEvents;
	
	
	public class DiscusThrow extends Sport 
	{
		private var ball:Ball;
		private var ballOffset:Vector2D = new Vector2D(20, -30);
		
		protected var ballMovieClip:Class;
		protected var rotate:Boolean;
		
		protected var line:MovieClip;
		protected var throwMeters:int;
		private var base:MovieClip;
		
		public function DiscusThrow() 
		{
			
			
			
			create();
			
		}
		
		protected function create():void 
		{

			levelDefinition = new assets.throwingMC;
			base = levelDefinition.base;
			camera.addChild(base);
			
			player = new Avatar(new assets.CorredorMC);			
			player.x = base.x;
			player.y = base.y;
			player.setMode(Avatar.PLAYER);					
			addChild(player);
			
			
			ballMovieClip = assets.discusMC;
			rotate = false;
			
			throwMeters = 5;
			
//			addThingsBeforePlayer();
//			player = new Avatar(new CorredorMC);

			
			//	super.create();
			
			ball = new Ball(new assets.discusMC());
			ball.addEventListener("reached", ballReached);
			ball.rotate(false);
			player.addChild(ball);
			
			if (rotate) ballOffset = new Vector2D(20, -40);
		}
		
		
		
		 protected function addThingsBeforePlayer():void 
		{
			line = new assets.lineMC;
//			line.debug(false);
//			line.loc = new Vector2D(start.loc.x + throwMeters * UNITS_PER_METER, start.loc.y);
//			line.run();
			camera.addChild(line.asset);
		}
		
//		override public function reset():void 
//		{
//			super.reset();
//			
//			ball.init(start.loc);
//			ball.reset();
//			
//			startPlayer();
//		}
//		
		protected function startPlayer():void
		{
			player.start();
		}
		
		override public function update():void 
		{
//			if (!playing) return;
			
//			super.update();
			
			ball.setPlayerX(player.x);
			ball.update();
			
			if (ball.localToGlobal(new Point(0, 0)).x  > Game.SCREEN_WIDTH / 2)
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
			}
		}
		
		
		override public function onKeyUp(key:KeyboardEvent):void 
		{
			
		}
		override public function onKeyDown(key:KeyboardEvent):void 
		{
			if (ball.shot) return;
			
			if (key.keyCode == Keyboard.SPACE)
			{
				player.stop();
//				speedBar.stop();
//				if (!rotate) ball.shoot(speedBar.percentage, -ballOffset.y, player.lookingRight);
//				else ball.shoot(speedBar.percentage, 0, player.lookingRight);
			}
			else if (key.keyCode == Keyboard.LEFT && !leftKeyPressed)
			{
				leftKeyPressed = true;
				player.accelerate();
			}
			else if (key.keyCode == Keyboard.RIGHT && leftKeyPressed)
			{
				leftKeyPressed = false;
				player.accelerate();
			}
		}
		
		public function ballReached(e:Event):void
		{
			win();
		}
		
		override protected function assignBadge():void 
		{
//			if (meters >= 0) 						badge = BADGE_BRONCE;
//			if (meters >= Ball.MAX_DISTANCE * 0.5)  badge = BADGE_SILVER;
//			if (meters >= Ball.MAX_DISTANCE) 	    badge = BADGE_GOLD;
		}
		
	}

}