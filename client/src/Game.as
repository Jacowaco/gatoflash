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
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	import game.sports.*;
	import game.sports.Sport;
	
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
		//esto es importante: en Game.as conviven una gui y un juego particular
		// es una implementación de MVC donde el modelo es el juego en sí (que a su vez tiene su propio define su propio MVC)
		// la gui es la vista (que en general maneja todos los popups y data en pantalla - excepto que un juego requiera una interfase especial)		
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
			playAudioScheme("menu");
			stage.addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);			
			// ready() le avisa al mmo que ya estoy para jugar (ie. dispatchEvent(MinigameEvent.READY));
			ready();
		}		
		
		private function createGui():void
		{
			gui = new Gui(new assets.guiMc());
			gui.addEventListener(GuiEvents.CONFIRMATION_EXIT, onExitGame);
			gui.addEventListener(GuiEvents.PAUSE, onPause);			
			gui.addEventListener(GuiEvents.RESUME, onResume);
			gui.addEventListener(GuiEvents.NEW_MATCH, onNewMatch);
			gui.addEventListener(GuiEvents.COUNTDOWN_END, onCountDownEnded);
			gui.addEventListener(GuiEvents.SHOW_MENU, onChangeGui);
		
			// INTERFASE con el api de clubes
			// levanto el nombre del club
			gui.setClub( api.getOlympicTeam() );
			addChild(gui);						
		}
		
		// sound schemes: invento para poder tener estados de musica...
		private var currentScheme:String;		
		private var soundScheme:Object = {
			"menu": ["music_rio"],
			"ingame": ["estadio"],
			"end": ["end_music"]
		}			
		
		public function playAudioScheme(name:String):void{			
			if(name == currentScheme) return;
			audio.music.stop();			
			currentScheme = name;
			var audios:Array = soundScheme[name];			
			for each(var s:String in audios) audio.music.loop(s);			
		}
		
		private function onChangeGui(e:Event):void
		{
			if(e.type == GuiEvents.SHOW_MENU) playAudioScheme("menu");
			if(e.type == GuiEvents.INGAME) playAudioScheme("ingame");
		}
		
		private function loadAudio():void
		{
			audio = new AudioManager(new PlayableFactory(makeAbsoluteURL("sfx/"),"mp3"));			
			logger.info("registering audio manager");			
			// usados en la gui	
			audio.registerFx("bInstruc", "bInstruc");
			audio.registerFx("click", "click");			
			audio.registerFx("rollover", "rollover");			
			audio.registerFx("move", "correPieza");
			audio.registerFx("reward", "reward");
			audio.registerFx("fix", "encajaPieza");
			audio.registerFx("tiempo_fuera", "tiempo_fuera");
			
			

			// end game
			audio.registerFx("lose", "perder");			
			audio.registerFx("bu", "bu");
			
			audio.registerFx("win", "win");
			audio.registerFx("ovacion", "ovacion");
					
			
			// in game
			audio.registerFx("ow", "ow");
			audio.registerFx("correr", "correr");
			audio.registerFx("saltoCorto", "saltoCorto");			
			audio.registerFx("valla", "valla");
			audio.registerFx("lanza", "lanza");
			audio.registerFx("atajaPizza", "atajaPizza");
			// musicas
			audio.registerMusic("music_rio", "music_rio");
			audio.registerMusic("estadio", "estadio");
			audio.registerMusic("end_music", "musica");
	
			trace(settings.defaultValue.soundsEnable)
			if(!settings.defaultValue.soundsEnable){
				audio.gain(null, 0.001);
			}
		}
				
		
		private function update(e:Event):void
		{
			// MVC
			if (currentSport) {
				currentSport.update();
				gui.setTime(currentSport.getGameplayTime());
				gui.setScore(currentSport.getPlayerMeters().toString());
				gui.setPower(currentSport.getPlayerPower());
			}			
		}
		
		private function onPause(e:Event):void
		{
			// TODO parar la competencia
			// currentSport.pause();
		}
		
		private function onResume(e:Event):void
		{
			// currentSport.resume();
		}
		
		private function onCompetitionEnd(e:Event):void
		{			
			playAudioScheme("end");
			gui.endgame(currentSport.badge);
			api.addOlympicTeamReward(currentSport.badgeAsString());				
		}
		
		
		private function onCountDownEnded(e:Event):void
		{
			audio.fx.play("tiempo_fuera");
			currentSport.start();
		}
		
		private function showCountDown(e:Event):void
		{			
			gui.showCountDown();
			e.currentTarget.removeEventListener(GuiEvents.COUNTDOWN, showCountDown);
		}
		
		
		
		
		private function onNewMatch(e:Event):void
		{
			trace("crear el level con ese juego: " + gui.currentSport.classID);
			
			playAudioScheme("ingame");
		
			PlainRace;
			LongJump;
			ShotPut;
			HighJump;
			Hurdles;
			ThrowingGame;
			JavelinThrow;
			
			
			if(currentSport) disposeSport(currentSport);
				
			var sportClass:Class = getDefinitionByName("game.sports." + gui.currentSport.classID) as Class;
			currentSport = new sportClass(gui.currentSport);
			currentSport.addEventListener(GuiEvents.NEW_MATCH, onNewMatch);				
			currentSport.addEventListener(Sport.COMPETITION_END, onCompetitionEnd);
			currentSport.addEventListener(GuiEvents.COUNTDOWN, showCountDown ); // algunos sports tienen countdown
			
			currentSport.initialize();
			
			addChildAt(currentSport, 0);			
			stage.focus = this;
			
		}
		
				
		
		private function disposeSport(currentSport:Sport):void
		{			
			currentSport.removeEventListener(GuiEvents.NEW_MATCH, onNewMatch);				
			currentSport.removeEventListener(Sport.COMPETITION_END, onCompetitionEnd);
			removeChild(currentSport);
			currentSport = null;
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
			// TODO VERSION STANDAR CON PUNTOS POR MONEDAS
			// close(maxSessionScore.value);
			// por ahora pasa 0 porque da medallas. esto esta implementado en el sport.
			close(0); // close llama a dispose();

		}
		
		// eliminar bien el juego.
		// dispose() se llama en baseGame por medio de close();
		override public function dispose():void
		{
			audio.music.stop();
			audio.fx.stop();
			stage.removeEventListener(Event.ENTER_FRAME, update);
			if(currentSport) disposeSport(currentSport);
			removeChild(gui); gui = null;			
		}
		
		public static function taskRunner():TaskRunner
		{
			return tasks;			
		}
		
	}
}

