package game.sports 
{
	import assets.*;
	
	import com.qb9.flashlib.geom.Vector2D;
	import com.qb9.flashlib.lang.AssertionError;
	import com.qb9.flashlib.lang.foreach;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import game.Enemy;
	import game.LevelEvents;
	import game.Player;
	
	import utils.Utils;
	
	
	public class Race extends Sport 
	{
		
		protected var finalMetres:int;
		
		protected var cantEnemiesReachedEnd:int;

		// la carrera tiene todo esto
		protected var departure:MovieClip;
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
			
		}
		
		private function createLane():void 
		{
			departure = levelDefinition.start;
			line = levelDefinition.line
			goal = levelDefinition.goal;			
			camera.addChild(departure);
			camera.addChild(line);
			camera.addChild(goal);
		}
		
		private function createEnemies():void
		{			
			enemies = new Array();		
			for(var i:int = 0; i < CANT_ENEMIES; i++){
				var enemy:Enemy = new Enemy(new assets.CorredorMC, settings.sports[currentSport].minEnemySpeed + Math.random() * settings.sports[currentSport].maxEnemySpeed );
				var stageLocation:Point = departure.localToGlobal(new Point(departure["carril"+i].x , departure["carril"+i].y));
				enemy.x = stageLocation.x;
				enemy.y = stageLocation.y;
				enemies.push(enemy);				
			}
		}
		
		private function createPlayer():void
		{
			player = new Player(new assets.CorredorMC);
			var stageLocation:Point = departure.localToGlobal(new Point(departure["carrilPlayer"].x , departure["carrilPlayer"].y));			
			player.x = stageLocation.x;
			player.y = stageLocation.y;
		}
		
		private function addPlayerAndEnemies():void 
		{
			camera.addChild(enemies[0]);
			camera.addChild(enemies[1]);
			camera.addChild(player);			
			camera.addChild(enemies[2]);
			camera.addChild(enemies[3]);
		}
				
		
		protected function start():void
		{
			for each(var enemie:Enemy in enemies) enemie.start();
			player.setRunning();
			playing = true;
			trace("race started");
		}
		
		
		override public function update():void 
		{
			if (!playing) return;
		
//			camera.x = Utils.ease(camera.x + ((Game.SCREEN_WIDTH / 2) - player.localToGlobal(new Point(0,0)).x), camera.x, 0.95);
			camera.x += ((Game.SCREEN_WIDTH / 4) - player.localToGlobal(new Point(0,0)).x);
//			camera.x = Math.min(0, camera.x);

			player.update();						
			bg.follow(camera.x);
			
			
			for (var i:int = 0; i < CANT_ENEMIES; i++)
			{
				enemies[i].update();
			}
			
//			speedBar.percentage = player.percentage;
			
			
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
			if (key.keyCode == Keyboard.LEFT && ! leftKeyPressed)
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