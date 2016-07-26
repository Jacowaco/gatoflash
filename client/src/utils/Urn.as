package utils
{
	import com.qb9.flashlib.utils.ArrayUtil;
	import flash.events.EventDispatcher;
	import flash.events.Event;

	public class Urn extends EventDispatcher
	{
		private var elements:Array;
		private var qty:int;
		public static const OVERFLOW:String = "overflow";
		
		public function Urn()			
		{			
		}
		
		public function populate(elements:Array):void
		{
			if(this.elements && this.elements.length > 0) elements = new Array();
			this.elements = ArrayUtil.shuffle(elements);
			this.qty = elements.length;
		}
		
		public function isEmpty():Boolean
		{
			return elements.length == 0 ? true : false; 
		}
		 
		public function choice():*
		{			
			if(elements.length == 0) {
				return null;
			}
			return elements.shift(); 	
		}
	}
}