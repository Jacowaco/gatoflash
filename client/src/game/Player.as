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
	import game.sports.Metres100;
	
	
	public class Player extends MovingObject 
	{
		public static var MIN_DISTANCE:int = 200;
		public static var MAX_DISTANCE:int = 1000;
		
		private var jumps:Boolean;
		private var spins:Boolean;
		private var speed:Number;
		private var maxSpeed:Number = 24;
		
		private var DISTANCE_Y:int = 150;
		
		private var offset:Point;
		private var distance:Number;
		private var reached:Boolean;
		private var onReached:Event;
		public var jumped:Boolean;
		private var hurdleLevel:Boolean;
		private var jumpingX:Number;
		private var stopAtJump:Boolean;
		public var lookingRight:Boolean;
		private var spinningCont:int;
		private var spinningTime:int;
		private var move:Boolean;
		
		public function Player(mc:MovieClip=null) 
		{
			super(mc);
			
			onReached = new Event("reached");
			offset = new Point();
		}
		
		override public function update():void 
		{
			super.update();
			
			if (!move) return;
			
			if (jumps)
			{
				if (!jumped || hurdleLevel)
				{
					speed = Math.max(speed - 0.25, 0);
					speed = Math.min(speed, maxSpeed);
					loc = loc.add(new Vector2D(speed, 0));
				}
				if (jumped)
				{
					if (hurdleLevel) loc = new Vector2D(loc.x, initialLoc.y + offset.y);
					else loc = new Vector2D(offset.x + jumpingX, initialLoc.y + offset.y);
					//trace("y", offset.y);
					
					if (jumped && !reached && Game.taskRunner().empty)//offset.x == distance)
					{
						if (stopAtJump)
						{
							reached = true;
							asset.gotoAndPlay("stand");
							var wait:Wait = new Wait(200);
							var dispatchReached:Func = new Func(function():void { dispatchEvent(onReached); } );
							var seq:Sequence = new Sequence(wait, dispatchReached);
							Game.taskRunner().add(seq);
						}
						else
						{
							jumped = false;
						}
					}
				}
			}
			else
			{
				speed = Math.max(speed - 0.25, 0);
				speed = Math.min(speed, maxSpeed);
				var spinFactor:Number = (spins) ? 0.3 : 1;
				loc = loc.add(new Vector2D(speed * spinFactor, 0));
				if (spins && speed > maxSpeed * 0.1)
				{
					spinningCont++;
					if (spinningCont > spinningTime)
					{
						spinningCont = 0;
						spinningTime = Math.max(5, spinningTime - 1);
						spin();
					}
				}
			}
		}
		
		public function start(_jumps:Boolean, _spins:Boolean=false):void
		{
			jumps = _jumps;
			spins = _spins;
			speed = 0;
			asset.gotoAndPlay("stand"); 
			
			jumped = false;
			reached = false;
			lookingRight = true;
			spinningCont = 0;
			spinningTime = 12;
			move = true;
		}
		
		public function stop():void
		{
			move = false;
			jumps = false;
			asset.gotoAndPlay("stand");
			//speed = 0;
			spins = false;
		}
		
		public function accelerate():void
		{
			speed += 1;
			asset.gotoAndPlay("run1");
		}
		
		private function spin():void
		{
			if (spins)
			{
				lookingRight = !lookingRight;
				asset.scaleX = -asset.scaleX;
			}
		}
		
		public function get percentage():Number
		{
			return speed / maxSpeed;
		}
		
		public function getMeters():int
		{
			return int((loc.x - initialLoc.x) / Sport.UNITS_PER_METER);
		}
		
		public function collideHurdle():void
		{
			speed = 0;
		}
		
		public function setJumpVariables(distance_y:int, min_distance:int, max_distance:int, _stopAtJump:Boolean=true, _hurdleLevel:Boolean=false):void
		{
			DISTANCE_Y = distance_y;
			MIN_DISTANCE = min_distance;
			MAX_DISTANCE = max_distance;
			stopAtJump = _stopAtJump;
			hurdleLevel = _hurdleLevel;
		}
		
		public function jump(_power:Number, offsetY:Number):void
		{
			if (jumped) return;
			jumped = true;
			distance = _power * MAX_DISTANCE + MIN_DISTANCE;
			jumpingX = loc.x;
			offset.x = offset.y = 0;
			var time:Number = Math.max(Math.abs(distance), 500);
			
			var startX:Tween = new Tween(offset, time, { x:distance / 2 }, { transition:"linear" } );
			var startY:Tween = new Tween(offset, time, { y: -DISTANCE_Y }, { transition:"Quad.easeOut" } );
			var endX:Tween   = new Tween(offset, time, { x:distance },     { transition:"linear" } );
			var endY:Tween   = new Tween(offset, time, { y:offsetY },      { transition:"Quad.easeIn" } );
			var sequenceX:Sequence = new Sequence(startX, endX);
			var sequenceY:Sequence = new Sequence(startY, endY);
			Game.taskRunner().add(sequenceX);
			Game.taskRunner().add(sequenceY);
		}
		
	}

}