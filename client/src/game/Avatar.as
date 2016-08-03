package game 
{
	import com.qb9.flashlib.easing.Tween;
	import com.qb9.flashlib.geom.Vector2D;
	import com.qb9.flashlib.tasks.Func;
	import com.qb9.flashlib.tasks.Parallel;
	import com.qb9.flashlib.tasks.Sequence;
	import com.qb9.flashlib.tasks.TaskEvent;
	import com.qb9.flashlib.tasks.Timeout;
	import com.qb9.flashlib.tasks.Wait;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import game.sports.Metres100;
	import game.sports.Sport;
	
	import utils.Utils;
	
	
	public class Avatar extends Sprite // extends MovingObject 
	{
		
		private var currentMode:int;
		public static const ENEMY:int = 0;
		public static const PLAYER:int = 1;
		
		public var asset:MovieClip;
		
	
		private var speed:Number;
		// TODO externalizar por settings.
		private var speedDamping:Number = -0.5;
		private var speedIncrement:Number = 2.0;
		// TODO estos tambien porque van a depender del juego
		private var MAX_JUMP_DISTANCE:Number = 200;
		private var MAX_JUMP_HEIGHT:Number = 50;
		private var maxSpeed:Number = 1;
		private var spinFactor:Number = 0.3;
		
		private const IDLE:int = 0;
		private const RUNNING:int = 1;
		private const JUMPING:int = 2;
		private const SPINNING:int = 3;
		private const THROWING:int = 4;
		private const FALL:int = 5;
		
		private var state:int = IDLE;
		
		private var currentAnimation:String;
		
		public var lookingRight:Boolean;
		
		private var spinningCont:int;
		private var spinningTime:int;
		
		// como estas tweens van a tener un evento, las dejo como miembro...
		private var anim:Parallel;
		private var to:Timeout;
		
		// null como default no. 
		// no esta bueno porque no arma una interfase. definir las interfases es importante. 
		// o sea, cada vez que creas un MovingObject tenes que saber que le tenes que pasar un mc.
		// entonces lo haces siempre igual...
		//		public function Player(mc:MovieClip=null)		
		public function Avatar(mc:MovieClip)  
		{
			asset = mc;
			addChild(mc);
			speed = 0;
			lookingRight = true;
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
					x += speed;
					break;	
				}
					
				case JUMPING:
				{					
//					trace(">>>>>>>jumping");
					
					break;	
				}
					
				case FALL:
				{
//					trace(">>>>>>> fall");
					break;
				}
				case SPINNING:
				{
					updateSpeed();
					if (speed > maxSpeed * 0.1)
					{
						spinningCont++;
						if (spinningCont > spinningTime)
						{
							spinningCont = 0;
							spinningTime = Math.max(5, spinningTime - 1);
							spin();
						}
					}
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		public function setMode(mode:int):void{
			this.currentMode = mode;					
			if(mode == ENEMY){
				initEnemy();
			}
		}
		public function isJumping():Boolean
		{
			return state == JUMPING;
		}
		
		public function isIdle():Boolean
		{
			return state == IDLE;
		}
		
		public function setMaxSpeed(speed:Number):void
		{
			maxSpeed = speed;
		}
		
		
		private function initEnemy():void
		{
			maxSpeed = Math.min(maxSpeed / 10 + Math.random() * maxSpeed / 10 * 9, maxSpeed);
			speed = maxSpeed;
		}
		
		
		private function setRunning():void
		{						
//			if(mode == PLAYER ) trace("set running: ");
			state = RUNNING;			
		}
		
		private function setIdle():void
		{
			state = IDLE;
		}
		
		public function setSpinning():void
		{
			state = SPINNING;
		}
		
		private function updateSpeed():void
		{	
			if (mode == ENEMY)
			{
				accelerate();
			}
			speed = Math.max(speed + speedDamping, 0);
			speed = Math.min(speed, maxSpeed);	
		}
		
		
		private function checkSpeedForAnimation():void
		{
			if(speed > 0 && speed < maxSpeed / 3 && asset.currentLabel != "run1") asset.gotoAndStop("run1");
			if(speed > maxSpeed / 3 && speed < maxSpeed / 3 * 2 && asset.currentLabel != "run2") asset.gotoAndStop("run2");
			if(speed > maxSpeed / 3 * 2 && speed <= maxSpeed && asset.currentLabel != "run3") asset.gotoAndStop("run3");
		}
		
		public function start():void
		{
			state = RUNNING;
			
			//			jumps = _jumps;
			//			spins = _spins;
//			speed = 0;
//			asset.gotoAndPlay("stand"); 
			
			//			jumped = false;
//			reached = false;
//			lookingRight = true;
//			spinningCont = 0;
//			spinningTime = 12;
//			move = true;
		}
		
		public function stop():void
		{
			state = IDLE;

			//			jumps = false;
			asset.gotoAndPlay("stand");
			//			spins = false;
		}
		
		public function accelerate():void
		{
			speed += speedIncrement;
		}
		
		public function accelerateSpin():void
		{
			speed += speedIncrement;
		}
		
		private function spin():void
		{
			lookingRight = !lookingRight;
			asset.scaleX = -asset.scaleX;
		}
		
		public function get percentage():Number
		{
			//			trace( speed / MAX_SPEED);
			return speed / maxSpeed;
		}
		
		public function getMeters():int
		{
			return int(x / Sport.UNITS_PER_METER);
		}
		
		public function getPower():Number
		{
			return Utils.map(speed, 0, maxSpeed, 0, 1);
		}
		
		public function collide():void
		{
			speed = 0;
			asset.gotoAndStop("fall");
			if(to && to.running) to.dispose() ;
			if(!isJumping()){ // ENGANIA PICHANGA... si vengo saltando, por mas que choque me voy a poner en running eso caga la fruta
				 to = new Timeout(setRunning, 600);
				Game.taskRunner().add(to);	
			}			
			state = FALL;
		}
		
		public function jumpHurdle():void
		{
			if (state == JUMPING) return;
//			if(mode == PLAYER ) trace("jump added: jumping: " , state ==JUMPING);
			state = JUMPING;
			
			
			asset.gotoAndStop("jump");			

			
			var time:Number = 250; //Math.max(Math.abs(distance), 500);
			var distance:Number = MAX_JUMP_DISTANCE;
			var height:Number = MAX_JUMP_HEIGHT;
			
			var startX:Tween = new Tween(this, time, { x: x + distance/2 }, { transition:"linear" } );
			var startY:Tween = new Tween(this, time, { y: y - height}, { transition:"Quad.easeOut" } );
			
			var endX:Tween   = new Tween(this, time, { x: x + distance },     { transition:"linear" } );
			var endY:Tween   = new Tween(this, time, { y: y  },      { transition:"Quad.easeOut" } );
			
			var xtw:Sequence = new Sequence(startX, endX);
			var ytw:Sequence = new Sequence(startY, endY);

			if(anim && anim.running){
				anim.dispose();
			}
			
			anim = new Parallel(xtw, ytw);
			
			anim.addEventListener(TaskEvent.COMPLETE, function(e:Event):void{
				setRunning();
				e.currentTarget.removeEventListener(e.type, arguments.callee);
			});			
			Game.taskRunner().add(anim);
		}
		
		public function get mode():int
		{
			return currentMode;
		}
		
	}
	
}