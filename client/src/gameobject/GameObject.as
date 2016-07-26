package gameobject
{
	import com.qb9.flashlib.geom.Vector2D;
	import com.qb9.flashlib.motion.MoveTo;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	
	public class GameObject extends EventDispatcher		
	{		
		private var asset_mc:MovieClip;
		private var debugView:Sprite;		
		
		private var location:Vector2D;		

		protected var gravity:Vector2D;
		protected var velocity:Vector2D;
		protected var position:Vector2D;
		protected var mass:Number;
		
		private var constrains:Object = {};
		
		public function GameObject(mc:MovieClip=null)
		{		
			asset_mc = mc;
			var stagePos:Point = asset_mc.localToGlobal(new Point(0,0));
			location = new Vector2D(stagePos.x, stagePos.y);			
			addDebugData();			
		}
		
		private function addDebugData():void
		{
			debugView = new Sprite();
			asset_mc.addChildAt(debugView, 0);			
			debugView.graphics.beginFill(0xff0000, 0.35);
			var rect:Rectangle = asset_mc.getBounds(asset_mc);
			debugView.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			debugView.graphics.endFill();
		}
				
		private function checkConstrains():void
		{
			if(constrains["l"] != undefined && location.x < constrains["l"]) location = new Vector2D(constrains["l"], location.y);
			if(constrains["r"] != undefined && location.x > constrains["r"]) location = new Vector2D(constrains["r"], location.y);
		}
		
		public function run():void
		{
			checkConstrains();
			asset_mc.x = location.x; 
			asset_mc.y = location.y; 
		}
		
		public function moveBy(dx:Number, dy:Number):void
		{
			location = location.add( new Vector2D(dx, dy));
		}		

		public function moveTo(x:Number, y:Number):void
		{
			location = new Vector2D(x, y);
		}		

		public function checkCollision(other:GameObject):Boolean
		{
			if(other.asset_mc.hitTestObject(asset_mc)) return true;			
			return false;			
		}
		

		public function debug(d:Boolean):void
		{
			debugView.visible = d;
		}
		
		
		public function get asset():MovieClip
		{
			return asset_mc;
		}
		
		public function get loc():Vector2D
		{
			return location;	
		}
		
		public function set loc(loc:Vector2D):void
		{
			location = new Vector2D(loc.x, loc.y);	
		}
		
		public function get vel():Vector2D
		{
			return velocity;
		}
		
		public function set vel(vel:Vector2D):void
		{
			velocity = vel;
		}
		
		public function get g():Vector2D
		{
			return gravity;
		}
		
		public function set g(g:Vector2D):void
		{
			gravity = g;
		}
		
		public function get m():Number
		{
			return mass;
		}
		
		public function set m(m:Number):void
		{
			mass = m;
		}
		
		public function isFalling():Boolean{
			return vel.y > 0 ? true : false;
		}
				
		public function setConstrains(l:Number=undefined, r:Number=undefined, t:Number=undefined, b:Number=undefined):void
		{
			constrains["l"] = l;
			constrains["r"] = r;
			constrains["t"] = t;
			constrains["b"] = b;
		}
		
	}
}