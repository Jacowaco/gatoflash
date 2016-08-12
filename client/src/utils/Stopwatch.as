package utils
{
	import flash.events.*;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	public class Stopwatch extends EventDispatcher
	{
		
		public static var LAP:String = "lap";
		public static var TIMEOUT:String = "timeout";
		
		public static const FORWARD:int = 1;
		public static const REVERSE:int = -1;
		
		private var mode:int = REVERSE;
		
		private var timer:Timer;
		private var delay:int;
		private var isPaused:Boolean;
		
		private var h:int;
		private var m:int;
		private var s:int;
		
		private var lapTime:int;
		
		public function Stopwatch( repeatCount:int=0)
		{
			delay = 1000;
			if(timer) timer.removeEventListener(TimerEvent.TIMER, onTick);			
			timer = new Timer(delay, repeatCount);			
			reset();
			timer.addEventListener(TimerEvent.TIMER, onTick);
			timer.start();
			isPaused = true;
			mode = FORWARD;
			
		}
		
		public function set(min:int, sec:int):void
		{
			m = min;
			s = sec;
		}
		
		public function setMode(mode:int):void
		{
			this.mode = mode;
		}
		
		
		private function onTick(e:TimerEvent):void{
			if(!isPaused){
				updateClock();
			}			
		}
		
		public function newLap():void {
			dispatchEvent(new Event(Stopwatch.LAP));
		}
		
		
		public function setLapTime(secs:int):void{
			lapTime = secs;
		}
		
		public function go():void
		{
			isPaused = false;
		}
		
		public function pause():void
			
		{
			isPaused = true;
		}
		
		public function getIntSec():int
		{
			return s;
		}
		
		private function updateClock():void{
			
			s += mode;
		
			if(mode == REVERSE) {
				if(s == 0 && m == 0) {
					dispatchEvent(new Event(Stopwatch.TIMEOUT));
					return;
				}
				if(s == 0){
					s = 60;					
					m += mode;
					if(m == 0){
						m = 60;
						h += mode;						
					}
				}
				
			}else{
				if(s == 60){
					s = 0;
					m += mode;
					if(m == 60){
						m = 0;
						h += mode;						
					}
				}	
			}
		}
		
		public static function toms(tics:int):String{		
			var secs:int = tics % 60;
			var min:int = (tics / 60);	
			return min+":"+secs;
		}
		
		 public function reset():void{
			h = m = s = 0;
		}
		
		public function hms():String{
			var hms:String ="";
			if(m < 10){
				hms = h+":0"+m;
			}else{
				hms = h+":"+m;
			}
			
			if(s < 10){
				hms +=":0"+s;
			}else{
				hms +=":"+s;
			}
		//	 var hms = h+":"+m+":"+s;
			return hms;
		}

		
		public function ms():String{
			var ms:String ="";
			if(m < 10){
				ms = "0"+m;
			}else{
				ms = m.toString();
			}
			
			if(s < 10){
				ms +=":0"+s;
			}else{
				ms +=":"+s;
			}
			//	 var hms = h+":"+m+":"+s;
			return ms;
		}
	
		public function secs():int{
			return m*60+s;
		}
	}
}