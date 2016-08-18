package ui
{
	import assets.*;
	
	import avatar_fla.fall_32;
	
	import com.adobe.serialization.json.JSON;
	import com.qb9.flashlib.lang.AbstractMethodError;
	import com.qb9.flashlib.movieclip.actions.GotoAndStopAction;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.getClassByAlias;
	import flash.utils.getDefinitionByName;
	
	import game.Avatar;
	import game.sports.PlainRace;
	import game.sports.Sport;
	
	import popups.ConfirmationPopup;
	import popups.McMenu;
	
	import utils.Utils;
	
	
	
	
	public class Gui extends Sprite
	{
		private var asset:MovieClip; // la gui completa		
		
		private var exitBtn:MovieClip; //	salir en la gui ingame		
		private var meters:MovieClip;    //	muestra la data del juego actual (metros)
		private var power:MovieClip;	//  la barra de power		
		private var time:MovieClip;    //	muestra la data del juego actual (tiempo)
		private var countdown:MovieClip;
		
		// menus del juego
		private var sportSelected:Object;
		private var sportsMenu:MovieClip;
		private var sportsMenuButtons:Array;		
		private var currentMenuPage:int = 0;
		private var maxPages:int;		
		private var club:int;
		
		private var trainer:MovieClip;
		private var medal:MovieClip;
		private var feedbackMeters:MovieClip;
		private var feedbackTime:MovieClip;
		
		// menues standar
		private var confirmationPopup:ConfirmationPopup;
		
		public function Gui(asset:MovieClip)
		{
			super();
			this.asset = asset;
			maxPages = settings.sports.pages;
				
			createIngameGui();
			// el menu que te deja elegir el juego			
			createSportsMenu();
			createSportsMenuButtons();
			createEndGameMenu();
			
			page(currentMenuPage=0);
			
			// confirmation popup
			createConfirmationPopup();			
			// asset tiene el marco amarillo
			addChild(asset);
			
		}
		
		private function countdownEnded(e:Event):void
		{
			countdown.visible = false;
			dispatchEvent(new Event(GuiEvents.COUNTDOWN_END));						
		}
		
		private function createIngameGui():void
		{
			// boton salir 
			exitBtn = asset.getChildByName("exit") as MovieClip;
			exitBtn.text.text = api.getText(settings.gui.confirmation.exit);
			exitBtn.mouseEnabled = true;			
			exitBtn.addEventListener(MouseEvent.CLICK, onExitBtn);
			exitBtn.addEventListener(MouseEvent.ROLL_OVER, onOver);
			exitBtn.visible = false;
			
			// score
			meters = asset.getChildByName("display") as MovieClip;
			meters.label.text = api.getText(settings.gui.score);
			meters.visible = false;
			
			// time
			time = asset.getChildByName("time") as MovieClip;
			time.label.text = api.getText(settings.gui.time);
			time.visible = false;
			
			// power
			power = asset.getChildByName("power") as MovieClip;
			power.visible = false;
			power.stop();			
			
			// countdown
			countdown = asset.getChildByName("countdown") as MovieClip;
			countdown.addEventListener(Event.COMPLETE, countdownEnded);
			countdown.addEventListener("ding", function():void { audio.fx.play("click");});
			countdown.stop();
			countdown.visible = false;
			
		}
		
		private function createSportsMenu():void
		{
			sportsMenu = new McMenu();
			sportsMenu.txt_title.text = settings.gui.title;
			sportsMenu.txt_details.text = settings.gui.details;
			
			sportsMenu.backBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{ currentPage(); });
			sportsMenu.backBtn.addEventListener(MouseEvent.ROLL_OVER, onOver);
			sportsMenu.backBtn.text.text = api.getText(settings.gui.confirmation.back);
			sportsMenu.backBtn.visible = false;
			
			sportsMenu.playGameBtn.addEventListener(MouseEvent.CLICK, onPlaySport);
			sportsMenu.playGameBtn.addEventListener(MouseEvent.ROLL_OVER, onOver);
			sportsMenu.playGameBtn.text.text = api.getText(settings.gui.confirmation.play);
			sportsMenu.playGameBtn.visible = false;
			
			sportsMenu.exitBtn.addEventListener(MouseEvent.CLICK, onExitBtn);
			sportsMenu.exitBtn.addEventListener(MouseEvent.ROLL_OVER, onOver);
			sportsMenu.exitBtn.text.text = api.getText(settings.gui.confirmation.exit);
			sportsMenu.exitBtn.visible = true;
			
			sportsMenu.pg2.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{ nextPage(); });
			sportsMenu.pg2.addEventListener(MouseEvent.ROLL_OVER, onOver);
			sportsMenu.pg1.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{ prevPage(); });
			sportsMenu.pg1.addEventListener(MouseEvent.ROLL_OVER, onOver);			
			sportsMenu.nextWeek.visible = false;
			
			
			sportsMenu.instructions.visible = false;
			sportsMenu.txtClub.visible = false;
			addChild(sportsMenu);		
		}
		
		private function createEndGameMenu():void
		{	
			trainer = sportsMenu.getChildByName("trainer") as MovieClip;
			trainer.stop();
			trainer.visible = false;
			
			medal = sportsMenu.getChildByName("medal") as MovieClip;
			medal.stop();
			medal.visible = false;
			
			feedbackMeters = sportsMenu.getChildByName("fb_meters") as MovieClip; 	
			feedbackMeters.label.text = api.getText(settings.gui.score);
			feedbackMeters.visible = false;
			
			feedbackTime = sportsMenu.getChildByName("fb_time") as MovieClip;
			feedbackTime.label.text = api.getText(settings.gui.time);
			feedbackTime.visible = false;		
			
			trainerTxt(false);
		}
		
		private function createConfirmationPopup():void
		{
			confirmationPopup = new ConfirmationPopup();
			confirmationPopup.visible = false;
			confirmationPopup.addEventListener(GuiEvents.EXIT, onConfirmationExit);
			confirmationPopup.addEventListener(GuiEvents.RESUME, onResume);
			addChild(confirmationPopup);			
		}
		
		private function currentPage():void
		{
			page(currentMenuPage);
		}
		
		private function nextPage():void
		{
			currentMenuPage = (currentMenuPage + 1) % maxPages;					
			page(currentMenuPage);
		}
		
		
		private function prevPage():void
		{
			currentMenuPage = currentMenuPage - 1 < 0 ? maxPages - 1 : currentMenuPage - 1;
			page(currentMenuPage);
		}
		
		private function page(page:int):void
		{
			audio.fx.play("move");
		
			dispatchEvent(new Event(GuiEvents.SHOW_MENU));
				
			instructions(false);
			backAndPlay(false);
			ingameData(false);
			
			endGame(false);
			
			ingameData(false);
			trainerTxt(false);
			
			sportsMenu.visible = true;
			arrows(true);
			
			switch (page){
				case 0:
					buttons([0,1,2]);					
					break;
				
				case 1:
					buttons([3,4,5]);					
					break;
				
				case 2:
					buttons([6,7]);					
					break;
			}		
		}
		
		private function createSportsMenuButtons():void
		{
			// botones de los juegos
			plainRace_btn;
			
			hurdles_btn;
			
			pizza_btn;
			torta_btn;
			avioncito_btn;
			
			highJump_btn;
			longJump_btn;
			
			sportsMenuButtons = new Array();
			
			
			
			var buttonsLocations:Array = new Array();
			for(var i:int = 0; i < 3; i ++){
				buttonsLocations.push( new Point(sportsMenu["sport"+i].x,sportsMenu["sport"+i].y)); ;		
				sportsMenu.removeChild(sportsMenu["sport"+i]);	
			}
			
			
			for(var i:int = 0; i < settings.sports.sportsQty; i ++){
				
				var x:int = buttonsLocations[i % 3].x;
				var y:int = buttonsLocations[i % 3].y;
				
				var myClass:Class = getDefinitionByName("assets."+settings.sports["sport"+i].idMenuButton) as Class;
				
				var newButton:MovieClip = new myClass() as MovieClip;
				newButton.name = "sport"+i;
				newButton.x = x;
				newButton.y = y;
				newButton.visible = false;
				newButton.label.text = api.getText(settings.sports["sport"+i].name);
				
				newButton.addEventListener(MouseEvent.CLICK, onPlaySportMenu);
				newButton.addEventListener(MouseEvent.ROLL_OVER, onOver);
				
				sportsMenuButtons.push(newButton);		
				
				sportsMenu.addChild(newButton);
				newButton.visible = false;
			}
		}
		
		private function endGame(show:Boolean):void
		{
			sportsMenu.visible = show;
			trainer.visible = show;
			medal.visible = show;	
			this.feedbackMeters.visible = show;
			this.feedbackMeters.value.text = this.meters.value.text;
			this.feedbackTime.visible = show;
			this.feedbackTime.value.text = this.time.value.text;	
		}
		
		private function arrows(show:Boolean):void
		{
			sportsMenu.pg2.visible = show;
			sportsMenu.pg1.visible = show;
			sportsMenu.exitBtn.visible = show;
		}
		
		private function buttons(wichOnes:Array=null):void
		{
			for each(var btn:MovieClip in sportsMenuButtons) btn.visible = false; 
			if(wichOnes){
				for each(var id:int in wichOnes) sportsMenuButtons[id].visible = true;
			}
		}
		
		private function ingameData(show:Boolean):void
		{
			time.visible = show;
			meters.visible = show;
			power.visible = show;
			exitBtn.visible = show;
		}
		
		private function instructions(show:Boolean):void
		{
			sportsMenu.instructions.visible = show;
			sportsMenu.txtClub.visible = show;
			sportsMenu.clubPh.visible = show;
			
		}
		
		private function backAndPlay(show:Boolean):void
		{
			sportsMenu.backBtn.visible = show;
			sportsMenu.playGameBtn.visible = show;
		}
			
		private function trainerTxt(show:Boolean, text:String=""):void
		{			
			sportsMenu.txt_trainer.visible = show;
			if(text != "") sportsMenu.txt_trainer.text = text;
		}
		
		private function details(show:Boolean, text:String=""):void
		{			
			sportsMenu.txt_details.visible = show;
			if(text != "") sportsMenu.txt_details.text = text;
		}
		
		private function showTrainer(frame:String):void
		{
			trainer.visible = true;
			trainer.gotoAndStop(frame);
		}
		
		private function showMedal(frame:int):void
		{
			medal.visible = true;
			medal.gotoAndStop(frame + 1);
		}
				
		
		
		// callbacks
		// muestra el menu del deporte con sus instrucciones
		private function onPlaySportMenu(e:Event):void
		{						
			audio.fx.play("click");
			
			ingameData(false);			
			buttons(null);
			arrows(false);
			details(false);
	
			backAndPlay(true);
			instructions(true);
			
			sportSelected = settings.sports[e.currentTarget.name];			
			sportsMenu.txt_details.text = sportSelected.name;			
			sportsMenu.clubPh.label.text = api.getText(settings.teams[club]);
			sportsMenu.clubPh.gotoAndStop(club);
			sportsMenu.instructions.gotoAndStop(sportSelected.idMenuButton);
			sportsMenu.instructions.txt_inst.text = api.getText(sportSelected.inst);
		}
		
		private function onPlaySport(e:Event):void
		{
			instructions(false);	
			sportsMenu.visible = false;			
			ingameData(true);
			
			dispatchEvent(new Event(GuiEvents.NEW_MATCH));		
		}
			
		private function endgameMenuConfig(medal:int):void{			
			
			switch(medal)
			{
				case Sport.BADGE_LOOSER:
				{
					showTrainer("lose");
					showMedal(Sport.BADGE_LOOSER);
					trainerTxt(true, api.getText(settings.gui.win.loose));
					break;
				}
				case Sport.BADGE_BRONCE:
				{
					showTrainer("win");
					showMedal(Sport.BADGE_BRONCE);
					trainerTxt(true, api.getText(settings.gui.win.win));
					
					break;
				}
				case Sport.BADGE_SILVER:
				{
					showTrainer("win");
					showMedal(Sport.BADGE_SILVER);
					trainerTxt(true, api.getText(settings.gui.win.win));
					break;
				}
				case Sport.BADGE_GOLD:
				{
					showTrainer("win");
					showMedal(Sport.BADGE_GOLD);
					trainerTxt(true, api.getText(settings.gui.win.win));
					break;
				}
					
				default:
				{
					break;
				}
			}			
		}
				
		private function onOver(e:Event):void
		{
			audio.fx.play("rollover");
		}
		
		private function onExitBtn(e:Event):void
		{
			audio.fx.play("click");
			confirmationPopup.visible = true;
			dispatchEvent(new Event(GuiEvents.PAUSE));
		}
		
		private function onConfirmationExit(e:Event):void 
		{
			audio.fx.play("click");
			dispatchEvent(new Event(GuiEvents.EXIT));
		}
		
		private function onResume(e:Event=null):void
		{
			audio.fx.play("click");
			confirmationPopup.visible = false;
			dispatchEvent(new Event(GuiEvents.RESUME));
		}
		
		// public:
		// esto es feo pero práctico. la gui le pasa el objeto del juego al game
		public function get currentSport():Object
		{
			return sportSelected;
		}
		
		public function setClub(club:String):void
		{
			var clubINT:int;
			switch (club) {
				case "megaElastico":
					clubINT = 0;
					break;
				case "ultraRapido":
					clubINT = 1;
					break;
				case "superAgil":
					clubINT = 2;
					break;
			}
			this.club = clubINT;
		}
		
		public function showCountDown():void
		{
			countdown.gotoAndPlay(2);
			countdown.visible = true;			
		}
		
		public function reset():void
		{
			exitBtn.visible = true;
		}
		
		public function setTime(currenttime:String):void
		{
			time.value.text = currenttime;
		}
		
		public function setPower(pow:Number):void
		{
			this.power.gotoAndStop( Math.floor(Utils.map(pow, 0, 1, 1, this.power.totalFrames)));	
		}
		
		public function setMeters(score:String):void
		{
			this.meters.value.text = score;
		}
		
		public function setMedal(medal:int):void{
			ingameData(false);
			endGame(true);			
			endgameMenuConfig(medal);
		}
	}
}