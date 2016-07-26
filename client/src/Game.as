package
{
	import assets.*;
	
	import com.qb9.flashlib.audio.AudioManager;
	import com.qb9.flashlib.audio.PlayableFactory;
	import com.qb9.flashlib.color.Color;
	import com.qb9.flashlib.config.*;
	import com.qb9.flashlib.easing.Tween;
	import com.qb9.flashlib.events.QEvent;
	import com.qb9.flashlib.events.QEventDispatcher;
	import com.qb9.flashlib.input.Keys;
	import com.qb9.flashlib.lang.AbstractMethodError;
	import com.qb9.flashlib.logs.ConsoleAppender;
	import com.qb9.flashlib.logs.Logger;
	import com.qb9.flashlib.math.Random;
	import com.qb9.flashlib.net.*;
	import com.qb9.flashlib.screens.Screen;
	import com.qb9.flashlib.screens.ScreenManager;
	import com.qb9.flashlib.security.SafeNumber;
	import com.qb9.flashlib.tasks.*;
	import com.qb9.flashlib.utils.ObjectUtil;
	
	import flash.debugger.enterDebugger;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.sampler.NewObjectSample;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	import game.LevelController;
	import game.LevelEvents;
	
	import popups.*;
	import popups.ConfirmationPopup;
	
	import ui.Gui;
	import ui.GuiEvents;
	
	import utils.Stopwatch;
	import utils.Utils;

	
	
	[SWF(width='800', height='480', backgroundColor='0xF9D611', frameRate='25')]
	public class Game extends BaseGame
	{		
		// para interactuar con la bd del MMO
		public static const GAME_ID:String = "eggDecoration";
		public static const GAME_DATA:String = GAME_ID + "_data";			
		public static const version:String = "version 0.1";
		
		public static const SCREEN_WIDTH:int = 800;
		public static const SCREEN_HEIGHT:int = 480;
		
		//variable que contabiliza los huevos recibidos.
		public static const PROFILE_ATTR_KEY_COUNT:String = "schoolYogurDay/easter16/count";
		//variable que guarda la info del huevo a entregar.
		public static const PROFILE_ATTR_KEY_EGG:String = "winToday";
		
		// si estoy online carga el settings.json incrustado, sino lo levanta del disco para que el 
		// gd lo pueda editar.
		[Embed(source = './../deploy/settings.json', mimeType='application/octet-stream')]
		private static const settingsFile:Class;		
		
		private static var tasks:TaskRunner;		
		
		private var level:game.LevelController;
		private var gui:Gui;
		
		private var round:int;
		
		private var maxRound:int;
		private var goal:String;
		private var difficulty:int;
		
		private var winner:Boolean;
		private var isLastRound:Boolean = false;
		private var currentEgg:int = 0;
		
		// blabla... x2
		
		public function Game()
		{
			super();
			logger.info("game started");						
			
			if (stage)
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.BOTTOM;
			}
		}
		
		// MANDATORY (obligatorio no borrar)
		// esto lo llama basegame cuando le pide el MMO
		override protected function whenReady():void
		{						
			tasks = new TaskRunner(this);
			tasks.start();
			
			if(online){
				// si estoy online uso el setting incrustado
				trace("loading embed settings");
				var f:String = new settingsFile;
				settings.feed(f);
				settingsLoaded();
			}else{
				// sino cargo los settings desde el disco y no sigo hasta tenerlos listo
				trace("loading file settings");				
				var settingsLoader:LoadFile = new LoadFile(makeAbsoluteURL("settings.json"));
				settings.addFile(settingsLoader);			
				tasks.add(new Sequence(
					settingsLoader,
					new Func(settingsLoaded)));
			}
		}			
		
		private function settingsLoaded():void
		{									
			createLevel();
			createGui();
			loadAudio();
			
			stage.addEventListener(Event.ENTER_FRAME, update);
			
			ready();
			
		}		
		
		private function createLevel():void
		{
			// primero que nada...
			//if (online) {
				//currentEgg = api.getProfileAttribute(PROFILE_ATTR_KEY_COUNT) ? api.getProfileAttribute(PROFILE_ATTR_KEY_COUNT) as int : 0;
			//}
			
			level = new game.LevelController();				
			addChild(level);
			maxRound = settings.levels.days[currentEgg].rounds;
			goal = settings.levels.days[currentEgg ].goal;
			difficulty = settings.levels.days[currentEgg].difficulty;
			
			
			round = 0;						
			winner = false;
			
			
		}
		
		
		private function createGui():void
		{
			// gui
			gui = new Gui(new assets.guiMc());
			gui.addEventListener(GuiEvents.EXIT, onPause);
			gui.addEventListener(GuiEvents.CONFIRMATION_EXIT, onExitGame);
			gui.addEventListener(GuiEvents.RESUME, onResume);
			gui.addEventListener(GuiEvents.PLAY, onPlay);
			addChild(gui);						
		}
		
		
		private function loadAudio():void
		{
			audio = new AudioManager(new PlayableFactory(makeAbsoluteURL("sfx/"),"mp3"));			
			logger.info("registering audio");
			
			audio.registerMusic("inicio", "music_intro");
			audio.registerFx("bonus", "bonus");
			audio.registerFx("bInstruc", "bInstruc");
			
			
			//						audio.registerFx("ganar", "ganar");
			
			audio.registerFx("reward", "reward");
			audio.registerFx("click", "click");
			
						audio.registerFx("move", "correPieza");
						audio.registerFx("fix", "encajaPieza");
			//			audio.registerFx("gameover", "gameover");
			//			audio.registerFx("infraccion", "infraccion");
			//			audio.registerFx("mSatisfactorio", "mSatisfactorio");
			//			audio.registerFx("obstaculo", "obstaculo");
			//			audio.registerFx("powerup", "powerup");
			//			audio.registerFx("puntoMuerto", "puntoMuerto");
			//			audio.registerFx("puntos", "puntos");
			//			audio.registerFx("recuento", "recuento");
			//			audio.registerFx("satisfactorio", "satisfactorio");
			
			audio.registerFx("jump", "jump");
			audio.registerFx("lose", "perder");
			audio.registerFx("win", "ganar");
			audio.registerFx("rollover", "rollover");
			
			//			
			//			audio.registerMusic("music_intro", "music_intro");
			
			//						audio.registerMusic("musica", "AmbienteNavidad");
			
			//if(!settings.default.soundsEnable){
				//audio.gain(null, 0.001);
			//}
			
			
			audio.music.loop("inicio");
		}
		
		private function update(e:Event):void
		{
			gui.setTime(level.time);
			gui.setScore(level.score.toString());
		}
		// -----------------------------------
		private function onPause(e:Event):void
		{
			level.pause();		
		}
		
		private function onResume(e:Event):void
		{
			setTimeout(level.resume, 100);			
		}
		
		private var rabbit:MovieClip = new popups.rabbit;
		// -----------------------------------		
		private function onLevelWin(e:Event):void
		{
			logger.info("level win");
			audio.fx.play("win");
			level.pause();
			//round++;
			
			//if(round < maxRound){
				//var levelScore:Number = level.score;
				//var levelBonus:Number = level.bonus * settings.scoring.bonus;						
				//addSessionScore(levelScore+levelBonus);			
//				gui.showWinScreen(EndGamePopup.WIN, levelScore, levelBonus, maxSessionScore.value, false);				
//				gui.showNext();
				gui.showWinner(rabbit, false, false);
			//}else{
				//winner = true;
				//gameWon();	
			//}
						
		}
		
		
		//private function gameWon():void
		//{
			//level.removeEventListener(LevelEvents.LEVEL_WIN, onLevelWin);
			//level.removeEventListener(LevelEvents.LEVEL_LOST, onLevelLose);
			//
			//gui.showWinner(miniature, true, currentEgg == 9);  // llego al ultimo huevo 
			
		//}
		
		
		private function onLevelLose(e:Event):void
		{						
			logger.info("level lose");
			level.pause();
			//var levelScore:Number = level.score;			
			//var levelBonus:Number = level.bonus * 0;
			
			//addSessionScore(levelScore+levelBonus);
			
			//gui.showWinScreen(EndGamePopup.LOSE, levelScore, levelBonus, maxSessionScore.value, false);
			gui.showWinner(rabbit, false, false);
			audio.fx.play("lose");
			//level.removeEventListener(LevelEvents.LEVEL_WIN, onLevelWin);
			//level.removeEventListener(LevelEvents.LEVEL_LOST, onLevelLose);
		}
		
		
		// -----------------------------------
		private function onPlay(e:Event):void
		{
			level.addEventListener(LevelEvents.LEVEL_WIN, onLevelWin);
			level.addEventListener(LevelEvents.LEVEL_LOST, onLevelLose);					
			
			gui.reset();
			level.startLevel(goal, difficulty, (round == maxRound - 1));
			stage.focus = level;
		}
		
		// -----------------------------------
		private function onExitGame(e:Event=null):void
		{
			level.pause();
			audio.fx.play("click");
			logger.info("scoring: ", maxSessionScore.value);
			if(online){
				var key:String = "huevo" + currentEgg.toString();
				api.setProfileAttribute(PROFILE_ATTR_KEY_EGG + "/eggName", settings.huevos[currentEgg].eggName);
				logger.info(settings.huevos[currentEgg].eggDescription);
				api.setProfileAttribute(PROFILE_ATTR_KEY_EGG + "/eggDescription", settings.huevos[currentEgg].eggDescription);
				api.setProfileAttribute(PROFILE_ATTR_KEY_EGG + "/eggNumber", settings.huevos[currentEgg].eggNumber);
				api.setProfileAttribute(PROFILE_ATTR_KEY_EGG + "/premio", true);
			}
			close(maxSessionScore.value);
			
		}
		
		
		
		
		// eliminar bien el juego.
		// dispose() se llama en baseGame
		override public function dispose():void
		{
			audio.music.stop();
			stage.removeEventListener(Event.ENTER_FRAME, update);
			removeChild(level); level = null;			
			removeChild(gui); gui = null;			
		}
		
		// -----------------------------------
		public static function taskRunner():TaskRunner
		{
			return tasks;			
		}
		
	}
}

