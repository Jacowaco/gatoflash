package game 
{
	import assets.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Background extends Sprite 
	{
		private var obj1:MovieClip;
		private var obj2:MovieClip;
		private var offset:int = 0;
		private var bgwidth:int = 800;
		
		public function Background() 
		{
			this.obj1 = new assets.backgroundMC();
			this.obj2 = new assets.backgroundMC();
			
			addChild(obj1);
			addChild(obj2);
			reset();
		}
		
		public function reset():void
		{
			obj2.y = obj1.y;
			obj1.x = -20;
			obj2.x = obj1.x + bgwidth;
		}
		
		private var pposition:Number = 0;
		
		public function follow(camera:Number):void
		{			
			var delta:Number = pposition - camera;
			pposition = camera;
			obj1.x -= delta;
			obj2.x -= delta;
			if (obj1.localToGlobal(new Point(0, 0)).x + bgwidth < 0 )
			{
				var tmp:MovieClip = obj1;
				obj1 = obj2;
				obj2 = tmp;
				obj2.x = obj1.x + bgwidth - offset;
			}
		}
		
	}

}