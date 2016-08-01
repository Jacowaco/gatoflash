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
	
	import game.sports.Metres100;
	import game.sports.Sport;
	
	
	public class Avatar extends Sprite // extends MovingObject 
	{
		// no tiene nada que ver con el player. es una propiead de la carrera a lo sumo
		//		public static var MIN_DISTANCE:int = 200;
		//		public static var MAX_DISTANCE:int = 1000;
		
		private var mode:int;
		public static const ENEMY:int = 0;
		public static const PLAYER:int = 1;
		
		private var asset:MovieClip;
		
		//TODO implementar estados
		//		private var jumps:Boolean;
		//		private var spins:Boolean;
		
		private var speed:Number;
		// TODO externalizar por settings.
		private var speedDamping:Number = -0.5;
		private var speedIncrement:Number = 2.0;
		// TODO estos tambien porque van a depender del juego
		private var MAX_JUMP_DISTANCE:Number = 20;
		private var MAX_JUMP_HEIGHT:Number = 5;
		private var MAX_SPEED:Number = 20;
		
		
		
		private const IDLE:int = 0;
		private const RUNNING:int = 1;
		private const JUMPING:int = 2;
		private const SPINNING:int = 3;
		private const THROWING:int = 4;
		
		private var state:int = IDLE;
		
		private var currentAnimation:String;
		
		private var offset:Point;
		private var traveledDistance:Number;
		
		private var reached:Boolean;
		private var onReached:Event;
		
		//		public var jumped:Boolean;
		// CHUPALA !!!
		//		private var hurdleLevel:Boolean;
		
		private var jumpingX:Number;
		private var stopAtJump:Boolean;
		
		public var lookingRight:Boolean;
		
		private var spinningCont:int;
		private var spinningTime:int;
		private var move:Boolean;
		
		// null como default no. 
		// no esta bueno porque no arma una interfase. definir las interfases es importante. 
		// o sea, cada vez que creas un MovingObject tenes que saber que le tenes que pasar un mc.
		// entonces lo haces siempre igual...
		//		public function Player(mc:MovieClip=null)		
		public function Avatar(mc:MovieClip)  
		{
			asset = mc;
			addChild(mc);
			onReached = new Event("reached");
			offset = new Point();	
			speed = 0;
		}
		
		public function update():void 
		{
			switch(state)
			{
				case IDLE:
				{
					
					break;
				}
					
				case RUNNING:
				{
					updateSpeed();	
					checkSpeedForAnimation();
					if(mode == PLAYER) trace(speed);
					x += speed;
					break;	
				}
					
				case JUMPING:
				{
					trace("jumping");
					speed = Math.max(speed + speedDamping, 0);
					speed = Math.min(speed, MAX_SPEED);
					trace(x, y);
					break;	
				}
					
					
					
				default:
				{
					break;
				}
			}
			
			
			//			
			//			if (jumps)
			//			{
			//				if (!jumped || hurdleLevel)
			//				{
			//					speed = Math.max(speed - 0.25, 0);
			//					speed = Math.min(speed, maxSpeed);
			//					x += speed;
			//				}
			//				if (jumped)
			//				{
			//					if (hurdleLevel) {
			//						y += offset.y;
			//				}else {
			//						x += jumpingX;
			//						y = offset.y;
			//					}
			//					if (jumped && !reached && Game.taskRunner().empty)//offset.x == distance)
			//					{
			//						if (stopAtJump)
			//						{
			//							reached = true;
			//							asset.gotoAndPlay("stand");
			//							var wait:Wait = new Wait(200);
			//							var dispatchReached:Func = new Func(function():void { dispatchEvent(onReached); } );
			//							var seq:Sequence = new Sequence(wait, dispatchReached);
			//							Game.taskRunner().add(seq);
			//						}
			//						else
			//						{
			//							jumped = false;
			//						}
			//					}
			//				}
			//			}
			//			else
			//			{
			//				
			//				var spinFactor:Number = (spins) ? 0.3 : 1;
			//				x += speed*spinFactor;
			//				
			//				if (spins && speed > maxSpeed * 0.1)
			//				{
			//					spinningCont++;
			//					if (spinningCont > spinningTime)
			//					{
			//						spinningCont = 0;
			//						spinningTime = Math.max(5, spinningTime - 1);
			//						spin();
			//					}
			//				}
			//			}
		}
		
		public function setMode(mode:int):void{
			this.mode = mode;
			if(mode == ENEMY){
				speed = Math.min(MAX_SPEED / 10 + Math.random() * MAX_SPEED / 10 * 9, MAX_SPEED);
			}
		}
		
		public function setRunning():void
		{						
			state = RUNNING;
			
		}
		
		private function updateSpeed():void
		{	
			if(mode == ENEMY) return;
			speed = Math.max(speed + speedDamping, 0);
			speed = Math.min(speed, MAX_SPEED);	
			
			
		}
		
		
		private function checkSpeedForAnimation():void
		{
			if(speed > 0 && speed < MAX_SPEED / 3 && asset.currentLabel != "run1") asset.gotoAndStop("run1");
			if(speed > MAX_SPEED / 3 && speed < MAX_SPEED / 3 * 2 && asset.currentLabel != "run2") asset.gotoAndStop("run2");
			if(speed > MAX_SPEED / 3 * 2 && speed < MAX_SPEED && asset.currentLabel != "run3") asset.gotoAndStop("run3");
		}
		
		public function start():void
		{
			//			jumps = _jumps;
			//			spins = _spins;
			speed = 0;
			asset.gotoAndPlay("stand"); 
			
			//			jumped = false;
			reached = false;
			lookingRight = true;
			spinningCont = 0;
			spinningTime = 12;
			move = true;
		}
		
		public function stop():void
		{
			move = false;
			//			jumps = false;
			asset.gotoAndPlay("stand");
			//			spins = false;
		}
		
		public function accelerate():void
		{
			speed += speedIncrement;
		}
		
		private function spin():void
		{
			//			if (spins)
			//			{
			//				lookingRight = !lookingRight;
			//				asset.scaleX = -asset.scaleX;
			//			}
		}
		
		public function get percentage():Number
		{
			trace( speed / MAX_SPEED);
			return speed / MAX_SPEED;
		}
		
		public function getMeters():int
		{
			return int(x / Sport.UNITS_PER_METER);
		}
		
		public function collideHurdle():void
		{
			speed = 0;
		}
		
		public function setJumpVariables(distance_y:int, min_distance:int, max_distance:int, _stopAtJump:Boolean=true, _hurdleLevel:Boolean=false):void
		{
			//			DISTANCE_Y = distance_y;
			//			MIN_DISTANCE = min_distance;
			//			MAX_DISTANCE = max_distance;
			//			stopAtJump = _stopAtJump;
			//			hurdleLevel = _hurdleLevel;
		}
		
		public function jump():void
		{
			
			
			if (state == JUMPING) return;
			state = JUMPING;
			
			//			traveledDistance = _power * MAX_DISTANCE + MIN_DISTANCE;
			//			jumpingX = x;
			offset.x = offset.y = 0;
			//			var time:Number = Math.max(Math.abs(traveledDistance), 500);
			//			
			var time:Number = 500;
			var distance:Number = speed * MAX_JUMP_DISTANCE;
			var height:Number = speed * MAX_JUMP_HEIGHT;
			
			var startX:Tween = new Tween(this, time, { x: x + distance/2 }, { transition:"linear" } );
			var startY:Tween = new Tween(this, time, { y: y - height}, { transition:"Quad.easeOut" } );
			
			var endX:Tween   = new Tween(this, time, { x: x + distance },     { transition:"linear" } );
			var endY:Tween   = new Tween(this, time, { y: y  },      { transition:"Quad.easeIn" } );
			
			var inAnim:Parallel = new Parallel(startX, startY);
			var outAnim:Parallel = new Parallel(endX, endY);
			
			var sequence:Sequence = new Sequence(inAnim, outAnim);
			sequence.addEventListener(TaskEvent.COMPLETE, function():void {state = RUNNING});			
			Game.taskRunner().add(sequence);
		}
		
	}
	
}