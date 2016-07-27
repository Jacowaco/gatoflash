package game 
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
	
//	import gameobject.GameObject;
	
	
	public class Sport extends Sprite 
	{
		public static const UNITS_PER_METER:int = 100;
		
		public static const BADGE_BRONCE:int = 0;
		public static const BADGE_SILVER:int = 1;
		public static const BADGE_GOLD:int = 2;
		
		protected var level:MovieClip;
		protected var camera:Sprite;
		protected var bg:Background;
		protected var start:MovingObject;
//		protected var speedBar:SpeedBar;
		protected var player:Player;
		protected var meters:int;
		protected var hud:HUD;
		protected var playing:Boolean;
		protected var leftKeyPressed:Boolean;
//		protected var endCutScene:MovieClip;
		protected var badgeObtained:int = 0;
		
		public function Sport() 
		{
			super();
			
			level = new assets.level1MC();
		}
		
		public function create():void
		{
			camera = new Sprite();
			addChild(camera);
			
			//Cargo los assets del SWC
			
			var _asset:MovieClip = new assets.backgroundMC();
			var _asset2:MovieClip = new assets.backgroundMC();
			bg = new Background(_asset, _asset2);
			camera.addChild(bg);
			
//			camera.addChild(_asset);
//			camera.addChild(_asset2);
//			
			for (var i:int = 0; i < level.numChildren; i++)
			{
			
				if (getQualifiedClassName(level.getChildAt(i)).lastIndexOf("assets::startMC") != -1)
				{
					_asset = level.getChildAt(i) as MovieClip;
					start = new MovingObject(_asset);
					camera.addChild(_asset);
				}
				if (getQualifiedClassName(level.getChildAt(i)).lastIndexOf("assets::phCartel") != -1)
				{
					_asset = level.getChildAt(i) as MovieClip;
					addChild(_asset);
				}
				
				
			}
			
			addThingsBeforePlayer();
			
			player = new Player(new assets.CorredorMC());
			camera.addChild(player.asset);
			
			hud = new HUD();
			addChild(hud);
			
//			endCutScene = new assets.endCutsceneMC();
//			addChild(endCutScene);
//			endCutScene.visible = false;
		}
		
		protected function addThingsBeforePlayer():void
		{
			
		}
		
		public function reset():void
		{
			meters = 0;
			camera.x = 0;
			
			bg.reset();
			
//			speedBar.reset();
			
			player.initLoc(start.loc.x, start.loc.y);
			player.reset();
			
			hud.updateMeters(meters);
			
			playing = true;
		}
		
		public function update():void
		{
			if (!playing) return;
			
			bg.update();
			player.update();
		}
		
		public function onKeyDown(key:KeyboardEvent):void
		{
			
		}
		
		public function onKeyUp(key:KeyboardEvent):void
		{
			
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