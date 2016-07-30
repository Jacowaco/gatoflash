package game.sports 
{
	import assets.*;
	
	import com.qb9.flashlib.geom.Vector2D;
	import com.qb9.flashlib.lang.AssertionError;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import game.Enemy;
	import game.LevelEvents;
	import game.MovingObject;
	import game.Player;
	
	import mx.core.mx_internal;
	
	import utils.Utils;
	
	
	public class Race extends Sport 
	{
		protected const CANT_ENEMIES:int = 4;
		protected var enemies:Array;
		
		protected var finalMetres:int;
		
		protected var cantEnemiesReachedEnd:int;
		protected var end:MovingObject;
		
		public function Race() 
		{
			super();
			finalMetres = 100;			
			addGoalLine();
			createPlayerAndEnemies();
			reset();
			
			
		}
		
		public function createPlayerAndEnemies():void 
		{

			enemies = new Array();
			
			for (var i:int = 0; i < CANT_ENEMIES; i++)
			{
				enemies[i] = new Enemy(new assets.CorredorMC, settings.sports.minEnemySpeed + Math.random() * settings.sports.maxEnemySpeed );
			}
			
			
			camera.addChild(enemies[0].asset);
			camera.addChild(enemies[1].asset);
			
			player = new Player(new assets.CorredorMC);
			camera.addChild(player.asset);
			
			camera.addChild(enemies[2].asset);
			camera.addChild(enemies[3].asset);
		}
		
		protected function addGoalLine():void 
		{
			end = new MovingObject(new assets.endMC());			
			end.init(new Vector2D(start.loc.x + finalMetres * UNITS_PER_METER, start.loc.y));
			camera.addChild(end.asset);
		}
		
		override public function reset():void 
		{
			super.reset();
			
			cantEnemiesReachedEnd = 0;
			
			enemies[0].init(new Vector2D(start.asset.carril1.x, start.asset.carril1.y));
			enemies[1].init(new Vector2D(start.asset.carril2.x, start.asset.carril2.y));
			enemies[2].init(new Vector2D(start.asset.carril4.x, start.asset.carril4.y));
			enemies[3].init(new Vector2D(start.asset.carril5.x, start.asset.carril5.y));
			
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
			
//			speedBar.percentage = player.percentage;
			
			camera.x += ((Game.SCREEN_WIDTH / 2) - player.asset.localToGlobal(new Point(0, 0)).x);
			camera.x = Math.min(0, camera.x);
			
			meters = player.getMeters();
//			hud.updateMeters(meters);
			
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