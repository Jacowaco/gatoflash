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
	import game.Player;
	import game.Sport;

//	import gameobject.GameObject;
	
	
	public class LongJump extends Sport 
	{
		protected var line:MovingObject;
		protected var throwMeters:int;
		
		public function LongJump() 
		{
			super();
			
			throwMeters = 8;
		}
		
		 public function create():void 
		{
//			super.create();
			
			player.addEventListener("reached", playerReached);
			player.setJumpVariables(150, 200, 1000);
		}
		
		 protected function addThingsBeforePlayer():void 
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
			
			player.start(true);
		}
		
		override public function update():void 
		{
			if (!playing) return;
			
			super.update();
			
			camera.x += ((Game.SCREEN_WIDTH / 2) - player.asset.localToGlobal(new Point(0, 0)).x);
			camera.x = Math.min(0, camera.x);
			
			if (!player.jumped && player.loc.x > line.loc.x)
			{
				player.stop();
				lose();
			}
			
//			speedBar.percentage = player.percentage;
			
			meters = player.getMeters();
//			hud.updateMeters(meters);
		}
		
		override public function onKeyDown(key:KeyboardEvent):void 
		{
			super.onKeyDown(key);
			
			if (player.jumped) return;
			
			if (key.keyCode == Keyboard.SPACE)
			{
//				speedBar.stop();
//				player.jump(speedBar.percentage, 0);
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
		
		public function playerReached(e:Event):void
		{
			if (player.loc.x > line.loc.x)
				win();
			else
				lose();
		}
		
		override public function assignBadge():void 
		{
			if (meters >= 0) 						  badgeObtained = BADGE_BRONCE;
			if (meters >= Player.MAX_DISTANCE * 0.5)  badgeObtained = BADGE_SILVER;
			if (meters >= Player.MAX_DISTANCE) 	      badgeObtained = BADGE_GOLD;
		}
		
	}

}