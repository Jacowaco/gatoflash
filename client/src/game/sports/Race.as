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
//	import game.MovingObject;
	import game.Player;
	
	import mx.core.mx_internal;
	
	import utils.Utils;
	
	
	public class Race extends Sport 
	{
		
		protected var finalMetres:int;
		
		protected var cantEnemiesReachedEnd:int;
		
		protected var start:MovieClip;
		protected var line:MovieClip;
		protected var goal:MovieClip;
		
		
		public function Race() 
		{

		}
		
		protected function create():void
		{
			levelDefinition = new assets.racesMC();			
			createLane();
			createEnemies();
			createPlayer();			
			addPlayerAndEnemies();
			reset();
			
		}
		
		private function createLane():void 
		{
			start = levelDefinition.start;
			line = levelDefinition.line
			goal = levelDefinition.goal;			
			camera.addChild(start);
			camera.addChild(line);
			camera.addChild(goal);
		}
		
		private function createEnemies():void
		{			
			enemies = new Array();		
			for(var i:int = 0; i < CANT_ENEMIES; i++){
				var enemy:Enemy = new Enemy(new assets.CorredorMC, settings.sports[currentSport].minEnemySpeed + Math.random() * settings.sports[currentSport].maxEnemySpeed );
				var stageLocation:Point = start.localToGlobal(new Point(start["carril"+i].x , start["carril"+i].y));
				enemy.x =stageLocation.x;
				enemy.y = stageLocation.y;
				
//				enemy.initLoc(stageLocation.x, stageLocation.y);
//				enemy.reset(); // para que setee la posicion actual a la inicial...
				enemies.push(enemy);				
			}
		}
		
		private function createPlayer():void
		{
			player = new Player(new assets.CorredorMC);
			var stageLocation:Point = start.localToGlobal(new Point(start["carrilPlayer"].x , start["carrilPlayer"].y));			
			player.x = stageLocation.x;
			player.y = stageLocation.y;
//			player.reset();
		}
		
		private function addPlayerAndEnemies():void 
		{
			camera.addChild(enemies[0]);
			camera.addChild(enemies[1]);
			camera.addChild(player);			
			camera.addChild(enemies[2]);
			camera.addChild(enemies[3]);
		}
		

		
		private function reset():void 
		{
			playing = true;

			cantEnemiesReachedEnd = 0;
			
			for (var i:int = 0; i < CANT_ENEMIES; i++)
			{

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
			player.update();
						
//			bg.follow(player);
			
			
			for (var i:int = 0; i < CANT_ENEMIES; i++)
			{
				enemies[i].update();
			}
			
//			speedBar.percentage = player.percentage;
			
			camera.x += ((Game.SCREEN_WIDTH / 2) - player.localToGlobal(new Point(0, 0)).x);
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
			if (cantEnemiesReachedEnd == 0) badge = BADGE_GOLD;
			if (cantEnemiesReachedEnd == 1) badge = BADGE_SILVER;
			if (cantEnemiesReachedEnd >= 2) badge = BADGE_BRONCE;
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