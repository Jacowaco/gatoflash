package game.sports 
{
	import assets.*;
	
	import com.qb9.flashlib.geom.Vector2D;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import game.Enemy;
	import game.LevelEvents;
	import game.MovingObject;
	import game.Sport;
	
	import utils.Utils;
	
	
	public class Metres100 extends Race 
	{
		
		public function Metres100() 
		{
			super();
			finalMetres = 100;			
			
		}
	}

}