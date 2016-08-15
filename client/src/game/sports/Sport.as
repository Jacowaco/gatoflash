package game.sports 
{
	import assets.*;
	
	import com.qb9.flashlib.geom.Vector2D;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	import game.Avatar;
	import game.Background;
	
	import ui.GuiEvents;
	
	import utils.Stopwatch;

	// extiendo de sprite pero en realidad no debería.
	// ya tengo bastantes DisplayObjects dando vuelta...
	// el background por ejemplo
	// por ahora lo dejamos asi.
	//sport es el modelo
	public class Sport extends Sprite 
	{
	
		protected var timer:Stopwatch;
		public static const UNITS_PER_METER:int = 100;		
		public static const BADGE_LOOSER:int = 0;
		public static const BADGE_BRONCE:int = 1;
		public static const BADGE_SILVER:int = 2;
		public static const BADGE_GOLD:int = 3;
		
		public static const COMPETITION_START:String = "competitionStart";
		public static const COMPETITION_END:String = "competitionEnd";
		public static const COMPETITION_READY:String = "competitionReady";
//		public static const COMPETITION_WIN:String = "competitionWin";
		public static const COMPETITION_LOST:String = "competitionLost";
		
		
		// esto es privado. no quiero que nadie toque este valor
		// a lo sumo te doy un metodo publico para que lo leas.
		private var badgeObtained:int = 0; 
		
		protected var player:Avatar;		
		
		// puede ser 0 para los juegos de tirar cosas.
		protected const CANT_ENEMIES:int = 4;
		
		// aca se define toda la sangucheria de cosas que se tienen que mover durante la partida.
		// queda todo supeditado a la camara en un punto.
		// esta es la magia mas maravillosa de flash. (vista y modelo conviven todo el tiempo)
		// la clave obviamente es enteder el DisplayList a full y en particular la clase MovieClip
		protected var camera:Sprite;		
		protected var bg:Background;				
		protected var playerScreenPosition:Number;
		protected var levelDefinition:MovieClip;
		
		// estado del juego
//		protected var meters:int;
		protected var playing:Boolean;
		protected var leftKeyPressed:Boolean;
		// para poder ubicar el setting de este sport en los settings
		public var currentSport:Object; 
//		protected var exitButton:assets.exitButtonAll;
		protected var sportSounds:Array;
		
		public function Sport() 
		{
			timer = new Stopwatch();
			bg = new Background();
			addChild(bg);			
			camera = new Sprite();
			addChild(camera);
			playerScreenPosition = Game.SCREEN_WIDTH / 4;
			
		}
		
		// esto te obliga a implementar el metodo en todos los sports
		// no se si es del todo necesario pero creo que te evita algunos quilombos
		// tendría que pensarlo un cacho mas

		protected function create():void
		{
			throw new Error("create not implemented");
		}
		
		// configuro todo
		public function initialize():void
		{
			dispatchEvent(new Event(Sport.COMPETITION_READY));
		}

		// la competencia arranca
		public function start():void
		{
			dispatchEvent(new Event(Sport.COMPETITION_START));
		}
				
		// actualizo
		public function update():void
		{
			throw new Error("uninplemented");
		}
		
		// los controles
		public function onKeyDown(key:KeyboardEvent):void
		{
			throw new Error("unninplemented");
		}
		
		public function onKeyUp(key:KeyboardEvent):void
		{
			throw new Error("unninplemented");
		}

		// en cada sport se que medalla le corresponde
		protected function assignBadge():void
		{
			throw new Error("unninplemented");
		}
		
		protected function competitionEnds():void
		{			
			playing = false;
			
			if(badge == BADGE_LOOSER){
				audio.fx.play("bu");
				audio.fx.play("lose");
			}else{
				audio.fx.play("ovacion");
				audio.fx.play("win");
			}
			
			setTimeout(function():void{ dispatchEvent(new Event(Sport.COMPETITION_END));}, 1000);
			
		}
		
		protected function lose():void
		{
			playing = false;
			dispatchEvent(new Event(Sport.COMPETITION_LOST));
		}
		
		public function get badge():int
		{
			return badgeObtained;
		}
		
		public function set badge(badge:int):void
		{
			badgeObtained = badge;
		}
		
		public function badgeAsString():String
		{
			switch(badgeObtained)
			{
				case BADGE_BRONCE:
				{
					return "bronce";
					break;
				}
				case BADGE_SILVER:
				{
					return "silver";
					break;
				}	
				case BADGE_GOLD:
				{
					return "gold";
					break;
				}
				default:
				{
					return "";
					break;
				}
			}
		}
		
		
		private function replay():void
		{
			dispatchEvent(new Event(GuiEvents.NEW_MATCH));			
		}
		
		public function getPlayerMeters():int
		{
			return 0;
		}
			
		public function getPlayerPower():Number
		{
			return player.getPower();	
		}
		
		public function getGameplayTime():String
		{
			return timer.ms();	
		}
	}

}