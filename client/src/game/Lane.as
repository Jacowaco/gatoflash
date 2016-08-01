package game
{
	import flash.geom.Point;

	// mantiene la referencia del corredor y un array de vallas
	public class Lane
	{
		public var avatar:Avatar;
		public var hurdles:Array;
		public var loc:Point;
		public var name:String;
		
		public function Lane()
		{
			hurdles = new Array();
		}
	}
}