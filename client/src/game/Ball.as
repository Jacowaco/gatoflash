package game 
{
	import com.qb9.flashlib.easing.Tween;
	import com.qb9.flashlib.geom.Vector2D;
	import com.qb9.flashlib.tasks.Func;
	import com.qb9.flashlib.tasks.Sequence;
	import com.qb9.flashlib.tasks.Wait;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	
	public class Ball extends MovingObject 
	{
		public static const MIN_DISTANCE:int = 500;
		public static const MAX_DISTANCE:int = 2500;
		
		private const START_ANGLE:int = -40;
		private const END_ANGLE:int = 40;
		
		private var TIME:int = 2000;
		private var DISTANCE_Y:int = 220;
		private var onReached:Event;
		public var shot:Boolean;
		private var offset:Point;
		private var distance:Number;
		private var reached:Boolean;
		private var playerX:Number;
		private var rotate:Boolean;
		
		public function Ball(mc:MovieClip, _rotate:Boolean) 
		{
			super(mc);
			
			rotate = _rotate;
			
			onReached = new Event("reached");
			offset = new Point();
		}
		
		override public function reset():void 
		{
			super.reset();
			
			offset.x = offset.y = 0;
			shot = false;
			reached = false;
			if (rotate) asset.rotation = START_ANGLE;
		}
		
		public function setPlayerX(value:Number):void
		{
			playerX = value;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (shot && !reached && offset.x == distance)
			{
				reached = true;
				var wait:Wait = new Wait(200);
				var dispatchReached:Func = new Func(function():void { dispatchEvent(onReached); } );
				var seq:Sequence = new Sequence(wait, dispatchReached);
				Game.taskRunner().add(seq);
			}
			loc = new Vector2D(offset.x + playerX, initialLoc.y + offset.y);
		}
		
		public function shoot(_power:Number, offsetY:Number, _right:Boolean=true):void
		{
			if (shot) return;
			shot = true;
			distance = (_power * MAX_DISTANCE + MIN_DISTANCE) * ((_right) ? 1 : -1);
			var time:Number = Math.max(Math.abs(distance), 500);
			
			var startX:Tween = new Tween(offset, time, { x:distance / 2 }, { transition:"linear" } );
			var startY:Tween = new Tween(offset, time, { y: -DISTANCE_Y }, { transition:"Quad.easeOut" } );
			var endX:Tween   = new Tween(offset, time, { x:distance },     { transition:"linear" } );
			var endY:Tween   = new Tween(offset, time, { y:offsetY },      { transition:"Quad.easeIn" } );
			var sequenceX:Sequence = new Sequence(startX, endX);
			var sequenceY:Sequence = new Sequence(startY, endY);
			Game.taskRunner().add(sequenceX);
			Game.taskRunner().add(sequenceY);
			
			if (rotate)
			{
				var startRotate:Tween = new Tween(asset, distance, { rotation:0 },         { transition:"linear" } );
				var endRotate:Tween   = new Tween(asset, distance, { rotation:END_ANGLE }, { transition:"linear" } );
				var sequenceRotate:Sequence = new Sequence(startRotate, endRotate);
				Game.taskRunner().add(sequenceRotate);
			}
		}
		
		public function getMeters():int
		{
			return int(offset.x * 0.01);
		}
		
	}

}