package game 
{
	import assets.*;
	import com.qb9.flashlib.geom.Vector2D;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import gameobject.GameObject;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	
	public class Sport extends Sprite 
	{
		public static const UNITS_PER_METER:int = 100;
		
		protected var level:MovieClip;
		protected var camera:Sprite;
		protected var bg:Background;
		protected var start:GameObject;
		protected var speedBar:SpeedBar;
		protected var player:Player;
		protected var meters:int;
		protected var hud:HUD;
		protected var playing:Boolean;
		protected var leftKeyPressed:Boolean;
		protected var endCutScene:MovieClip;
		
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
			for (var i:int = 0; i < level.numChildren; i++)
			{
				var _asset:MovieClip;
				
				if (getQualifiedClassName(level.getChildAt(i)).lastIndexOf("assets::backgroundMC") != -1)
				{
					_asset = level.getChildAt(i) as MovieClip;
					//_asset = new assets.backgroundMC();
					var _asset2:MovieClip = new assets.backgroundMC();
					bg = new Background(_asset, _asset2);
					camera.addChild(_asset);
					camera.addChild(_asset2);
				}
				if (getQualifiedClassName(level.getChildAt(i)).lastIndexOf("assets::startMC") != -1)
				{
					_asset = level.getChildAt(i) as MovieClip;
					start = new GameObject(_asset);
					start.debug(false);
					camera.addChild(_asset);
				}
				if (getQualifiedClassName(level.getChildAt(i)).lastIndexOf("assets::speedBarMC") != -1)
				{
					_asset = level.getChildAt(i) as MovieClip;
					speedBar = new SpeedBar(_asset);
					addChild(_asset);
				}
			}
			
			addThingsBeforePlayer();
			
			player = new Player(new assets.GaturroMC());
			camera.addChild(player.asset);
			
			hud = new HUD();
			addChild(hud);
			
			endCutScene = new assets.endCutsceneMC();
			addChild(endCutScene);
			endCutScene.visible = false;
		}
		
		protected function addThingsBeforePlayer():void
		{
			
		}
		
		public function reset():void
		{
			meters = 0;
			camera.x = 0;
			
			bg.reset();
			
			speedBar.reset();
			
			player.init(start.loc);
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
		
		public function win():void
		{
			playing = false;
			dispatchEvent(new Event(LevelEvents.LEVEL_WIN));
			endCutScene.visible = true;
			endCutScene.gotoAndStop("win");
			//endCutScene.addEventListener
		}
		
		public function lose():void
		{
			playing = false;
			dispatchEvent(new Event(LevelEvents.LEVEL_LOST));
			endCutScene.visible = true;
			endCutScene.gotoAndStop("lose");
			//endCutScene.addEventListener
		}
	}

}