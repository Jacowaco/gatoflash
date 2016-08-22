package game.sports 
{
	import assets.*;
	
	import com.qb9.flashlib.geom.Vector2D;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import game.Avatar;
	import game.Hurdle;
	import game.Lane;
	
	import ui.GuiEvents;
	
	public class Hurdles extends Race
	{
		private var numObstacles:Number;
		private var collisionRange:Number;
		private var jumpinThreshold:Number;
		
		public function Hurdles(sportDefinition:Object) 
		{
			super(sportDefinition);			
			finalMetres = currentSport.metres;			
			numObstacles = currentSport.numObstacles;
			collisionRange =  finalMetres * UNITS_PER_METER / numObstacles / 4 * 3; // 75% de distancia entre las vallas
			jumpinThreshold =	currentSport.jumpThreshold;			
			super.create(); // crea la carrera
			createHurdles(); // y ahora le agrego las vayas.
			
		}
		
		override public function initialize():void
		{		
			dispatchEvent(new Event(GuiEvents.COUNTDOWN)); 
		}
		
		private function createHurdles():void
		{		
			numObstacles += 4; // engania pichanga para que cree la cantidad de vallas que dice el settings.json
			for each(var lane:Lane in lanes){
				for(var i:int = 2; i < numObstacles - 2; i++){ // pongo vallas a partir de la segunda
					var hurdle:Hurdle = new Hurdle(new assets.cucumber);
					hurdle.y = lane.loc.y;
					hurdle.x = lane.loc.x + (finalMetres * UNITS_PER_METER /  numObstacles * i);
					lane.hurdles.push(hurdle);		
					camera.addChildAt(hurdle, 0);
				}
			}			
		}
		
		override public function update():void
		{
			super.update();			//  actualizo la carrera
			checkColisions();       //  implementa las colisiones.
		}
		
		private function checkColisions():void 
		{
			for each(var lane:Lane in lanes){				
				if(lane.avatar.mode == Avatar.ENEMY){
					for each(var hurdle:Hurdle in lane.hurdles){
						if(!hurdle.active) continue;
						var distToObstacle:Number = hurdle.x - lane.avatar.x;	
						if(distToObstacle < collisionRange){							
							checkForJump(lane.avatar, hurdle);
							collide(lane.avatar, hurdle);
						}	
					}					
				}else{
					for each(hurdle in lane.hurdles){	
						if(!hurdle.active) continue;
						distToObstacle = hurdle.x - lane.avatar.x;					
						if(distToObstacle < collisionRange){							
							collide(lane.avatar, hurdle);
						}				
					}		
				}				
			}
		}
				
		private function checkForJump(avatar:Avatar, hurdle:Hurdle):void
		{									
			var distToObstacle:Number = Math.abs(hurdle.x - avatar.x);
			if(distToObstacle < jumpinThreshold && ! avatar.isJumping()){
				var chance:int = currentSport.enemies.jumpSkill;			
				var nounce:int = Math.random() * 100;	
				if(nounce <= chance) {
					avatar.jumpHurdle();
				}
			}			
		}
		
		private function collide(avatar:Avatar, hurdle:Hurdle):void{			 			
			var distToObstacle:Number = Math.abs(hurdle.x - avatar.x);
			if(distToObstacle < jumpinThreshold && ! avatar.isJumping()){
				hurdle.active = false;
				hurdle.collide();				
				avatar.collide();
			}
		}
		

		override public function onKeyDown(key:KeyboardEvent):void 
		{			
			if (key.keyCode == Keyboard.SPACE) player.jumpHurdle();			
			super.onKeyDown(key);			
		}
		
	}
	
}