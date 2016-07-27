package game 
{
	import com.qb9.flashlib.easing.Tween;
	import com.qb9.flashlib.geom.Vector2D;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
//	import gameobject.GameObject;
	
	
	public class MovingObject extends EventDispatcher
	{
		protected var initialLoc:Vector2D;
		public var loc:Vector2D;
		protected var mc:MovieClip;
		private var constrains:Object = {};
		
		public function MovingObject(mc:MovieClip=null) 
		{
//			super(mc);
//			
//			debug(false);
			this.mc = mc;
			loc = new Vector2D();
			initialLoc = new Vector2D();
		}
		
//		public function update():void
//		{
////			super.run();
//		}
		
		public function run():void
		{
			checkConstrains();
			mc.x = loc.x; 
			mc.y = loc.y; 
		}
		private function checkConstrains():void
		{
			if(constrains["l"] != undefined && loc.x < constrains["l"]) loc = new Vector2D(constrains["l"], loc.y);
			if(constrains["r"] != undefined && loc.x > constrains["r"]) loc = new Vector2D(constrains["r"], loc.y);
		}
		
		public function setConstrains(l:Number=undefined, r:Number=undefined, t:Number=undefined, b:Number=undefined):void
		{
			constrains["l"] = l;
			constrains["r"] = r;
			constrains["t"] = t;
			constrains["b"] = b;
		}
		
		public function init(loc:Vector2D):void
		{
			initialLoc = loc;
		}
		
		public function initLoc(x:int, y:int):void
		{
			initialLoc.add(new Vector2D(x,y));
		}
		
		public function reset():void
		{
			loc = initialLoc;
		}
		
		public function pause():void
		{
			mc.stop();
		}
		
		public function resume():void
		{
			mc.play();
		}
		
		public function get asset():MovieClip
		{
			return mc;
		}
		
	}

}