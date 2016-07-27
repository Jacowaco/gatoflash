package game.sports 
{
	
	public class HighJump extends LongJump 
	{
		
		public function HighJump() 
		{
			super();
			
		}
		
		override public function create():void 
		{
			super.create();
			
			player.setJumpVariables(250, 100, 200);
		}
		
	}

}