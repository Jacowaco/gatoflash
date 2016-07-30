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
	import game.MovingObject;
	import game.Player;

	public class Sport extends Sprite 
	{
	
		public static const UNITS_PER_METER:int = 100;
		
		public static const BADGE_LOOSER:int = 0;
		public static const BADGE_BRONCE:int = 1;
		public static const BADGE_SILVER:int = 2;
		public static const BADGE_GOLD:int = 3;
		
		protected var levelDefinition:MovieClip;
		protected var bg:Background;
		protected var start:MovingObject;
		
		protected var player:Player;
		
		protected var camera:Sprite;
		
		protected var meters:int;
		protected var playing:Boolean;
		protected var leftKeyPressed:Boolean;

		protected var badgeObtained:int = 0;
		
		public function Sport() 
		{
			super();				
			levelDefinition = new assets.level1MC();
			create();
		}
		
		private function create():void
		{
			player = new Player(new CorredorMC);
			camera = new Sprite();
			addChild(camera);
			
			bg = new Background();
			camera.addChild(bg);
			
			
			var _asset:MovieClip; 
			
			for (var i:int = 0; i < levelDefinition.numChildren; i++)
			{			
				if (getQualifiedClassName(levelDefinition.getChildAt(i)).lastIndexOf("assets::startMC") != -1)
				{
					_asset = levelDefinition.getChildAt(i) as MovieClip;
					start = new MovingObject(_asset);
					camera.addChild(_asset);
				}
				
				if (getQualifiedClassName(levelDefinition.getChildAt(i)).lastIndexOf("assets::lineMC") != -1)
				{
					_asset = levelDefinition.getChildAt(i) as MovieClip;
					camera.addChild(_asset);
				}						
			}
			
		
		}
		
		
		public function reset():void
		{
			meters = 0;
			camera.x = 0;
			
			bg.reset();
		
//			if(player){
//				player.initLoc(start.loc.x, start.loc.y);
//				player.reset();					
//			}

//			speedBar.reset();			
//			hud.updateMeters(meters);
			
			playing = true;
		}
		
		public function update():void
		{
			if (!playing) return;			
			bg.update();
			player.update();
		}
		
		
		// esto te obliga a implementar el metodo en todos los sports
		// no se si es del todo necesario pero creo que te evita algunos quilombos
		// tendría que pensarlo un cacho mas
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
			trace("BADGE OBTAINED", badgeObtained);
			
			playing = false;
			dispatchEvent(new Event(LevelEvents.LEVEL_WIN));
		}
		
		public function lose():void
		{
			playing = false;
			dispatchEvent(new Event(LevelEvents.LEVEL_LOST));
		}
	}

}