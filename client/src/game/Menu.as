package game 
{
	import assets.btnMenuMC;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	
	public class Menu extends Sprite 
	{
		private var btns:Vector.<btnMenuMC>;
		public function Menu() 
		{
			super();
			
			
			btns = new Vector.<btnMenuMC>();
			for (var i:int = 0; i < 10; i++)
			{
				btns[i] = new btnMenuMC();
				btns[i].x = (i < 5) ? 100 : 460;
				btns[i].y = 70 + (i % 5) * 70;
				addChild(btns[i]);
				
				//var text:TextField = new TextField();
				//btns[i].upState.addChild(text);
				//text.text = Menu.getSport(i);
				//trace(btns[i].sportname);
				btns[i].sportname.text = getSportName(i);
				//trace(getSport(i));
				btns[i].name = getSportID(i);
				btns[i].addEventListener(MouseEvent.CLICK, btnClicked);
			}
			
		}
		
		public function btnClicked(e:MouseEvent):void
		{
			//trace(e.currentTarget.name);
			dispatchEvent(new DataEvent("BTN_CLICKED", false, false, e.currentTarget.name));
		}
		
		public static function getSportName(n:int):String
		{
			switch (n)
			{
				case 0:
					return "100 metros lisos"
					break;
				case 1:
					return "Salto de longitud"
					break;
				case 2:
					return "Lanzamiento de peso"
					break;
				case 3:
					return "Salto de altura"
					break;
				case 4:
					return "110 metros vallas"
					break;
				case 5:
					return "400 metros lisos"
					break;
				case 6:
					return "Lanzamiento de disco"
					break;
				case 7:
					return "Salto con pértiga"
					break;
				case 8:
					return "Lanzamiento de jabalina"
					break;
				case 9:
					return "1500 metros lisos"
					break;
				default:
					return "100 metros lisos"
					break;
			}
		}
		
		public static function getSportID(n:int):String
		{
			switch (n)
			{
				case 0:
					return "Metres100"
					break;
				case 1:
					return "LongJump"
					break;
				case 2:
					return "ShotPut"
					break;
				case 3:
					return "HighJump"
					break;
				case 4:
					return "Hurdles"
					break;
				case 5:
					return "Metres400"
					break;
				case 6:
					return "DiscusThrow"
					break;
				case 7:
					return "PoleVault"
					break;
				case 8:
					return "JavelinThrow"
					break;
				case 9:
					return "Metres1500"
					break;
				default:
					return "Metres100"
					break;
			}
		}
		
	}

}