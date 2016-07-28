package game.sports 
{
	import assets.*;
	
	import com.qb9.flashlib.geom.Vector2D;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import game.Ball;
	import game.LevelEvents;
	import game.MovingObject;
	import game.Sport;
	
//	import gameobject.GameObject;
	
	
	public class DiscusThrow extends Sport 
	{
		private var ball:Ball;
		private var ballOffset:Vector2D = new Vector2D(20, -30);
		
		protected var ballMovieClip:Class;
		protected var rotate:Boolean;
		
		protected var line:MovingObject;
		protected var throwMeters:int;
		
		public function DiscusThrow() 
		{
			super();
			
			ballMovieClip = assets.discusMC;
			rotate = false;
			
			throwMeters = 5;
		}
		
		override public function create():void 
		{
			super.create();
			
			ball = new Ball(new ballMovieClip(), rotate);
			ball.addEventListener("reached", ballReached);
			camera.addChild(ball.asset);
			
			if (rotate) ballOffset = new Vector2D(20, -40);
		}
		
		override protected function addThingsBeforePlayer():void 
		{
			line = new MovingObject(new assets.lineMC);
//			line.debug(false);
			line.loc = new Vector2D(start.loc.x + throwMeters * UNITS_PER_METER, start.loc.y);
//			line.run();
			camera.addChild(line.asset);
		}
		
		override public function reset():void 
		{
			super.reset();
			
			ball.init(start.loc);
			ball.reset();
			
			startPlayer();
		}
		
		protected function startPlayer():void
		{
			player.start(false, true);
		}
		
		override public function update():void 
		{
			if (!playing) return;
			
			super.update();
			
			ball.setPlayerX(player.loc.x);
			ball.update();
			
			if (ball.asset.localToGlobal(new Point(0, 0)).x  > Game.SCREEN_WIDTH / 2)
			{			
				camera.x += ((Game.SCREEN_WIDTH / 2) - (ball.asset.localToGlobal(new Point(0, 0)).x));
			}
			
			if (player.loc.x > line.loc.x)
			{
				player.stop();
				lose();
			}
			
			meters = ball.getMeters();
//			hud.updateMeters(meters);
			
			if (!ball.shot)
			{
//				speedBar.percentage = player.percentage;
				
				var offsetX:Number = ballOffset.x * ((player.lookingRight) ? 1 : -1);
				ball.asset.x += offsetX;
				ball.asset.y += ballOffset.y;
			}
		}
		
		override public function onKeyDown(key:KeyboardEvent):void 
		{
			super.onKeyDown(key);
			
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
		
		override public function assignBadge():void 
		{
			if (meters >= 0) 						badgeObtained = BADGE_BRONCE;
			if (meters >= Ball.MAX_DISTANCE * 0.5)  badgeObtained = BADGE_SILVER;
			if (meters >= Ball.MAX_DISTANCE) 	    badgeObtained = BADGE_GOLD;
		}
		
	}

}