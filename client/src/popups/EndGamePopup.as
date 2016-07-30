package popups
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ui.GuiEvents;
	
	public class EndGamePopup extends MovieClip
	{
		private var asset:MovieClip;		
		public static const WIN:int = 1;
		public static const LOSE:int = -1;
		

		public function EndGamePopup()
		{
			super();			
//			this.asset = new popups.WinScreen();
//			addChild(this.asset);				
//			init();
		}
		
		private function init():void
		{
			asset.title.text = api.getText(settings.gui.win.title);
			
			asset.score_title.text = api.getText(settings.gui.win.score);
			asset.bonus_title.text = api.getText(settings.gui.win.bonus);
			asset.total_title.text = api.getText(settings.gui.win.total);
			asset.gamePoints_title.text = api.getText(settings.gui.win.gamePoints);
			asset.gamePoints_title.visible = false;
			asset.gamePoints_txt.visible = false;
			
			asset.again.text.text = api.getText(settings.gui.win.again);
			asset.exit.text.text = api.getText(settings.gui.win.exit);
			
			(asset.again as MovieClip).addEventListener(MouseEvent.CLICK, onPlay);
			(asset.exit as MovieClip).addEventListener(MouseEvent.CLICK, onExit);
		}
		
		public function showWinner(mc:Sprite, isLastRound:Boolean, isLastLevel:Boolean = false):void{
			
			//asset.title.text = api.getText(settings.gui.win.title);
			while((asset.asset_ph as Sprite ).numChildren > 0){
				asset.asset_ph.removeChildAt(0);
			}
			
			if(isLastLevel){ //
				asset.title.text = api.getText(settings.gui.win.end);
				asset.title2.text = api.getText(settings.gui.win.end2);
				asset.again.visible = false;
				asset.exit.x = 355;						
			}else if(isLastRound){
				asset.title.text = api.getText(settings.gui.win.lastRound);
				asset.title2.text = api.getText(settings.gui.win.lastRound2);
				asset.again.visible = false;
				asset.exit.x = 355;
			}else{
				asset.title.text = api.getText(settings.gui.win.title);
				asset.title2.text = " ";//api.getText(settings.gui.win.title);
			}
			
			logger.info(mc);
			asset.asset_ph.addChild(mc);
			asset.gotoAndPlay(1);			
			visible = true;
		}
		
//		public function show(result:int, score:Number, bonus:Number, endScore:Number, isLastLevel:Boolean = false):void
//		{
//			switch(result)
//			{
//				case WIN:
//				{
//					asset.title.text = api.getText(settings.gui.win.title);		
//					break;
//				}
//					
//				case LOSE:
//				{
//					asset.title.text = api.getText(settings.gui.win.loose);	
//					break;
//				}
//					
//				default:
//				{
//					break;
//				}
//			}
//			
//			
//			asset.score_txt.text = score;
//			asset.bonus_txt.text = bonus;			
//			asset.total_txt.text = score+bonus;
//			
//			if(isLastLevel){ //
//				asset.title.text = api.getText(settings.gui.win.end);
//				asset.again.visible = false;
//				asset.exit.x = 355;
//				asset.gamePoints_txt.text = endScore		
//					
//			}
////			
////			// salir x 315
////			asset.gamePoints_txt.text = endScore;
//			asset.gotoAndPlay(1);			
//			visible = true;
//		}
		
		public function next():void
		{
			asset.title.text = api.getText(settings.gui.win.title);		
					
			asset.score_txt.visible = false; 
			asset.bonus_txt.visible = false; 			
			asset.total_txt.visible = false; 
			
			asset.score_title.visible = false; 
			asset.bonus_title.visible = false; 
			asset.total_title.visible = false; 
			
			
			asset.again.text.text = api.getText(settings.gui.confirmation.next);
			asset.gotoAndPlay(1);			
			visible = true;
		}
		
		public function hide():void
		{
			visible = false;
		}

		
		private function onPlay(e:MouseEvent) : void
		{
			audio.fx.play("click");			
			dispatchEvent(new Event(GuiEvents.PLAY));
		}
		
		private function onExit(e:Event):void
		{
			dispatchEvent(new Event(GuiEvents.PAUSE));
			audio.play("click");
		}

			
	}
}