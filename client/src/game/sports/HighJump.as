package game.sports 
{
	import assets.*;
	
	import avatar.corredorMC;
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	
	import game.Avatar;
	
	public class HighJump extends Sport
	{
		
		private var line:MovieClip;
		
		public function HighJump() 
		{
			super();
			create();	
		}
		
		override public function initialize():void
		{
			start();	
		}
		
		override protected function create():void 
		{
			
			levelDefinition = new assets.highJump;
			line = levelDefinition.line;
			camera.addChild(line);
			
			player = new Avatar();			
			player.x = line.x - 100;
			player.y = line.y;
			player.setMode(Avatar.PLAYER);					
			addChild(player);
			
		}
		
		override public function update():void
		{
		
		}
		
		override public function onKeyDown(key:KeyboardEvent):void
		{
		
		}
		
		override public function onKeyUp(key:KeyboardEvent):void
		{
		
		}
		
	}
	
}