package popups
{
	import com.qb9.flashlib.events.QEvent;
	import com.qb9.flashlib.utils.DisplayUtil;
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import popups.*;
	
	import ui.GuiEvents;
	
	import utils.Utils;

	public class InstructionsPopup extends MovieClip
	{
		private var asset:MovieClip;
		private var currentPage:int = 1;
		private var maxPages:int = 2;
		private var txtDetail:TextField;
		
		public function InstructionsPopup()
		{
			this.asset = new popups.McInstrucciones;	
			addChild(asset);
			init();
		}
		
		private function init() : void
		{
			asset.gotoAndStop(currentPage);
			
			asset.prevBtn.addEventListener(MouseEvent.CLICK, onPrev);			
			asset.prevBtn.addEventListener(MouseEvent.ROLL_OVER, mouseOver);
			
			asset.nextBtn.addEventListener(MouseEvent.CLICK, onNext);
			asset.nextBtn.addEventListener(MouseEvent.ROLL_OVER, mouseOver);
			
			// boton de jugar
			asset.playGame.text.text = api.getText(settings.gui.confirmation.play);
			asset.playGame.addEventListener(MouseEvent.CLICK, onPlay);
			asset.playGame.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			(asset.playGame.text as TextField).mouseEnabled = false;			
			
			asset.txt_title.text =  api.getText(settings.gui.instructions.title);
			txtDetail = asset.txt_details;
			txtDetail.text = api.getText(settings.gui.instructions.details[currentPage -1]);
			
		}
		
		private function onNext(e:MouseEvent):void{
			audio.fx.play("bInstruc");
			currentPage ++;
			currentPage = currentPage > maxPages ? 1 : currentPage;
			asset.gotoAndStop(currentPage);			
			txtDetail.text = api.getText(settings.gui.instructions.details[currentPage-1]);
			logger.info(settings.gui.instructions.details[currentPage-1]);
		}
		
		private function onPrev(e:MouseEvent):void{
			audio.fx.play("bInstruc");
			currentPage --;
			currentPage = currentPage < 1  ? maxPages : currentPage;			
			asset.gotoAndStop(currentPage);
			txtDetail.text = api.getText(settings.gui.instructions.details[currentPage-1]);	
			logger.info(settings.gui.instructions.details[currentPage-1]);
		}
		
		
		private function mouseOver(e:MouseEvent) : void
		{
			audio.fx.play("rollover");
		}
		
		private function onPlay(e:MouseEvent) : void
		{
			audio.fx.play("click");			
			dispatchEvent(new Event(GuiEvents.PLAY));
		}
		
	}
}