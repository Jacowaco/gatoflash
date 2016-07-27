package game 
{
	import com.qb9.flashlib.easing.Tween;
	import com.qb9.flashlib.geom.Vector2D;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import gameobject.GameObject;
	
	
	public class MovingObject extends GameObject 
	{
		protected var initialLoc:Vector2D;
		
		public function MovingObject(mc:MovieClip=null) 
		{
			super(mc);
			
			debug(false);
		}
		
		public function update():void
		{
			super.run();
		}
		
		public function init(loc:Vector2D):void
		{
			initialLoc = loc;
		}
		
		public function reset():void
		{
			loc = initialLoc;
		}
		
		public function pause():void
		{
			asset.stop();
		}
		
		public function resume():void
		{
			asset.play();
		}
		
	}

}