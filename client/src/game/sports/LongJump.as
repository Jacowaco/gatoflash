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
	
	
	public class LongJump extends Sport 
	{
		protected var departure:MovieClip;
		protected var line:MovieClip;
		protected var goal:MovieClip;		
		
		
		
		public function LongJump(currentSport:Object) 
		{			
			this.currentSport = currentSport;
			create(); // en este caso llamo yo a create
		}
		
		
		override protected function create():void 
		{
			levelDefinition = new assets.jumpsMC;
			
			departure = levelDefinition.getChildByName("start") as MovieClip;
			line = levelDefinition.getChildByName("line") as MovieClip;
			goal = levelDefinition.getChildByName("goal") as MovieClip;
			
			camera.addChild(departure);
			camera.addChild(line);
			camera.addChild(goal);
			
			createPlayer();
			
			
//			player.addEventListener("reached", playerReached);
		}
		
		private function createPlayer():void
		{
			player = new Avatar();			
			player.x = departure.x;
			player.y = departure.y;
			player.setMode(Avatar.PLAYER);					
			player.setMaxSpeed(currentSport.player.maxSpeed);
			player.setSpeedIncrement(currentSport.player.speedIncrement);			
			camera.addChild(player);
		}
		
		override public function update():void 
		{
			if (!playing) return;
			
			super.update();
			
			camera.x += ((Game.SCREEN_WIDTH / 2) - player.localToGlobal(new Point(0, 0)).x);
			camera.x = Math.min(0, camera.x);
		}
		
		override public function onKeyDown(key:KeyboardEvent):void 
		{
			super.onKeyDown(key);
			
			
			if (key.keyCode == Keyboard.SPACE)
			{
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