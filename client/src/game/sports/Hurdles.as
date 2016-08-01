package game.sports 
{
	import assets.*;
	
	import com.qb9.flashlib.geom.Vector2D;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import game.Hurdle;

	public class Hurdles extends Race
	{
		private const CANT_HURDLES:int = 10;
		public static const COLISION_RANGE:int = 60;
		private var hurdles:Array;
		
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
			for(var i:int = 2; i < settings.sports[currentSport].numObstacles; i++){ // pongo vallas a partir de la segunda
				for(var lane:int = 0; lane < lanes.length; lane++){
					var hurdle:Hurdle = new Hurdle(new assets.hurdleMC);
					camera.addChild(hurdle);
					hurdle.y = lanes[lane].y;
					hurdle.x = lanes[lane].x + (finalMetres * UNITS_PER_METER /  settings.sports[currentSport].numObstacles * i);
				}
			}
		}
		
		override protected function checkColisions():void 
		{
			for(var lane:int = 0; lane < lanes.length; lane++){
				
			}
			
			
			for (var e:int = 0; e < CANT_ENEMIES + 1; e++)
			{
				for (var i:int = 0; i < CANT_HURDLES; i++)
				{
					if (e == CANT_ENEMIES)
					{
						if (false) // (!hurdles[e][i].collided && player.loc.distance(hurdles[e][i].loc) < COLISION_RANGE)
						{
							//trace("colliding player");
							hurdles[e][i].collide();
							player.collideHurdle();
						}
					}
					else
					{
						var enemyDistToHurdle:Number = hurdles[e][i].loc.x - enemies[e].loc.x;
						if (!hurdles[e][i].collided && enemyDistToHurdle >= 0 && enemyDistToHurdle < enemies[e].nextJumpDist)
						{
							//trace("enemy jumping");
							enemies[e].jump(1, 0);
						}
						if (!hurdles[e][i].collided && enemies[e].loc.distance(hurdles[e][i].loc) < COLISION_RANGE)
						{
							hurdles[e][i].collide();
							enemies[e].collideHurdle();
						}
					}
				}
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