package game.sports 
{
	import assets.*;
	
	import com.qb9.flashlib.geom.Vector2D;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import game.Background;
	import game.LevelEvents;
	import game.Player;	
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
		
		protected var player:Player;		
		protected var enemies:Array;
		
		// puede ser 0 para los juegos de tirar cosas.
		protected const CANT_ENEMIES:int = 4;
		
		// aca se define toda la sangucheria de cosas que se tienen que mover durante la partida.
		// queda todo supeditado a la camara en un punto.
		// esta es la magia mas maravillosa de flash. (vista y modelo conviven todo el tiempo)
		// la clave obviamente es enteder el DisplayList a full y en particular la clase MovieClip
		protected var camera:Sprite;		
		protected var bg:Background;				
		
		protected var levelDefinition:MovieClip;
		
		// estado del juego
		protected var meters:int;
		protected var playing:Boolean;
		protected var leftKeyPressed:Boolean;
		// para poder ubicar el setting de este sport en los settings
		protected var currentSport:String; 
		
		public function Sport() 
		{
			bg = new Background();
			addChild(bg);
			
			camera = new Sprite();
			addChild(camera);
		}
		
		
		// esto te obliga a implementar el metodo en todos los sports
		// no se si es del todo necesario pero creo que te evita algunos quilombos
		// tendría que pensarlo un cacho mas
		
		protected function createSport():void
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
		
		public function assignBadge():void
		{
			throw new Error("unninplemented");
		}
		
		public function win():void
		{
			assignBadge();
			playing = false;
			dispatchEvent(new Event(LevelEvents.LEVEL_WIN));
		}
		
		public function lose():void
		{
			playing = false;
			dispatchEvent(new Event(LevelEvents.LEVEL_LOST));
		}
		
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
	}

}