package game
{
	
	import adobe.utils.CustomActions;

	import flash.events.DataEvent;
	import game.sports.*;
	
	import com.qb9.flashlib.geom.Vector2D;
	import com.qb9.flashlib.security.SafeNumber;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import gameobject.GameObject;
	
	import utils.Stopwatch;
	
	public class LevelController extends Sprite
	{
	
		private var cron:Stopwatch; // tiempo
		private var levelScore:SafeNumber = new SafeNumber(0); // puntos safeNumber() encripta el score para que no lo cheateen.
		private var bonusScore:SafeNumber = new SafeNumber(0); // puntos safeNumber() encripta el score para que no lo cheateen.
		
		private var sport:Sport;
		
		
		public function LevelController()
		{
			super();
			logger.info("Level Controller init");
			
			cron = new Stopwatch();
			cron.setMode(Stopwatch.FORWARD);
			
//			Metres100;
//			LongJump;
//			ShotPut;
//			HighJump;
//			Hurdles;
//			DiscusThrow;
//			Metres400;
//			Metres1500;
//			PoleVault;
//			JavelinThrow;
			
			this.addEventListener(Event.ADDED_TO_STAGE, function():void
			{						
				create(); // solo lo creo cuando me agregaron al stage sino problema...
			});
		}
		
		private function create():void
		{
			//			createMenu();
			//createSport();
			
			reset();
			
		}
		
		public function createMenu():void
		{
//			menu = new Menu();
//			menu.addEventListener("BTN_CLICKED", btnClicked);
//			addChild(menu);
		}
		
		public function btnClicked(e:DataEvent):void
		{
			//trace(e.data);
//			removeChild(menu);
			
			var _sportClass:Class = getDefinitionByName("game.sports." + e.data) as Class;
			if (sport)
			{
				sport.removeEventListener(LevelEvents.LEVEL_LOST, lose);
				sport.removeEventListener(LevelEvents.LEVEL_WIN, win);
			}
			sport = new _sportClass();
			createSport();
			sport.reset();
			stage.focus = this;
		}
		
		private function createSport():void
		{
			//sport = new Sport();
			sport.addEventListener(LevelEvents.LEVEL_LOST, lose);
			sport.addEventListener(LevelEvents.LEVEL_WIN, win);
			sport.create();
			addChild(sport);
		}
		
		private function reset():void
		{
			if (sport) removeChild(sport);
			sport = null;
//			addChild(menu);
			
			cron.set(0, 0);
			levelScore.value = 0;
			bonusScore.value = 0;			
		}
		
		public function startLevel(goalDefinition:String, diff:int,  isLastRound:Boolean):void
		{			
			reset();
			//sport.reset();
			resume();
		}
		
		private function update(e:Event):void
		{
			if (sport) sport.update();
		}
		
		private function mouseMove(mouse:MouseEvent):void
		{
			
		}
		
		private function mouseClick(mouse:MouseEvent):void
		{
		}
		
		private function onKeyDown(key:KeyboardEvent):void
		{
			sport.onKeyDown(key);
		}
		
		private function onKeyUp(key:KeyboardEvent):void
		{
			sport.onKeyUp(key);
		}
		
		private function win(e:Event):void
		{
			//removeChild(sport);
			//sport = null;
			//addChild(menu);
			
			dispatchEvent(new Event(LevelEvents.LEVEL_WIN));
		}
		
		private function lose(e:Event):void
		{
			//removeChild(sport);
			//sport = null;
			//addChild(menu);
			
			dispatchEvent(new Event(LevelEvents.LEVEL_LOST));
		}	
		
		
		public function get time():String
		{
			return cron.ms();
		}
		
		public function getSeconds():int
		{
			return cron.secs();
		}
		public function get score():Number
		{
			return levelScore.value;
		}
		
		public function get bonus():Number
		{
			return bonusScore.value;
		}		
		
//		private function start():void
//		{			
//			logger.info("starting level:");
//			reset();
//			resume();		
//		}
		
		
		public function resume():void
		{			
			cron.go();			
			
			stage.addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.addEventListener(MouseEvent.CLICK, mouseClick);	
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		public function pause():void
		{
			cron.pause();
			
			stage.addEventListener(Event.ENTER_FRAME, update);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener(MouseEvent.CLICK, mouseClick);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
	}
}