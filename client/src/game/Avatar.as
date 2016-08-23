package game 
{
	import assets.*;
	
	import avatar.corredorMC;
	
	import com.qb9.flashlib.easing.Tween;
	import com.qb9.flashlib.geom.Vector2D;
	import com.qb9.flashlib.movieclip.actions.GotoAndStopAction;
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
	import flash.utils.setTimeout;
	
	import game.sports.Sport;
	
	import utils.Utils;
	
	public class Avatar extends Sprite  
	{
		
		public static const ON_LANDING:String = "onLanding";
		
		private var currentMode:int = ENEMY;
		
		public static const ENEMY:int = 0;
		public static const PLAYER:int = 1;
		public static const FOREST:int = 2;
		
		private var state:int = IDLE;
		
		private const IDLE:int = 0;
		private const RUNNING:int = 1;
		private const JUMPING:int = 2;
		private const SPINNING:int = 3;
		private const THROWING:int = 4;
		private const FALL:int = 5;
		private const MOON:int = 6;  // camina pero no se mueve 
		
		
		private var asset:MovieClip;
		private var playerArrow:MovieClip;
		
		// TODO externalizar por settings.
		private var speedDamping:Number = 0.5;
		private var speedIncrement:Number; 
		
		private var MAX_JUMP_DISTANCE:Number = 200;
		private var MAX_JUMP_HEIGHT:Number = 50;
		
		
		private var power:Number;
		private var maxSpeed:Number = 1;
		
		
		
		private var currentAnimation:String;
		
		public var lookingRight:Boolean;
		
		private var spinFactor:Number = 0.3;		
		private var spinningCont:int;
		private var spinningTime:int;
		
		// como estas tweens van a tener un evento, las dejo como miembro...
		private var anim:Parallel;
		private var to:Timeout;
		
		public function Avatar()  
		{
			asset = new avatar.corredorMC;			
			
			playerArrow = new flechaYoMc();
			playerArrow.y = -90;
			asset.addChild(playerArrow);
			playerArrow.visible = false;
			
			
			addChild(asset);
			power = 0;
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
					x += power;
					break;	
				}
					
				case MOON:
				{
					updateSpeed();	
					checkSpeedForAnimation();
					break;	
				}
					
				case JUMPING:
				{										
					break;	
				}
					
				case FALL:
				{
					break;
				}
				case SPINNING:
				{
					updateSpeed();
					if (power > maxSpeed * 0.1)
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
		
		public function setSpeedIncrement(speed:Number):void
		{
			speedIncrement = speed; 
		}	
		
		public function setSpeedDamping(speed:Number):void
		{
			speedDamping = speed; 
		}
		
		public function setRunning():void
		{						
			state = RUNNING;			
		}
		
		public function setIdle():void
		{
			trace("setIdle");
			asset.gotoAndStop("idle");
			state = IDLE;
		}
		
		public function setMoonWalk():void
		{
			state = MOON;
			setReadyToThrow();
		}
		
		
		public function setSpinning():void
		{
			state = SPINNING;
		}
		
		public function go():void
		{
			setRunning();
			showArrowHint();						
		}
		
		public function stop():void
		{
			setIdle();
			asset.gotoAndPlay("stand");
		}
		
		private function updateSpeed():void
		{	
			if (mode == ENEMY || mode == FOREST)
			{
				increasePower();				
			}
			
			power = Math.max(power - speedDamping, 0);
			power = Math.min(power, maxSpeed);
		}
		
		
		private function checkSpeedForAnimation():void
		{
			if(power == 0){				
				if(asset.currentLabel != "stand" ) asset.gotoAndStop("stand");				 
				audio.fx.stop("correr");
			}
			
			if(! mode == ENEMY) if( !power == 0 && Math.random() < 0.20 && !audio.fx.retrieve("correr").playing) audio.fx.play("correr");
			
			if(power > 0 && power < maxSpeed / 3 && asset.currentLabel != "run1") asset.gotoAndStop("run1");
			if(power > maxSpeed / 3 && power < maxSpeed / 3 * 2 && asset.currentLabel != "run2") asset.gotoAndStop("run2");
			if(power > maxSpeed / 3 * 2 && power <= maxSpeed && asset.currentLabel != "run3") asset.gotoAndStop("run3");
		}
	
		public function increasePower():void
		{
			power += speedIncrement;
		}

		private function spin():void
		{
			lookingRight = !lookingRight;
			scaleX = -scaleX;
		}
		
		public function get percentage():Number
		{
			
			return power / maxSpeed;
		}
		
		public function getMeters():int
		{
			return int(x / Sport.UNITS_PER_METER);
		}
		
		public function getPower():Number
		{
			return Utils.map(power, 0, maxSpeed, 0, 1);
		}
		
		public function crash():void
		{
			asset.gotoAndStop("fall");
		}
		
		public function setReadyToThrow():void
		{
			asset.gotoAndStop("throw_start");
		}
		
		public function collide():void
		{
			if(! mode==ENEMY) audio.fx.play("valla");			
			asset.gotoAndStop("fall");
			power = 0;			
			if(to && to.running) to.dispose() ;
			if(!isJumping()){ // ENGANIA PICHANGA... si vengo saltando, por mas que choque me voy a poner en running eso caga la fruta
				 to = new Timeout(setRunning, 600);
				Game.taskRunner().add(to);	
			}			
			state = FALL;
		}		
		
		public function throwing():void
		{
			state = THROWING;
			asset.gotoAndPlay("throw");			
		}
		
		
		public function jump(jump:Object):void
		{
			if (state == JUMPING) return;
			state = JUMPING;
			if (!mode == ENEMY) {
				switch (jump.mode){
					case "hurdle":
						audio.fx.play("saltoCorto");
						break;
					case "long":
						audio.fx.play("saltoLargo");
						break;
					case "high":
						audio.fx.play("saltoLargo");
						break;
				}
				
			}
			
			asset.gotoAndStop("jump");		
			
			var distance:Number = Utils.map(getPower(), 0.0, 1.0, jump.minx * Sport.UNITS_PER_METER, jump.maxx * Sport.UNITS_PER_METER);
			var height:Number = Utils.map(getPower(), 0,1,jump.miny,jump.maxy);;			
			var time:Number = Point.distance(new  Point(), new Point(distance, height));
			
			var startX:Tween = new Tween(this, time, { x: x + distance/2 }, { transition:"linear" } );
			var startY:Tween = new Tween(this, time, { y: y - height}, { transition:"Quad.easeOut" } );
			
			var endX:Tween   = new Tween(this, time, { x: x + distance },     { transition:"linear" } );
			var endY:Tween   = new Tween(this, time, { y: y  },      { transition:"Quad.easeIn" } );
			
			var xtw:Sequence = new Sequence(startX, endX);
			var ytw:Sequence = new Sequence(startY, endY);
			
			if(anim && anim.running){
				anim.dispose();
			}
			
			anim = new Parallel(xtw, ytw);
			
			anim.addEventListener(TaskEvent.COMPLETE, function(e:Event):void{
				
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				
				if (jump.mode != "hurdle") {
					dispatchEvent(new Event(Avatar.ON_LANDING));
					setIdle();
				}else{
					setRunning();
				}
				
			});	
			
			var animation:MovieClip = asset.animation;
			
			Game.taskRunner().add(anim);

		}

		
		public function get mode():int
		{
			return currentMode;
		}
		
		
		public function toggleMode():void
		{
			if(currentMode == PLAYER){
				currentMode = FOREST;
				maxSpeed = maxSpeed * 4;
				power = maxSpeed;
			}else{
				currentMode = PLAYER;
				maxSpeed = maxSpeed / 4;
			}
			 
			trace("RUN FOREST");
			
		}
		
		public function showArrowHint():void
		{
			if(mode == PLAYER){
				playerArrow.visible = true;
				setTimeout(function():void { playerArrow.visible = false}, 3000);	
			}
		}
			
		public function get target():MovieClip{
			return asset; 
		}
		
	}
	
}