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
	
	import game.LevelEvents;
	import game.Sport;
	import game.sports.*;
	
	import popups.*;
	import popups.ConfirmationPopup;
	
	import ui.Gui;
	import ui.GuiEvents;
	
	import utils.Stopwatch;
	import utils.Utils;
	import flash.utils.getDefinitionByName;
	
	[SWF(width='800', height='480', backgroundColor='0xF9D611', frameRate='25')]
	public class Game extends BaseGame
	{		
		// para interactuar con la bd del MMO
		public static const GAME_ID:String = "olimpiadasGatulimpicas";
		public static const GAME_DATA:String = GAME_ID + "_data";			
		public static const version:String = "version 0.1";
		
		public static const SCREEN_WIDTH:int = 800;
		public static const SCREEN_HEIGHT:int = 480;
		
		public static const PROFILE_ATTR_KEY_TEAM:String = "defaultTeam";
		public static const PROFILE_ATTR_KEY_REWARD:String = "none";
		
		// si estoy online carga el settings.json incrustado, sino lo levanta del disco para que el 
		// gd lo pueda editar.
		[Embed(source = './../deploy/settings.json', mimeType='application/octet-stream')]		
		
		private static const settingsFile:Class;						
		private static var tasks:TaskRunner;				
		private var gui:Gui;		
		private var currentSport:Sport;
	
		
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
			loadAudio();
			createGui();
			stage.addEventListener(Event.ENTER_FRAME, update);
			ready();
		}		
		
		private function createGui():void
		{
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
			

			
			
			audio.music.loop("inicio");
			
			if(!settings.defaultValue.soundsEnable){
				audio.gain(null, 0.001);
			}
		}

		private function createLevel():void
		{
			
		}
				
		private function update(e:Event):void
		{
			gui.setTime("0");
			gui.setScore("0");
			
			if (currentSport) currentSport.update();
		}
		
		// -----------------------------------
		private function onPause(e:Event):void
		{
		
		}
		
		private function onResume(e:Event):void
		{

		}
		
		private function onSportWin(e:Event):void
		{
			logger.info("level win");
			audio.fx.play("win");
				
		}		
		
		private function onSportLose(e:Event):void
		{						
			logger.info("level lose");
			audio.fx.play("lose");
		}
		
		private function onPlay(e:Event):void
		{
			trace("crear el level con ese juego: " + gui.currentSport);
			
			Metres100;
			LongJump;
			ShotPut;
			HighJump;
			Hurdles;
			DiscusThrow;
			Metres400;
			Metres1500;
			PoleVault;
			JavelinThrow;
			
			var _sportClass:Class = getDefinitionByName("game.sports." + gui.currentSport) as Class;
			currentSport = new _sportClass();
			
			createSport();
			currentSport.reset();
			stage.focus = this;
		}
		
		private function createSport():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			currentSport.addEventListener(LevelEvents.LEVEL_LOST, onSportLose);
			currentSport.addEventListener(LevelEvents.LEVEL_WIN, onSportWin);
			currentSport.create();
			addChild(currentSport);
		}
		
		private function onKeyDown(key:KeyboardEvent):void
		{
			if (currentSport) currentSport.onKeyDown(key);
		}
		
		private function onKeyUp(key:KeyboardEvent):void
		{
			if (currentSport) currentSport.onKeyUp(key);
		}
		
		private function onExitGame(e:Event=null):void
		{
			audio.fx.play("click");
			logger.info("scoring: ", maxSessionScore.value);			
			if(online){
				// medallas ganadas a los teams		
			}
			// TODO
			// close(maxSessionScore.value);
			close(0);
		}
		
		// eliminar bien el juego.
		// dispose() se llama en baseGame
		override public function dispose():void
		{
			audio.music.stop();
			stage.removeEventListener(Event.ENTER_FRAME, update);
//			removeChild(level); level = null;			
			removeChild(gui); gui = null;			
		}

		public static function taskRunner():TaskRunner
		{
			return tasks;			
		}
		
	}
}

