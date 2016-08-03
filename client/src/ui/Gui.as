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
	
	import game.Avatar;
	import game.sports.Sport;
	
	import mx.core.ButtonAsset;
	import mx.olap.aggregators.CountAggregator;
	
	import popups.ConfirmationPopup;
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
		
		
		private var club:int;
		
		private var countdown:MovieClip;
		private var trainer:MovieClip;
		private var medal:MovieClip;
		
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
			
			// countdown
			countdown = asset.getChildByName("countdown") as MovieClip;
			countdown.addEventListener(Event.COMPLETE, countdownEnded);
			countdown.stop();
			countdown.visible = false;
			
			
			
			
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
			
			trainer = sportsMenu.getChildByName("trainer") as MovieClip;
			trainer.stop();
			trainer.visible = false;
			
			medal = sportsMenu.getChildByName("medal") as MovieClip;
			medal.stop();
			medal.visible = false;
			
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
		
		public function setClub(club:int):void
		{
			this.club = club;
		}
		
		public function showCountDown():void
		{
			countdown.gotoAndPlay(2);
			countdown.visible = true;			
		}
		
		private function countdownEnded(e:Event):void
		{
			countdown.visible = false;
			dispatchEvent(new Event(GuiEvents.COUNTDOWN_END));			
			
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
					trainer.visible = false;
					medal.visible = false;
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
			instructions(false);
			sportName(false);	
			sportsMenu.visible = false;			
			inGameData(true);
			dispatchEvent(new Event(GuiEvents.NEW_MATCH));			
		}
		
		
		private function inGameData(show:Boolean):void
		{
			power.visible = true;
			info.visible = true;			
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
			
			sportsMenu.clubPh.label.text = api.getText(settings.teams[club]);
			sportsMenu.clubPh.gotoAndStop(club);
			
			
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
		

		
		
		public function reset():void
		{
			exitBtn.visible = true;
		}
		
		public function setTime(time:String):void
		{
//			asset.timer.field.text = time;
		}
		
		public function setScore(score:String):void
		{
			this.info.value.text = score;
		}
		
		public function endgame(medal:int):void{
			trace("gui endgame", medal);
			sportsMenu.visible = true;
			sportName(true);
			inGameData(false);
			
			
			switch(medal)
			{
				case Sport.BADGE_LOOSER:
				{
					showTrainer("lose");
					break;
				}
				case Sport.BADGE_BRONCE:
				{
					showTrainer("win");
					showMedal(Sport.BADGE_BRONCE);
					break;
				}
				case Sport.BADGE_SILVER:
				{
					showTrainer("win");
					showMedal(Sport.BADGE_SILVER);
					break;
				}
				case Sport.BADGE_GOLD:
				{
					showTrainer("win");
					showMedal(Sport.BADGE_GOLD);
					break;
				}
				
				default:
				{
					break;
				}
			}
			
		}

		private function showTrainer(frame:String):void
		{
			trainer.visible = true;
			trainer.gotoAndStop(frame);
		}
		
		private function showMedal(frame:int):void
		{
			medal.visible = true;
			medal.gotoAndStop(frame);
		}
		
		private function onExitBtn(e:Event):void
		{
			audio.fx.play("click");
			confirmationPopup.visible = true;
			dispatchEvent(new Event(GuiEvents.PAUSE));
		}
		
		private function onConfirmationExit(e:Event):void 
		{
			dispatchEvent(new Event(GuiEvents.CONFIRMATION_EXIT));
		}
		
		
		private function onOver(e:Event):void
		{
			audio.fx.play("rollover");
		}
		
//		private function onPlay(e:Event):void
//		{			
//			audio.fx.play("click");			
//			dispatchEvent(new Event(GuiEvents.PLAY));			
//		}

		private function onResume(e:Event=null):void
		{
			audio.fx.play("click");
			confirmationPopup.visible = false;
			dispatchEvent(new Event(GuiEvents.RESUME));
		}

		public function get currentSport():String
		{
			return sportSelected;
		}
	}
}