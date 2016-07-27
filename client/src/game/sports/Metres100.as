package game.sports 
{
	import assets.*;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import game.Enemy;
	import game.LevelEvents;
	import game.Sport;
	import com.qb9.flashlib.geom.Vector2D;
	import gameobject.GameObject;
	import utils.Utils;
	
	
	public class Metres100 extends Sport 
	{
		protected const CANT_ENEMIES:int = 4;
		
		protected var enemies:Vector.<Enemy>;
		protected var end:GameObject;
		protected var finalMetres:int;
		protected var cantEnemiesReachedEnd:int;
		
		public function Metres100() 
		{
			super();
			
			finalMetres = 100;
		}
		
		override public function create():void 
		{
			var speedFactors:Vector.<int> = new Vector.<int>();
			for (var i:int = 0; i < CANT_ENEMIES; i++)
			{
				speedFactors[i] = i;
			}
			Utils.shuffleVector(speedFactors);
			
			enemies = new Vector.<Enemy>();
			for (i = 0; i < CANT_ENEMIES; i++)
			{
				enemies[i] = new Enemy(new assets.CorredorMC, speedFactors[i]);
			}
			
			super.create();
			
			camera.addChild(enemies[2].asset);
			camera.addChild(enemies[3].asset);
		}
		
		override protected function addThingsBeforePlayer():void 
		{
			end = new GameObject(new assets.endMC);
			end.debug(false);
			end.loc = new Vector2D(start.loc.x + finalMetres * UNITS_PER_METER, start.loc.y);
			end.run();
			camera.addChild(end.asset);
			
			camera.addChild(enemies[0].asset);
			camera.addChild(enemies[1].asset);
		}
		
		override public function reset():void 
		{
			super.reset();
			
			cantEnemiesReachedEnd = 0;
			
			enemies[0].init(new Vector2D(start.loc.x, start.loc.y - 40));
			enemies[1].init(new Vector2D(start.loc.x, start.loc.y - 20));
			enemies[2].init(new Vector2D(start.loc.x, start.loc.y + 20));
			enemies[3].init(new Vector2D(start.loc.x, start.loc.y + 40));
			for (var i:int = 0; i < CANT_ENEMIES; i++)
			{
				
				enemies[i].reset();
				enemies[i].start();
			}
			
			startPlayer();
		}
		
		protected function startPlayer():void
		{
			player.start(false);
		}
		
		override public function update():void 
		{
			if (!playing) return;
			
			super.update();
			
			checkColisions();
			
			for (var i:int = 0; i < CANT_ENEMIES; i++)
			{
				enemies[i].update();
			}
			
			speedBar.percentage = player.percentage;
			
			camera.x += ((Game.SCREEN_WIDTH / 2) - player.asset.localToGlobal(new Point(0, 0)).x);
			camera.x = Math.min(0, camera.x);
			
			meters = player.getMeters();
			hud.updateMeters(meters);
			
			if (meters >= finalMetres)
			{
				player.stop();
				win();
			}
			else 
			{
				for (i = 0; i < CANT_ENEMIES; i++)
				{
					if (enemies[i].move && enemies[i].getMeters() >= finalMetres)
					{
						enemies[i].stop();
						cantEnemiesReachedEnd++;
						if (cantEnemiesReachedEnd >= 3)
						{
							player.stop();
							lose();
						}
					}
				}
			}
		}
		
		override public function assignBadge():void 
		{
			if (cantEnemiesReachedEnd == 0) badgeObtained = BADGE_GOLD;
			if (cantEnemiesReachedEnd == 1) badgeObtained = BADGE_SILVER;
			if (cantEnemiesReachedEnd >= 2) badgeObtained = BADGE_BRONCE;
		}
		
		protected function checkColisions():void
		{
			
		}
		
		override public function onKeyDown(key:KeyboardEvent):void 
		{
			super.onKeyDown(key);
			
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
		}
	}

}