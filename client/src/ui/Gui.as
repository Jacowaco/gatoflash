package ui
{
	import assets.*;
	
	import com.qb9.flashlib.movieclip.actions.GotoAndStopAction;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.getClassByAlias;
	import flash.utils.getDefinitionByName;
	
	import mx.core.ButtonAsset;
	
	import popups.ConfirmationPopup;
	import popups.EndGamePopup;
	import popups.InstructionsPopup;
	import popups.McMenu;
	
	
	
	
	public class Gui extends Sprite
	{
		private var asset:MovieClip; // gui
		
		
		private var exitBtn:MovieClip; //	salir en la gui ingame		
		private var info:MovieClip;    //	muestra la data del juego actual (tiempo/metros)
		private var power:MovieClip;	//  la barra de power
		
		// menus
		private var sportsMenu:MovieClip;
		private var sportsMenuButtons:Array;
		private var sportSelected:String;

		private var confirmationPopup:ConfirmationPopup;
		private var endGamePopup:EndGamePopup;
		
		
		
		public function Gui(asset:MovieClip)
		{
			super();
			this.asset = asset;
			
			trace("creating gui");
			trace(asset);
			
			// boton salir
			exitBtn = asset.getChildByName("exit") as MovieClip;
			exitBtn.text.text = api.getText(settings.gui.confirmation.exit);
			exitBtn.mouseEnabled = true;			
			exitBtn.addEventListener(MouseEvent.CLICK, onExitBtn);
			exitBtn.addEventListener(MouseEvent.ROLL_OVER, onOver);
			exitBtn.visible = false;
			
			
			
			
			
			// score
			info = asset.getChildByName("display") as MovieClip;
			info.label.text = api.getText(settings.sports.defaultValue.display.label);
			info.visible = false;
			
			// power
			power = asset.getChildByName("power") as MovieClip;
			// TODO doesnt work
			power.stop();
			
			
			
			// endgame popup
			endGamePopup = new EndGamePopup();
			addChild(endGamePopup);
			endGamePopup.visible = false;
			endGamePopup.addEventListener(GuiEvents.PLAY, onPlay);
			endGamePopup.addEventListener(GuiEvents.EXIT, onConfirmationExit);
			
			// el menu que te deja elegir el juego			
			sportsMenu = new McMenu();
			sportsMenu.txt_title.text = settings.gui.title;
			sportsMenu.txt_details.text = settings.gui.details;
			
			
			
			sportsMenu.backBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{ goPage(1) });
			sportsMenu.backBtn.addEventListener(MouseEvent.ROLL_OVER, onOver);
			sportsMenu.backBtn.text.text = api.getText(settings.gui.confirmation.back);
			sportsMenu.backBtn.visible = false;
			
			sportsMenu.playGameBtn.addEventListener(MouseEvent.CLICK, playSport);
			sportsMenu.playGameBtn.addEventListener(MouseEvent.ROLL_OVER, onOver);
			sportsMenu.playGameBtn.text.text = api.getText(settings.gui.confirmation.play);
			sportsMenu.playGameBtn.visible = false;
			
			sportsMenu.exitBtn.addEventListener(MouseEvent.CLICK, onExitBtn);
			sportsMenu.exitBtn.addEventListener(MouseEvent.ROLL_OVER, onOver);
			sportsMenu.exitBtn.text.text = api.getText(settings.gui.confirmation.exit);
			sportsMenu.exitBtn.visible = true;

			sportsMenu.pg2.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{ goPage(2) });
			sportsMenu.pg1.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{ goPage(1) });
						
			sportsMenu.nextWeek.visible = false;
			
			// botones de los juegos
			hurdles_btn;
			fourHundreds_btn;
			pizza_btn;
			highJump_btn;
			
			// armo los botones para los primeros 4
			sportsMenuButtons = new Array();
			
			for(var i:int = 0; i < settings.sports.sportsQty; i ++){
				var buttonToReplace:MovieClip = sportsMenu["sport"+i]; 		
				var x:int = buttonToReplace.x;
				var y:int = buttonToReplace.y;
				
				var myClass:Class = getDefinitionByName("assets."+settings.sports["sport"+i].id+"_btn") as Class;
				
				var newButton:MovieClip = new myClass() as MovieClip;
				newButton.name = "sport"+i;
				newButton.x = x;
				newButton.y = y;
				newButton.visible = false;
				newButton.addEventListener(MouseEvent.CLICK, playSportMenu);
				
				sportsMenuButtons.push(newButton);		
				sportsMenu.removeChild(buttonToReplace);				
				sportsMenu.addChild(newButton);	
			}
			
			goPage(1);
			
			sportsMenu.instructionsMc.visible = false;
			sportsMenu.txtClub.visible = false;
			
			addChild(sportsMenu);
			
			// confirmation popup
			confirmationPopup = new ConfirmationPopup();
			confirmationPopup.visible = false;
			confirmationPopup.addEventListener(GuiEvents.CONFIRMATION_EXIT, onConfirmationExit);
			confirmationPopup.addEventListener(GuiEvents.RESUME, onResume);
			addChild(confirmationPopup);
			
			// asset tiene el marco amarillo
			addChild(asset);
			
			
		}
		
		private function goPage(page:int):void
		{
			switch (page){
				case 1:
					buttons(true);
					arrows(true);
					instructions(false);
					playbtn(false);
					sportName(false);
					
					sportsMenu.nextWeek.visible = false;
					break;
				
				case 2:
					buttons(false);
					sportsMenu.nextWeek.visible = true;
					break;
			}
			
			
			
		}
		
		private function arrows(show:Boolean):void
		{
			sportsMenu.pg2.visible = show;
			sportsMenu.pg1.visible = show;
			sportsMenu.exitBtn.visible = show;
		}
		
		private function buttons(show:Boolean):void
		{
			for(var i:int = 0; i < settings.sports.sportsQty; i ++){
				sportsMenuButtons[i].visible = show;											
			}			
		}
		
		private function playSport(e:Event):void
		{
			sportsMenu.visible = false;			
			dispatchEvent(new Event(GuiEvents.PLAY));			
		}
		
		private function playSportMenu(e:Event):void
		{						
			buttons(false);
			arrows(false);
			playbtn(true);
			instructions(true);
			sportName(true);			
			details(false);
			
			sportsMenu.txt_sportTitle.text = settings.sports[e.currentTarget.name].name;
			sportSelected = settings.sports[e.currentTarget.name].classID;			
			sportsMenu.txt_details.text = settings.sports[e.currentTarget.name].name;
			
		}
		
		private function instructions(show:Boolean):void
		{
			sportsMenu.instructionsMc.visible = show;
			sportsMenu.txtClub.visible = show;
			sportsMenu.clubPh.visible = show;
		}
		
		private function playbtn(show:Boolean):void
		{
			sportsMenu.backBtn.visible = show;
			sportsMenu.playGameBtn.visible = show;
		}
		
		private function sportName(show:Boolean):void
		{			
			sportsMenu.txt_sportTitle.visible = show;
		}
		
		private function details(show:Boolean):void
		{
			
			sportsMenu.txt_details.visible = show;
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
//			asset.timer.field.text = time;
		}
		
		public function setScore(score:String):void
		{
//			this.info.field.text = score;
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
			//				if(e.currentTarget == instructionsPopup){
			//					e.currentTarget.removeEventListener(e.type, arguments.callee);
			//					removeChild(instructionsPopup);
			//					score.visible = true;
			//				}
			
			
			dispatchEvent(new Event(GuiEvents.PLAY));
			
		}
		
		public function runCutscene():void
		{
			//			endCutscene.visible = true;
			//			score.visible = false;
			//			exitBtn.visible = false;
			//			endCutscene.gotoAndPlay(1);
			//			endCutscene.addEventListener(Event.ENTER_FRAME, onCutsceneEnterFrame);			
		}
		
		
		
		
		
		private function onCutsceneEnterFrame(e:Event):void			
		{
			
			//			if((endCutscene as MovieClip).currentLabel == "showText"){
			//				endCutscene.ballon.visible = true;
			//			}
			//			
			//			
			//			if((endCutscene as MovieClip).currentLabel == "end"){
			//				endCutscene.visible = false;
			//				endCutscene.removeEventListener(Event.ENTER_FRAME, onCutsceneEnterFrame);
			//				dispatchEvent(new Event(GuiEvents.ANIMATION_END));
			//			}
		}
		
		public function get currentSport():String
		{
			return sportSelected;
		}
	}
}