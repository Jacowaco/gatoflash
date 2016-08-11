package game.sports 
{
	import assets.*;
	import flash.events.MouseEvent;
	
	import com.qb9.flashlib.geom.Vector2D;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import game.Avatar;
	import game.Background;
	import game.LevelEvents;
	
	import ui.GuiEvents;

	// extiendo de sprite pero en realidad no debería.
	// ya tengo bastantes DisplayObjects dando vuelta...
	// el background por ejemplo
	// por ahora lo dejamos asi.
	//sport es el modelo
	public class Sport extends Sprite 
	{
	
		public static const UNITS_PER_METER:int = 100;		
		public static const BADGE_LOOSER:int = 0;
		public static const BADGE_BRONCE:int = 1;
		public static const BADGE_SILVER:int = 2;
		public static const BADGE_GOLD:int = 3;
		
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
		public var currentSport:String; 
//		protected var exitButton:assets.exitButtonAll;
		protected var sportSounds:Array;
		
		public function Sport() 
		{
			bg = new Background();
			addChild(bg);			
			camera = new Sprite();
			addChild(camera);
			playerScreenPosition = Game.SCREEN_WIDTH / 4;
			
			
			/*           BOTON PARA SALIRSE EN EL MEDIO DE UNA PARTIDA             */
//			registerSoundsToStopAtGameEnd();
//			exitButton  = new exitButtonAll();
//			addChild(exitButton);
//			exitButton.x = 640; //bg.width - exitButton.width / 2;
//			exitButton.y = 410; //bg.height - exitButton.height / 2;
//			exitButton.addEventListener(MouseEvent.CLICK, onExitClick);
			// ****************************************************************** //
		}
		
//		public function onExitClick(e:MouseEvent):void
//		{
//			if ( !playing ) return;
//			
//			for (var i:int = 0; i < sportSounds.length; i++) {
//				audio.fx.stop(sportSounds[i]);
//			}
//			
//			badge = BADGE_LOOSER;
//			lose();
//		}
		
		
		// esto te obliga a implementar el metodo en todos los sports
		// no se si es del todo necesario pero creo que te evita algunos quilombos
		// tendría que pensarlo un cacho mas
		public function start():void
		{
			throw new Error("uninplemented");
		}
		
		public function init():void
		{
			throw new Error("uninplemented");
		}
		public function update():void
		{
			throw new Error("uninplemented");
		}
		
		public function onKeyDown(key:KeyboardEvent):void
		{
			throw new Error("unninplemented");
		}
		
		public function onKeyUp(key:KeyboardEvent):void
		{
			throw new Error("unninplemented");
		}
		
		protected function assignBadge():void
		{
			throw new Error("unninplemented");
		}
		
		protected function win():void
		{			
			playing = false;
			dispatchEvent(new Event(LevelEvents.LEVEL_WIN));
		}
		
		protected function lose():void
		{
			playing = false;
			dispatchEvent(new Event(LevelEvents.LEVEL_LOST));
		}
		
//		public function registerSoundsToStopAtGameEnd():void
//		{
//			sportSounds = [];
//		}
		
		public function get badge():int
		{
			return badgeObtained;
		}
		
		public function set badge(badge:int):void
		{
			badgeObtained = badge;
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
		
	}

}