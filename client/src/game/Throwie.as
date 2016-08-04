package game 
{
	import com.qb9.flashlib.easing.Tween;
	import com.qb9.flashlib.geom.Vector2D;
	import com.qb9.flashlib.tasks.Func;
	import com.qb9.flashlib.tasks.Parallel;
	import com.qb9.flashlib.tasks.Sequence;
	import com.qb9.flashlib.tasks.TaskEvent;
	import com.qb9.flashlib.tasks.Wait;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	
	public class Throwie extends Sprite // MovingObject 
	{

		public static const MIN_DISTANCE:int = 100;
		public static const MAX_DISTANCE:int = 2500;
		public static const ON_REACH:String = "onReach";
//		
//		private const START_ANGLE:int = -40;
//		private const END_ANGLE:int = 40;
		
//		private var TIME:int = 2000;
		private var DISTANCE_Y:int = 20;
//		private var onReached:Event;
		public var shot:Boolean;
//		private var offset:Point;
		private var distance:Number;
		private var reached:Boolean;
		private var mc:MovieClip;
		
		public function Throwie(mc:MovieClip) 
		{

			this.mc = mc;
			addChild(mc);
			mc.asset.stop();
			
			
//			onReached = new Event("reached");
//			offset = new Point();
			
			shot = false;
			reached = false;
		}
		
		
		
		
//		public function rotate(rot:Boolean):void
//		{
//			if(rot)  mc.asset.gotoAndPlay(1);
//			if(!rot) mc.asset.stop();
//		}
//		
//		public function update(_playerX:Number):void 
//		{
//			if (shot && !reached && offset.x == distance)
//			{
//				reached = true;
//				var wait:Wait = new Wait(200);
//				var dispatchReached:Func = new Func(function():void { dispatchEvent(onReached); } );
//				var seq:Sequence = new Sequence(wait, dispatchReached);
//				Game.taskRunner().add(seq);
//			}
////			loc = new Vector2D(offset.x + playerX, initialLoc.y + offset.y);
//			x = offset.x + _playerX;
//			y = offset.y;
//		}
		
		public function shoot(_power:Number, offsetY:Number, _right:Boolean=true):void
		{
			if (shot) return;
			shot = true;
			trace("SHOOTING");
			trace(_power, offsetY, _right);
			distance = (_power * MAX_DISTANCE + MIN_DISTANCE) * (_right ? 1 : -1);
			trace(distance);
			var time:Number = Math.max(Math.abs(distance), 500);
			
			var startX:Tween = new Tween(this, time, { x: x + distance / 2 }, { transition:"linear" } );
			var startY:Tween = new Tween(this, time, { y: y - DISTANCE_Y }, { transition:"Quad.easeOut" } );
			
			var endX:Tween   = new Tween(this, time, { x: x + distance },     { transition:"linear" } );
			var endY:Tween   = new Tween(this, time, { y: y + offsetY },      { transition:"Quad.easeIn" } );
			var sequenceX:Sequence = new Sequence(startX, endX);
			var sequenceY:Sequence = new Sequence(startY, endY);
			var para:Parallel = new Parallel(sequenceX, sequenceY);
			para.addEventListener(TaskEvent.COMPLETE, function(e:Event):void{dispatchEvent(new Event(ON_REACH));});
			Game.taskRunner().add(para);
			
			
//			if (rotate)
//			{
//				var startRotate:Tween = new Tween(mc, distance, { rotation:0 },         { transition:"linear" } );
//				var endRotate:Tween   = new Tween(mc, distance, { rotation:END_ANGLE }, { transition:"linear" } );
//				var sequenceRotate:Sequence = new Sequence(startRotate, endRotate);
//				Game.taskRunner().add(sequenceRotate);
//			}
		}
		
		public function animate():void
		{
			mc.asset.gotoAndPlay(1);
		}
		
		public function stop():void
		{
			mc.asset.stop();
		}
		public function getMeters():int
		{
			return this.x ; //int(offset.x * 0.01);
		}
		
	}

}