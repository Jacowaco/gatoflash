package game 
{
	import com.qb9.flashlib.geom.Vector2D;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
//	import gameobject.GameObject;
	
	
	public class Hurdle extends MovingObject 
	{
		private var _collided:Boolean;
		
		public function Hurdle(mc:MovieClip) 
		{
			super(mc);
			_collided = false;
		}
		
		public function collide():void
		{
			if (_collided) return;
			_collided = true;
			asset.rotation = 90;
		}
		
		public function get collided():Boolean
		{
			return _collided;
		}
		
	}

}