package game 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import gameobject.GameObject;
	
	
	public class Sector extends GameObject 
	{
		public var num:int;
		public var id:String;
		private var onClick:Event;
		
		public function Sector(mc, _player:Boolean) 
		{
			super(mc);
			
			if (_player)
			{
				onClick = new Event("clicked");
				mc.addEventListener(MouseEvent.CLICK, clicked);
			}
		}
		
		public function clicked(e:MouseEvent):void
		{
			dispatchEvent(onClick);
		}
		
	}

}