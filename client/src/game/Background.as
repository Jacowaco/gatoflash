package game 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
//	import gameobject.GameObject;
	
	
	public class Background extends Sprite 
	{
		private var obj1:MovieClip;
		private var obj2:MovieClip;
		private var offset:int = 0;
		
		public function Background(obj1:MovieClip, obj2:MovieClip) 
		{
			this.obj1 = obj1;
			this.obj2 = obj2;
			obj2.y = obj1.y;
			addChild(obj1);
			addChild(obj2);
		}
		
		public function reset():void
		{
			obj1.x = 0;
			obj2.x = obj1.x + obj1.width;
		}
		
		public function update():void
		{
			if (obj1.localToGlobal(new Point(0, 0)).x + obj1.width < 0 )
			{
				var tmp:MovieClip = obj1;
				obj1 = obj2;
				obj2 = tmp;
				obj2.x = obj1.x + obj1.width - offset;
			}
		}
		
	}

}