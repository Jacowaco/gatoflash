package game.sports 
{
	import assets.*;
	
	import com.qb9.flashlib.geom.Vector2D;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import game.Avatar;
	import game.Hurdle;
	import game.Lane;

	public class Hurdles extends Race
	{
		private const CANT_HURDLES:int = 10;
		public static const COLISION_RANGE:int = 60;
//		private var hurdles:Array;
		
		public function Hurdles() 
		{
			currentSport = "sport0"; // esto es lo único que debería hardcodear...
			finalMetres = settings.sports[currentSport].metres;			
			super.create();
			createHurdles();
			// TODO aca seguro va a haber que poner una cuenta regresiva
			start();
		}
		
		private function createHurdles():void
		{
//			hurdles = new Array();
			
			for each(var lane:Lane in lanes){
				for(var i:int = 2; i < settings.sports[currentSport].numObstacles; i++){ // pongo vallas a partir de la segunda
					var hurdle:Hurdle = new Hurdle(new assets.hurdleMC);
					hurdle.y = lane.loc.y;
					hurdle.x = lane.loc.x + (finalMetres * UNITS_PER_METER /  settings.sports[currentSport].numObstacles * i);
					lane.hurdles.push(hurdle);		
					camera.addChildAt(hurdle, 0);
				}
			}
			
//				for(var player:int = 0; player < players.length; player++){
//				
//					
//					hurdle.setCurrentLane(players[player].lane);
//					
//				}
//			}
		}
		
		override protected function checkColisions():void 
		{
			
			for each(var lane:Lane in lanes){
				for each(var hurdle:Hurdle in lane.hurdles){
					if(!hurdle.active) continue;
					if(lane.avatar.mode == Avatar.ENEMY){
						checkForJump(lane.avatar, hurdle);
						collide(lane.avatar, hurdle);
					}else{
						collide(lane.avatar, hurdle);
					}	
				}
			}
		}
		
		override public function update():void
		{
			super.update();
			checkColisions();
		}
		
		private var jumpinThreshold:Number = 100;
		private function checkForJump(avatar:Avatar, hurdle:Hurdle):void
		{			
			if(hurdle.x - avatar.x < jumpinThreshold){
				hurdle.active = false;
				var chance:int = 10;			
				var nuance:int = Math.random() * 1000;	
				if(nuance < chance) avatar.jump();
			}			
		}
		
		private function collide(players:Avatar, hurdle:Hurdle):void{
			if(player.hitTestObject(hurdle)){
				hurdle.collide();
				hurdle.active = false;
				player.collideHurdle();
			}
		}
		
		
		override public function onKeyUp(key:KeyboardEvent):void
		{
			
		}
		
		override public function onKeyDown(key:KeyboardEvent):void 
		{
			if (key.keyCode == Keyboard.LEFT && !leftKeyPressed)
			{
				leftKeyPressed = true;
				player.accelerate();
			}
			else if (key.keyCode == Keyboard.RIGHT && leftKeyPressed)
			{
				leftKeyPressed = false;
				player.accelerate();
			}
			else if (key.keyCode == Keyboard.SPACE)
			{
				player.jump();
			}
			
		}
		
	}

}