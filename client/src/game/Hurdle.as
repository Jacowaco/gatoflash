package game 
{
	import com.qb9.flashlib.geom.Vector2D;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class Hurdle extends MovieClip
	{
		
		private var currentLane:String; // para chequear colisiones
		private var isActive:Boolean;
		private var isCollided:Boolean;
		
		public function Hurdle(mc:MovieClip) 
		{
	 		addChild(mc);
			isCollided = false;
			isActive = true;
		}
		
		public function setCurrentLane(laneName:String):void
		{
			currentLane = laneName;
		}
		public function get lane():String
		{
			return currentLane;
		}
		
		public function get active():Boolean
		{
			return isActive;
		}
		
		public function set active(active:Boolean):void
		{
			isActive = active;
		}
		public function collide():void
		{
			if (isCollided) return;
			isCollided = true;
			rotation = 90;
		}
		
		public function get collided():Boolean
		{
			return isCollided;
		}
		
	}

}