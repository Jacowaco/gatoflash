package game 
{
	import assets.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	import mx.charts.chartClasses.DualStyleObject;
	
	public class Background extends Sprite 
	{
		private var obj1:MovieClip;
		private var obj2:MovieClip;
		private var offset:int = 0;
		private var bgwidth:int = 800;
		
		private var guys:Array = [	
			hincha1,
			hincha12,
			hincha3,
			hincha4,
			hincha6,
			hincha8,
			]

		private var deadGuys:Array = [	
			botHuesitos1,
			botHuesitos2,
			botHuesitos3,
			botHuesitos4
			
		]
		
		private var sleepingGuys:Array = [	
			hinchaDormido1,
			hinchaDormido2,
			hinchaDormido3,
			hinchaDormido4
			
		]
			
		
			
		public function Background() 
		{
			this.obj1 = new assets.backgroundMC();
			this.obj2 = new assets.backgroundMC();
			randomizeSign(obj1);
			randomizeSign(obj2);
			randomizeFans(obj1);
			randomizeFans(obj2);
			
			addChild(obj1);
			addChild(obj2);
			reset();
			
			bot1;
			bot2;
			bot3;
			bot4;
			
			hincha1;
			hincha12;
			hincha3;
			hincha4;
			hincha6;
			hincha8;
			
			botHuesitos1;
			botHuesitos2;
			botHuesitos3;
			botHuesitos4;
			
			hinchaDormido1;
			hinchaDormido2;
			hinchaDormido3;
			hinchaDormido4;
			
		}
		
		public function reset():void
		{
			obj2.y = obj1.y;
			obj1.x = -20;
			obj2.x = obj1.x + bgwidth;
		}
		
		private var pposition:Number = 0;
		
		public function follow(camera:Number):void
		{			
			var delta:Number = pposition - camera;
			pposition = camera;
			obj1.x -= delta;
			obj2.x -= delta;
			if (obj1.localToGlobal(new Point(0, 0)).x + bgwidth < 0 )
			{
				var tmp:MovieClip = obj1;
				obj1 = obj2;
				obj2 = tmp;
				obj2.x = obj1.x + bgwidth - offset;
				randomizeSign(obj2);
				randomizeFans(obj2);
			}
		}
		
		private function randomizeSign(obj:MovieClip):void
		{
			obj.sign.gotoAndStop(1 + Math.floor(Math.random() * obj.sign.totalFrames));
		}
		
		private var sleepingGuysChance:Number = 0;
		
		private function randomizeFans(obj:MovieClip):void{
			
			for(var ph:int = 0 ; ph < obj.numChildren; ph++){
				if(getQualifiedClassName(obj.getChildAt(ph)) == "assets::hinchaPh"){
					var reference:MovieClip = obj.getChildAt(ph) as MovieClip;
					while(reference.numChildren > 0 ) reference.removeChildAt(0);
					var newGuy:MovieClip = Math.random() < sleepingGuysChance ? newSleepingGuy() : newRandomGuy();
					reference.addChild(newGuy);
					 
				}
			}
		}
		
		public function setSleepingGuysChance(chance:Number):Number
		{
			return sleepingGuysChance = chance;
		}
		
		private function newRandomGuy():MovieClip{			
			return new guys[Math.floor(Math.random() *guys.length)];
		}
		
		private function newRandomDeadGuy():MovieClip{			
			return new deadGuys[Math.floor(Math.random() *deadGuys.length)];
		}
		
		private function newSleepingGuy():MovieClip
		{
			return new sleepingGuys[Math.floor(Math.random() *sleepingGuys.length)];
		}
		
	}
	
}