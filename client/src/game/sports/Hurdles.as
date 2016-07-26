package game.sports 
{
	import assets.*;
	import com.qb9.flashlib.geom.Vector2D;
	import flash.events.KeyboardEvent;
	import game.Hurdle;
	import gameobject.GameObject;
	
	public class Hurdles extends Metres100
	{
		private const CANT_HURDLES:int = 10;
		public static const COLISION_RANGE:int = 60;
		private var hurdles:Vector.<Vector.<Hurdle>>;
		
		public function Hurdles() 
		{
			super();
			
			finalMetres = 110;
		}
		
		override public function create():void 
		{
			super.create();
			
			for (var i:int = 0; i < CANT_ENEMIES; i++)
			{
				enemies[i].baseAccel += 0.25;
			}
			
			player.setJumpVariables(120, 0, 300, false, true);
		}
		
		override protected function addThingsBeforePlayer():void 
		{
			hurdles = new Vector.<Vector.<Hurdle>>();
			for (var e:int = 0; e < CANT_ENEMIES + 1; e++)
			{
				hurdles[e] = new Vector.<Hurdle>();
				for (var i:int = 0; i < CANT_HURDLES; i++)
				{
					hurdles[e][i] = new Hurdle(new assets.hurdleMC);
					camera.addChild(hurdles[e][i].asset);
				}
			}
			
			super.addThingsBeforePlayer();
		}
		
		override public function reset():void 
		{
			super.reset();
			
			for (var e:int = 0; e < CANT_ENEMIES + 1; e++)
			{
				for (var i:int = 0; i < CANT_HURDLES; i++)
				{
					if (e == CANT_ENEMIES)
						hurdles[e][i].init(start.loc.x + 2000 + i * 900, player.loc.y);
					else
						hurdles[e][i].init(start.loc.x + 2000 + i * 900, enemies[e].loc.y);
					hurdles[e][i].run();
				}
			}
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
			player.jump(1, 0);
		}
		
	}

}