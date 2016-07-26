package game 
{
	import com.qb9.flashlib.easing.Tween;
	import com.qb9.flashlib.geom.Vector2D;
	import com.qb9.flashlib.tasks.Sequence;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import game.sports.Hurdles;
	import game.sports.Metres100;
	
	
	public class Enemy extends MovingObject 
	{
		private var speed:Number;
		private var maxSpeed:Number = 19;
		public var baseAccel:Number;
		
		private var DISTANCE_Y:int = 120;
		private var MIN_DISTANCE:int = 0;
		private var MAX_DISTANCE:int = 400;
		private var offset:Point;
		private var distance:Number;
		private var reached:Boolean;
		private var jumped:Boolean;
		private var jumpingX:Number;
		private var stopAtJump:Boolean;
		public var nextJumpDist:int;
		
		public function Enemy(mc:MovieClip, speedFactor:Number) 
		{
			super(mc);
			
			maxSpeed += speedFactor;
			baseAccel = 0.01 * speedFactor;
			
			offset = new Point();
		}
		
		override public function update():void 
		{
			super.update();
			
			speed = Math.min(speed + 0.07 + baseAccel + Math.random() * 0.03, maxSpeed);
			loc = loc.add(new Vector2D(speed, 0));
			
			if (jumped)
			{
				if (jumped && !reached && offset.x == distance)
				{
					jumped = false;
				}
				loc = new Vector2D(loc.x, initialLoc.y + offset.y);
			}
		}
		
		public function start():void
		{
			speed = 0;
			asset.gotoAndPlay("walk");
			
			jumped = false;
			reached = false;
			
			randomizeNextJumpDist();
		}
		
		public function stop():void
		{
			asset.gotoAndPlay("standBy");
		}
		
		public function getMeters():int
		{
			return int((loc.x - initialLoc.x) / Sport.UNITS_PER_METER);
		}
		
		public function collideHurdle():void
		{
			speed = 0;
		}
		
		public function jump(_power:Number, offsetY:Number):void
		{
			if (jumped) return;
			jumped = true;
			distance = _power * MAX_DISTANCE + MIN_DISTANCE;
			jumpingX = loc.x;
			offset.x = offset.y = 0;
			
			var startX:Tween = new Tween(offset, distance, { x:distance / 2 }, { transition:"linear" } );
			var startY:Tween = new Tween(offset, distance, { y: -DISTANCE_Y }, { transition:"Quad.easeOut" } );
			var endX:Tween   = new Tween(offset, distance, { x:distance },     { transition:"linear" } );
			var endY:Tween   = new Tween(offset, distance, { y:offsetY },      { transition:"Quad.easeIn" } );
			var sequenceX:Sequence = new Sequence(startX, endX);
			var sequenceY:Sequence = new Sequence(startY, endY);
			Game.taskRunner().add(sequenceX);
			Game.taskRunner().add(sequenceY);
			
			randomizeNextJumpDist();
		}
		
		public function randomizeNextJumpDist():void
		{
			nextJumpDist = Math.random() * Hurdles.COLISION_RANGE * 5 + Hurdles.COLISION_RANGE * 1;
		}
	}

}