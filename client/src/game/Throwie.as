package game 
{
	import com.qb9.flashlib.easing.Tween;
	import com.qb9.flashlib.tasks.Parallel;
	import com.qb9.flashlib.tasks.Sequence;
	import com.qb9.flashlib.tasks.TaskEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import game.sports.Sport;
	
	
	public class Throwie extends Sprite  
	{

		public static const ON_REACH:String = "onReach";
		private var DISTANCE_Y:int = 120;
		public var shot:Boolean;
		private var mc:MovieClip;
		
		public function Throwie(mc:MovieClip) 
		{
			this.mc = mc;
			addChild(mc);
			mc.asset.stop();			
			shot = false;
		}

		public function get asset():MovieClip
		{
			return mc.asset;
		}
		
		public function shoot(distance:Number, yoffset:Number, _right:Boolean=true):void
		{
			if (shot) return;
			shot = true;
			distance = distance * Sport.UNITS_PER_METER - 1; 
			var time:Number = Math.max(Math.abs(distance), 500);
			
			if(!_right) {
				 distance = -300;
				 time = 1000;
			}
			
			var startX:Tween = new Tween(this, time, { x: x + distance / 2 }, { transition:"linear" } );
			var startY:Tween = new Tween(this, time, { y: y - DISTANCE_Y }, { transition:"Quad.easeOut" } );
			
			var endX:Tween   = new Tween(this, time, { x: x + distance },     { transition:"linear" } );
			var endY:Tween   = new Tween(this, time, { y: y + yoffset },      { transition:"Quad.easeIn" } );
			
			var inmov:Parallel = new Parallel(startX, startY);
			var outmot:Parallel = new Parallel(endX, endY);
			
			var seq:Sequence = new Sequence(inmov, outmot);
			seq.addEventListener(TaskEvent.COMPLETE, function(e:Event):void{dispatchEvent(new Event(ON_REACH));});
			Game.taskRunner().add(seq);

		}		
		
		
		public function animate():void
		{
			mc.asset.gotoAndPlay(1);
		}
		
		
		public function stop():void
		{
			mc.asset.stop();
		}
		public function getMeters():int
		{
			return this.x ;
		}
		
	}

}