package game 
{
	import com.qb9.flashlib.geom.Vector2D;
	import flash.display.MovieClip;
	import gameobject.GameObject;
	
	
	public class Hurdle extends GameObject 
	{
		private var _collided:Boolean;
		
		public function Hurdle(mc:MovieClip=null) 
		{
			super(mc);
			
			debug(false);
			_collided = false;
		}
		
		public function init(x:Number, y:Number):void
		{
			loc = new Vector2D(x, y);
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