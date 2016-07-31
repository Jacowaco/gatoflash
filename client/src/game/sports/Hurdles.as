package game.sports 
{
	import assets.*;
	import com.qb9.flashlib.geom.Vector2D;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import game.Hurdle;

	public class Hurdles extends Race
	{
		private const CANT_HURDLES:int = 10;
		public static const COLISION_RANGE:int = 60;
		private var hurdles:Array;
		
		public function Hurdles() 
		{
			super();
			currentSport = "sport0"; // esto es lo único que debería hardcodear...
			finalMetres = settings.sports[currentSport].metres;			
			super.create();
			
		}

		override public function update():void
		{
//			checkColisions();
			super.update();
		}
		
		override protected function startPlayer():void 
		{
			player.start(true);
		}
		
		override protected function checkColisions():void 
		{
			for (var e:int = 0; e < CANT_ENEMIES + 1; e++)
			{
				for (var i:int = 0; i < CANT_HURDLES; i++)
				{
					if (e == CANT_ENEMIES)
					{
						if (!hurdles[e][i].collided && player.loc.distance(hurdles[e][i].loc) < COLISION_RANGE)
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
							//trace("colliding enemy");
							hurdles[e][i].collide();
							enemies[e].collideHurdle();
						}
					}
				}
			}
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
				player.jump(1, 0);
			}
			
		}
		
	}

}