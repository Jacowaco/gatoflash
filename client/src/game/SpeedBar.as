package game 
{
	import com.qb9.flashlib.easing.Tween;
	import com.qb9.flashlib.tasks.Loop;
	import com.qb9.flashlib.tasks.Sequence;
	import flash.display.MovieClip;
	import gameobject.GameObject;
	
	
	public class SpeedBar extends GameObject 
	{
		private var TIME:int = 500;
		private var _percentage:Number;
		private var barMax:Number;
		private var loop:Loop;
		private var looping:Boolean;
		
		public function SpeedBar(mc:MovieClip=null) 
		{
			super(mc);
			
			debug(false);
			barMax = asset.barFill.width;
		}
		
		public function reset():void
		{
			stop();
			percentage = 0;
		}
		
		public function start():void
		{
			if (looping) return;
			looping = true;
			var right:Tween = new Tween(this, TIME, { percentage:1 }, { transition:"EaseIn" } );
			var left:Tween = new Tween(this, TIME, { percentage:0 }, { transition:"EaseOut" } );
			var sequence:Sequence = new Sequence(right, left);
			loop = new Loop(sequence);
			//var loop:Loop = new Loop(right);
			Game.taskRunner().add(loop);
		}
		
		public function stop():void
		{
			if (!looping) return;
			looping = false;
			Game.taskRunner().remove(loop);
		}
		
		public function get percentage():Number
		{
			return _percentage;
		}
		
		public function set percentage(_v:Number):void
		{
			_percentage = _v;
			asset.barFill.width = _v * barMax;
		}
	}

}