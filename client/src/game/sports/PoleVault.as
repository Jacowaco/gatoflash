package game.sports 
{
	import assets.*;
	
	import com.qb9.flashlib.geom.Vector2D;
	
	import flash.display.MovieClip;
	
//	import game.MovingObject;
	
	public class PoleVault extends LongJump 
	{
		private var pole:MovieClip;
		private var poleOffset:Vector2D = new Vector2D(20, -30);
		private var jumpBar:MovieClip;
		
		public function PoleVault() 
		{
			super();
			
		}
		
		override public function create():void 
		{
			super.create();
			
			pole = new assets.poleMC();
//			pole.debug(false);
			pole.asset.rotation = -40;
			camera.addChild(pole.asset);
			
//			player.setJumpVariables(200, 100, 300);
		}
		
		//override public function reset():void 
		//{
			//super.reset();
			//
			//pole.loc = new Vector2D(100, 100);
		//}
		
//		override protected function addThingsBeforePlayer():void 
//		{
//			super.addThingsBeforePlayer();
//			
//			jumpBar = new MovingObject(new assets.jumpBarMC);
////			jumpBar.debug(false);
//			jumpBar.loc = new Vector2D(start.loc.x + throwMeters * UNITS_PER_METER, start.loc.y);
////			jumpBar.run();
//			camera.addChild(jumpBar.asset);
//		}
		
		override public function update():void 
		{
			super.update();
			
//			pole.loc = player.loc.add(poleOffset);
//			pole.run();
		}
		
	}

}