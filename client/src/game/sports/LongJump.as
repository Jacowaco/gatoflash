package game.sports 
{
	import assets.*;
	
	import com.qb9.flashlib.geom.Vector2D;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import game.Throwie;

	import game.Avatar;
	import avatar.corredorMC;
	public class LongJump extends Sport 
	{
		protected var line:MovieClip;
		protected var throwMeters:int;
		private var base:MovieClip;
		
		public function LongJump() 
		{			
			throwMeters = 8;			
			create();
		}
		
		
		override protected function create():void 
		{
			levelDefinition = new assets.throwingMC;
			base = levelDefinition.base;
			camera.addChild(base);
			
			player = new Avatar();			
			player.x = base.x;
			player.y = base.y;
			player.setMode(Avatar.PLAYER);					
			addChild(player);
			
			player.addEventListener("reached", playerReached);
//			player.setJumpVariables(150, 200, 1000);
		}
		
//		 protected function addThingsBeforePlayer():void 
//		{
//			line = new MovingObject(new assets.lineMC);
////			line.debug(false);
//			line.loc = new Vector2D(start.loc.x + throwMeters * UNITS_PER_METER, start.loc.y);
////			line.run();
//			camera.addChild(line.asset);
//		}
		
//		protected function start():void
//		{
//			player.start();
//			playing = true;
//		}
//		
		override public function update():void 
		{
			if (!playing) return;
			
			super.update();
			
			camera.x += ((Game.SCREEN_WIDTH / 2) - player.localToGlobal(new Point(0, 0)).x);
			camera.x = Math.min(0, camera.x);
			
//			if (!player.jumped && player.loc.x > line.loc.x)
//			{
//				player.stop();
//				lose();
//			}
			
//			speedBar.percentage = player.percentage;
			
//			meters = player.getMeters();
//			hud.updateMeters(meters);
		}
		
		override public function onKeyDown(key:KeyboardEvent):void 
		{
			super.onKeyDown(key);
			
//			if (player.jumped) return;
			
			if (key.keyCode == Keyboard.SPACE)
			{
//				speedBar.stop();
//				player.jump(speedBar.percentage, 0);
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
		
		public function playerReached(e:Event):void
		{

		}
		
		override protected function assignBadge():void 
		{

		}
		
	}

}