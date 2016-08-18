package game.sports 
{
	import assets.*;
	
	import avatar.corredorMC;
	
	import com.qb9.flashlib.geom.Vector2D;
	import com.qb9.flashlib.input.Keys;
	import com.qb9.flashlib.lang.AssertionError;
	import com.qb9.flashlib.lang.foreach;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import game.Avatar;
	import game.Lane;
	
	import utils.Utils;
	
	public class Race extends Sport 
	{
		
		protected var finalMetres:int;		
		protected var cantEnemiesReachedEnd:int;
		protected var boredCrowdMeters:int = 200;
		
		// la carrera tiene todo esto
		protected var departure:MovieClip;
		protected var line:MovieClip;
		protected var goal:MovieClip;		
		protected var lanes:Array;	// los lanes estan para poder meter juntos corredores y vallas + la data de por donde se mueven	
		
		
		
		public function Race(currentSport:Object) 
		{
			this.currentSport = currentSport;
		}
		
		override protected function create():void
		{
			levelDefinition = new assets.racesMC();			
			createLanes();
			createPlayers();	
			super.initialize(); // disparo el evento de que ya esta listo todo 
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
					player = new Avatar();			
					player.x = lanes[lane].loc.x;
					player.y = lanes[lane].loc.y;player.setMode(Avatar.PLAYER);					
					player.setMaxSpeed(currentSport.player.maxSpeed);
					player.setSpeedIncrement(currentSport.player.speedIncrement);
					player.setMode(Avatar.PLAYER);	// lo creo en modo player
					lanes[lane].avatar = player;
				}else{
					var enemy:Avatar = new Avatar(); 
					enemy.x = lanes[lane].loc.x;
					enemy.y = lanes[lane].loc.y;
					var maxSpeed:Number = currentSport.enemies.maxSpeed * Utils.map(Math.random(), 0, 1, currentSport.enemies.speedVariation[0],currentSport.enemies.speedVariation[1]) / 100;  
					enemy.setMaxSpeed(maxSpeed);
					enemy.setSpeedIncrement(currentSport.enemies.speedIncrement);
					enemy.setMode(Avatar.ENEMY);
					lanes[lane].avatar = enemy;
				}				
				camera.addChild(lanes[lane].avatar);
			}
		}
		
		override public function start():void
		{
			for each(var lane:Lane in lanes) lane.avatar.go();
			playing = true;
			timer.go();
			super.start(); // disparo el evento de que la carrera inicio
		}
		
		override public function update():void 
		{
			if (!playing) return;
			camera.x += (playerScreenPosition - player.localToGlobal(new Point(0,0)).x);									
			bg.follow(camera.x);			
			for each(var lane:Lane in lanes) lane.avatar.update();						
			checkIfWin();
			
			if(player.getMeters() >= boredCrowdMeters) crowdGetsBored();
			
		}
		
		private function checkIfWin():void
		{
			for each(var lane:Lane in lanes) {			
				if (lane.avatar.getMeters() >= finalMetres)
				{					
					if(lane.avatar.mode == Avatar.ENEMY){
						if(! lane.avatar.isIdle()) cantEnemiesReachedEnd++;
					}else{		
						for each( lane in lanes) lane.avatar.stop();
						competitionEnds();
					}			
					lane.avatar.stop();
				}
			}			
		}
		
		private function crowdGetsBored():void
		{

			bg.setDeadBodiesChance(Utils.map(player.getMeters(), boredCrowdMeters, currentSport.metres, 0, 1.1));
		}
		
		override protected function competitionEnds():void
		{
			assignBadge();
			super.competitionEnds();
		}
		
		override protected function assignBadge():void 
		{
			if (cantEnemiesReachedEnd == 0) badge = BADGE_GOLD;
			if (cantEnemiesReachedEnd == 1) badge = BADGE_SILVER;
			if (cantEnemiesReachedEnd == 2) badge = BADGE_BRONCE;
			if (cantEnemiesReachedEnd > 2) badge = BADGE_LOOSER;			

		}
		
		override public function pause():void
		{
			playing = false;
			for each( var lane:Lane in lanes) lane.avatar.stop();
			timer.pause();
		}
		
		override public function resume():void
		{
			playing = true;
			for each( var lane:Lane in lanes) lane.avatar.go();
			timer.go();
		}
		
		
		private var easeterEgg:String = "";
		override public function onKeyDown(key:KeyboardEvent):void 
		{			
			if (!playing) return;
			if (key.keyCode == Keyboard.LEFT && ! leftKeyPressed)
			{
				leftKeyPressed = true;
				player.increasePower();
				return;
			}
			else if (key.keyCode == Keyboard.RIGHT && leftKeyPressed)
			{
				leftKeyPressed = false;
				player.increasePower();
				return;
			}
			
			easeterEgg += String.fromCharCode(key.charCode);
			// forest			
			if(easeterEgg.match("forest") && !Game.easterEggUsed){
				Game.easterEggUsed = true;
				player.toggleMode();
			}
			
		}
		
		override public function getPlayerMeters():int
		{
			return  Utils.map(player.getMeters(), 1, finalMetres, 0, finalMetres);
		}
	}
	
}