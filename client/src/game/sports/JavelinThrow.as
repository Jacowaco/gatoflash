package game.sports 
{
	import assets.*;
	
	
	public class JavelinThrow extends DiscusThrow 
	{
		
		public function JavelinThrow() 
		{
			super();
			
			ballMovieClip = assets.javelinMC;
			rotate = true;
			
			throwMeters = 10;
		}
		
		override protected function startPlayer():void
		{
			player.start(false);
		}
	}

}