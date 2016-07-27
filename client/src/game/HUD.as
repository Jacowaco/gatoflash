package game 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	public class HUD extends Sprite 
	{
		private var textMeters:TextField;
		
		public function HUD() 
		{
			super();
			
			var format:TextFormat = new TextFormat("Arial", 24);
			
			textMeters = new TextField();
			textMeters.x = 22;
			textMeters.y = 20;
			textMeters.defaultTextFormat = format;
			//textMeters.setTextFormat(format);
			textMeters.textColor = 0xffffff;
			textMeters.text = "0 mts";
			addChild(textMeters);
		}
		
		public function updateMeters(_v:int):void
		{
			textMeters.text = _v + " mts";
		}
		
	}

}