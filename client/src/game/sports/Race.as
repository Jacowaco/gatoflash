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
	
	import game.Avatar;
	import game.Lane;
	import game.LevelEvents;
	
	import utils.Utils;
	
	
	public class Race extends Sport 
	{
		
		protected var finalMetres:int;
		
		protected var cantEnemiesReachedEnd:int;
		
		
		// la carrera tiene todo esto
//		protected var players:Array; 			// son todas las instancias de avatar. (mas facil chequear las colisiones)
		protected var departure:MovieClip;
		protected var line:MovieClip;
		protected var goal:MovieClip;
		protected var lanes:Array;
		
		public function Race() 
		{

		}
		
		
		protected function create():void
		{
			levelDefinition = new assets.racesMC();			
			createLane();
			createEnemies();
//			createPlayer();			
//			addPlayerAndEnemies();
			
		}
		
		private function createLane():void 
		{
			departure = levelDefinition.start;
			line = levelDefinition.line
			goal = levelDefinition.goal;
			
			lanes = new Array();
			
			for(var ph:int = 0; ph < departure.numChildren; ph++)
			{
				if( departure.getChildAt(ph).name.search("carril") != -1){
					var loc:Point = departure.getChildAt(ph).localToGlobal(new Point());
//					var stageLocation:Point = departure.localToGlobal(new Point(departure["carril"+i].x , departure["carril"+i].y));
					var lane:Lane = new Lane();
					lane.name = departure.getChildAt(ph).name;
					lane.loc = loc;
					lanes.push(lane);
				}
				
			}
			
			
			camera.addChild(departure);
			camera.addChild(line);
			camera.addChild(goal);
		}
		
		private function createEnemies():void
		{			
//			players = new Array();		
			
			for(var lane:int = 0; lane < lanes.length; lane++){
				if(lanes[lane].name == "carrilPlayer"){
					player = new Avatar(new assets.CorredorMC);			
					player.x = lanes[lane].loc.x;
					player.y = lanes[lane].loc.y;player.setMode(Avatar.PLAYER);
					player.setMode(Avatar.PLAYER);
					lanes[lane].avatar = player;
				}else{
					var enemy:Avatar = new Avatar(new assets.CorredorMC ); 
					enemy.x = lanes[lane].loc.x;
					enemy.y = lanes[lane].loc.y;
					enemy.setMode(Avatar.ENEMY);
					lanes[lane].avatar = enemy;
				}
				
				camera.addChild(lanes[lane].avatar);
				
//				enemy.setCurrentLane("carril"+i);	
			}
		}
		
//		private function createPlayer():void
//		{
//			player = new Avatar(new assets.CorredorMC);
//			var stageLocation:Point = departure.localToGlobal(new Point(departure["carrilPlayer"].x , departure["carrilPlayer"].y));			
//			player.x = stageLocation.x;
//			player.y = stageLocation.y;
//			player.setMode(Avatar.PLAYER);
//			player.setCurrentLane("carrilPlayer");
//			
//		}
//		
//		private function addPlayerAndEnemies():void 
//		{
//			for
//			
//			camera.addChild(players[1]);
//			camera.addChild(player);			
//			camera.addChild(players[2]);
//			camera.addChild(players[3]);
//		}
				
		
		
		protected function start():void
		{
			for each(var lane:Lane in lanes) lane.avatar.setRunning();
//			player.setRunning();
			playing = true;
			trace("race started");
		}
		
		
		
		override public function update():void 
		{
			if (!playing) return;
		
			camera.x += ((Game.SCREEN_WIDTH / 4) - player.localToGlobal(new Point(0,0)).x);
//			camera.x = Math.min(0, camera.x);

									
			bg.follow(camera.x);
			
			for each(var lane:Lane in lanes) lane.avatar.update();
//			player.update();
//			for (var i:int = 0; i < CANT_ENEMIES; i++)
//			{
//				players[i].update();
//			}
			
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
//				for (i = 0; i < CANT_ENEMIES; i++)
//				{
//					if (players[i].getMeters() >= finalMetres)
//					{
//						players[i].stop();
//						cantEnemiesReachedEnd++;
//						if (cantEnemiesReachedEnd >= 3)
//						{
//							player.stop();
//							lose();
//						}
//					}
//				}
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