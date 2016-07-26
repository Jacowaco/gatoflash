package ui
{
	import assets.*;
	
	import com.qb9.flashlib.movieclip.actions.GotoAndStopAction;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import popups.ConfirmationPopup;
	import popups.EndGamePopup;
	import popups.InstructionsPopup;

	public class Gui extends Sprite
	{
		private var asset:MovieClip;
		
		private var instructionsPopup:InstructionsPopup;		
		private var confirmationPopup:ConfirmationPopup;
		private var endGamePopup:EndGamePopup;
		private var endCutscene:EndCutscene;

		
		private var exitBtn:MovieClip;		
		private var score:MovieClip;
		private var time:MovieClip;
		
		
		public function Gui(asset:MovieClip)
		{
			super();
			this.asset = asset;
			
			
			// instrucciones
			instructionsPopup = new InstructionsPopup();
			addChild(instructionsPopup);			
			instructionsPopup.addEventListener(GuiEvents.PLAY, onPlay);
					
			
			// boton salir
			exitBtn = asset.getChildByName("exit") as MovieClip;
			exitBtn.text.text = api.getText(settings.gui.confirmation.exit);
			exitBtn.mouseEnabled = true;			
			exitBtn.addEventListener(MouseEvent.CLICK, onExitBtn);
			exitBtn.addEventListener(MouseEvent.ROLL_OVER, onOver);
			exitBtn.visible = false;
			
			// score
			score = asset.getChildByName("score") as MovieClip;
			score.label.text = api.getText(settings.gui.score);
			score.visible = false;
			
			//time
			time = asset.getChildByName("timer") as MovieClip;		
			time.label.text = api.getText(settings.gui.time);
			time.visible = false;
			
			
			// confirmation popup
			confirmationPopup = new ConfirmationPopup();
			confirmationPopup.visible = false;
			confirmationPopup.addEventListener(GuiEvents.CONFIRMATION_EXIT, onConfirmationExit);
			confirmationPopup.addEventListener(GuiEvents.RESUME, onResume);
			addChild(confirmationPopup);

			// endgame popup
			endGamePopup = new EndGamePopup();
			addChild(endGamePopup);
			endGamePopup.visible = false;
			endGamePopup.addEventListener(GuiEvents.PLAY, onPlay);
			endGamePopup.addEventListener(GuiEvents.EXIT, onConfirmationExit);
			
			endCutscene = new EndCutscene();
			addChild(endCutscene);
			endCutscene.ballon.text.text = settings.gui.win.cutscene;
			endCutscene.ballon.visible = false;
			endCutscene.visible = false;
			endCutscene.gotoAndStop(1);
			
			// asset tiene el marco amarillo
			addChild(asset);
			
		}
		
//		public function showWinScreen(result:int, score:Number, bonus:Number, endScore:Number, isLastLevel:Boolean = false):void
//		{
//			logger.info("showWinScreen()");
//			endGamePopup.show(result, score, bonus, endScore, isLastLevel);
//			exitBtn.visible = false;
//		}

		public function showWinner(mc:Sprite, isLastRound:Boolean, isLastLevel:Boolean = false):void
		{
			//logger.info("showWinScreen()");
			endGamePopup.showWinner(mc, isLastRound, isLastLevel);
			exitBtn.visible = false;
		}

		public function showNext():void
		{
			logger.info("showNext");
//			endGamePopup.show(result, score, bonus, endScore, isLastLevel);
			endGamePopup.next();
			exitBtn.visible = false;
		}
		
		public function reset():void
		{
			endGamePopup.hide();
			exitBtn.visible = true;
		}
				
		public function setTime(time:String):void
		{
			asset.timer.field.text = time;
		}
		
		public function setScore(score:String):void
		{
			this.score.field.text = score;
		}
		
		// eventos
		
		private function onExitBtn(e:Event):void
		{
			audio.fx.play("click");
			confirmationPopup.visible = true;
			dispatchEvent(new Event(GuiEvents.EXIT));
		}
		
		private function onConfirmationExit(e:Event):void 
		{
			dispatchEvent(new Event(GuiEvents.CONFIRMATION_EXIT));
		}
		
		private function onResume(e:Event=null):void
		{
			audio.fx.play("click");
			confirmationPopup.visible = false;
			dispatchEvent(new Event(GuiEvents.RESUME));
		}
				
		private function onOver(e:Event):void
		{
			audio.fx.play("rollover");
		}

		private function onPlay(e:Event):void
		{
				if(e.currentTarget == instructionsPopup){
					e.currentTarget.removeEventListener(e.type, arguments.callee);
					removeChild(instructionsPopup);
//					score.visible = true;
				}
				
				
				dispatchEvent(new Event(GuiEvents.PLAY));
				
		}
		
		public function runCutscene():void
		{
			endCutscene.visible = true;
			score.visible = false;
			exitBtn.visible = false;
			endCutscene.gotoAndPlay(1);
			endCutscene.addEventListener(Event.ENTER_FRAME, onCutsceneEnterFrame);			
		}
		
		
		
		
		
		private function onCutsceneEnterFrame(e:Event):void			
		{
			if((endCutscene as MovieClip).currentLabel == "showText"){
				endCutscene.ballon.visible = true;
			}
			
			
			if((endCutscene as MovieClip).currentLabel == "end"){
				endCutscene.visible = false;
				endCutscene.removeEventListener(Event.ENTER_FRAME, onCutsceneEnterFrame);
				dispatchEvent(new Event(GuiEvents.ANIMATION_END));
			}
		}
	}
}