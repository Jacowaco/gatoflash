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
	
	
	import avatar.corredorMC;
	
	public class Race extends Sport 
	{
		
		protected var finalMetres:int;		
		protected var cantEnemiesReachedEnd:int;
		
		// la carrera tiene todo esto
		protected var departure:MovieClip;
		protected var line:MovieClip;
		protected var goal:MovieClip;
		// los lanes estan para poder meter juntos corredores y vallas
		protected var lanes:Array;		
		protected var playersMaxSpeed:Number;
		protected var playersSpeedIncrement:Number;
		
		public function Race() 
		{
			
		}
		
		protected function create():void
		{
			levelDefinition = new assets.racesMC();			
			createLanes();
			createPlayers();			
		}
		
		private function createLanes():void 
		{
			departure = levelDefinition.start;
			line = levelDefinition.line
			goal = levelDefinition.goal;
			
			lanes = new Array();
			
			for(var ph:int = 0; ph < departure.numChildren; ph++)
			{
				if( departure.getChildAt(ph).name.search("carril") != -1){
					var loc:Point = departure.getChildAt(ph).localToGlobal(new Point());
					var lane:Lane = new Lane();
					lane.name = departure.getChildAt(ph).name;
					lane.loc = loc;
					lanes.push(lane);
				}				
			}
			
			goal.x = finalMetres * UNITS_PER_METER;
			
			camera.addChild(departure);
			camera.addChild(line);
			camera.addChild(goal);
		}
		
		private function createPlayers():void
		{			
			for(var lane:int = 0; lane < lanes.length; lane++){
				if(lanes[lane].name == "carrilPlayer"){ // si es el corredor...
					player = new Avatar(new avatar.corredorMC);			
					player.x = lanes[lane].loc.x;
					player.y = lanes[lane].loc.y;player.setMode(Avatar.PLAYER);					
					player.setMaxSpeed(playersMaxSpeed);
					player.setSpeedIncrement(playersSpeedIncrement);
					player.setMode(Avatar.PLAYER);	// lo creo en modo player
					lanes[lane].avatar = player;
				}else{
					var enemy:Avatar = new Avatar(new avatar.corredorMC ); 
					enemy.x = lanes[lane].loc.x;
					enemy.y = lanes[lane].loc.y;					
					enemy.setMaxSpeed(playersMaxSpeed * 0.95);
					enemy.setSpeedIncrement(playersSpeedIncrement);
					enemy.setMode(Avatar.ENEMY);
					lanes[lane].avatar = enemy;
				}				
				camera.addChild(lanes[lane].avatar);
			}
		}
		
		
		override public function start():void
		{
			for each(var lane:Lane in lanes) lane.avatar.start();
			playing = true;
			audio.fx.loop("correr");
		}
		
		override public function update():void 
		{
			if (!playing) return;
			
			camera.x += (playerScreenPosition - player.localToGlobal(new Point(0,0)).x);									
			bg.follow(camera.x);
			
			for each(var lane:Lane in lanes) lane.avatar.update();						
			checkIfWin();
		}
		
		private function checkIfWin():void
		{
			for each(var lane:Lane in lanes) {			
				if (lane.avatar.getMeters() >= finalMetres)
				{					
					if(lane.avatar.mode == Avatar.ENEMY){
						if(! lane.avatar.isIdle()) cantEnemiesReachedEnd++;
						trace("enemie "+ cantEnemiesReachedEnd + " reached end");
					}else{		
						for each( lane in lanes) lane.avatar.stop();
						win();
					}			
					lane.avatar.stop();
				}
			}			
		}
		
		
		override protected function win():void
		{
			assignBadge();
			if(badge != BADGE_LOOSER){
				audio.fx.play("bu");
			}else{
				audio.fx.play("ovacion");
			}
			super.win();
		}
		
		override protected function assignBadge():void 
		{
			if (cantEnemiesReachedEnd == 0) badge = BADGE_GOLD;
			if (cantEnemiesReachedEnd == 1) badge = BADGE_SILVER;
			if (cantEnemiesReachedEnd == 2) badge = BADGE_BRONCE;
			if (cantEnemiesReachedEnd > 2) badge = BADGE_LOOSER;
			
			trace("badge: " + badge);
		}
		
//		override public function registerSoundsToStopAtGameEnd():void 
//		{
//			sportSounds = ["bu", "ovacion", "correr"];
//		}
		
		override public function onKeyDown(key:KeyboardEvent):void 
		{			
			if (!playing) return;
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
		
		override public function getPlayerMeters():int
		{
			return  Utils.map(player.getMeters(), 1, finalMetres, 0, finalMetres);
		}
	}
	
}