package popups
{
	
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import popups.*;
	
	import ui.GuiEvents;

	public class ConfirmationPopup extends MovieClip
	{
		private var confirmationPopup:MovieClip;
	
		public function ConfirmationPopup()
		{
			confirmationPopup = new popups.McConfirmation;
			addChild(confirmationPopup);
			confirmationPopup.text.text = api.getText(settings.gui.confirmation.dialog);
			confirmationPopup.exit.text.text = api.getText(settings.gui.confirmation.exit);
			confirmationPopup.cancel.text.text = api.getText(settings.gui.confirmation.cancel);								
			
			confirmationPopup.exit.addEventListener(MouseEvent.CLICK, onExit)
			confirmationPopup.cancel.addEventListener(MouseEvent.CLICK, onResume)
				
			confirmationPopup.exit.addEventListener(MouseEvent.ROLL_OVER, onOver)
			confirmationPopup.cancel.addEventListener(MouseEvent.ROLL_OVER, onOver)		

		}

		private function onOver(e:Event):void
		{
			audio.fx.play("rollover");
		}

		private function onExit(e:Event):void
		{
			dispatchEvent(new Event(GuiEvents.CONFIRMATION_EXIT));
			audio.fx.play("click");
		}
		
		private function onResume(e:Event):void
		{
			dispatchEvent(new Event(GuiEvents.RESUME));
			audio.fx.play("click");
		}
	}
}