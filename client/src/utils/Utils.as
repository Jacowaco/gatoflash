package utils
{
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class Utils
	{
		public function Utils()
		{
		}
		

		
		
		public static function findInArray(source:Array, filter:Function, startPos:int = 0):int{
			var len:int = source.length;
			for (var i:int = startPos; i < len; i++) 
				if (filter(source[i],i,source)) return i;
			return -1;
		}
		
		
		public static function map(v:Number, a:Number, b:Number, x:Number = 0, y:Number = 1):Number {
			return (v == a) ? x : (v - a) * (y - x) / (b - a) + x;
		}
		
		public static function debugDisplayObject(o:DisplayObject):void{
			
			if(o is Sprite || o is MovieClip){
				trace("x: " + o.x);
				trace("y: " + o.y);
				trace("w: " + o.width);
				trace("h: " + o.height);
			}else{
				trace("el objeto no es debugueable");
			}
			
		}
		
		public static function showChildren(dp:DisplayObjectContainer, indentLevel:int):void{
		
			for(var i:int = 0 ; i < dp.numChildren ; i ++){
				var obj:DisplayObject = dp.getChildAt(i);
				if(obj is DisplayObjectContainer){					
					trace(padIndent(indentLevel) + obj.name, " : "+obj);
					Utils.showChildren(obj as DisplayObjectContainer, indentLevel + 1);
				}else{
					trace(padIndent(indentLevel) + obj.name, " : "+obj);	
				}
			}		
		}
		
		private static function padIndent(j:int):String{
			var indent:String = "";
			for(var i:int = 0; i < j; i++){
				indent += "   ";
			}
			return indent; 
		}
		
		public static function ease(current:Number, prev:Number, howFast:Number):Number{
			var n:Number = (current * howFast) + (prev * (1 - howFast));   
			return n;
		}
		
		public static function constrain(amt:Number, low:Number, high:Number):Number {
			return (amt < low) ? low : ((amt > high) ? high : amt);
		}
		
		public static function getClass(obj:Object):Class {
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
		
		public static function getFrameByLabel(frameLabel:String, mc:MovieClip ):int
		{
			var scene:Scene = mc.currentScene;
			var frameNumber:int = -1;
			
			for( var i:int ; i < scene.labels.length ; ++i )
			{
				if( scene.labels[i].name == frameLabel )
					frameNumber = scene.labels[i].frame;
			}
			
			return frameNumber;
		}
		
		public static function minMaxRandom(minimo:int, maximo:int):int{
			return Math.floor(Math.random() * (maximo - minimo + 1)) + minimo;
		}
		
		public static function getProperties(object:Object):Array
		{
			var a:Array = new Array();
			
			for ( var o : * in object ){
				trace( "object has property: " + o );
				a.push(String(o));
			}
			return a;
		}
		
		public static function clone( source:Object ):* 
		{ 
			var myBA:ByteArray = new ByteArray(); 
			myBA.writeObject( source ); 
			myBA.position = 0; 
			return( myBA.readObject() ); 
		}
		
		public static function parseJSON(o:*, spaces:int = 1):String {
			var str:String = "";
			if(getTypeof(o) == "object") {
				str += "{\n";
				for(var i:* in o) {
					str += getSpaces(spaces) + i + "=";
					if(getTypeof(o[i]) == "object" || getTypeof(o[i]) == "array") {
						str += parseJSON(o[i], spaces + 1) + "\n";
					} else {
						var type:String = getTypeof(o[i]);
						if(type == "string") {
							str += "\"" + o[i] + "\"\n";
						} else if(type == "number") {
							str += o[i] + "\n";
						}
					}
				}
				str += getSpaces(spaces - 1 < 0 ? 0 : spaces - 1) + "}";
			} else if(getTypeof(o) == "array") {
				str += "[\n";
				var n:int = o.length;
				for(i=0; i<n; i++) {
					str += getSpaces(spaces) + "[" + i + "]=";
					if(getTypeof(o[i]) == "object" || getTypeof(o[i]) == "array") {
						str += parseJSON(o[i], spaces + 1) + "\n";
					} else {
						type = getTypeof(o[i]);
						if(type == "string") {
							str += "\"" + o[i] + "\"";
						} else if(type == "number") {
							str += o[i];
						}
						str += "\n";
					}
				}
				str += getSpaces(spaces - 1 < 0 ? 0 : spaces - 1) + "]";
			}
			return str;
		}
		
		public static function getSpaces(n:int):String {
			var str:String = "";
			for(var i:int=0; i<n; i++) {
				str += "  ";
			}
			return str;
		}
		
		public static function getTypeof(o:*):String {
			return typeof(o) == "object" ? (o.length == null ? "object" : "array") : typeof(o);
		}
		
 		public static function swapItemsInArray(array:Array, item1:Object, item2:Object):void
		{
			var item1pos:int = array.indexOf(item1);
			var item2pos:int = array.indexOf(item2);
			
			if ((item1pos != -1) && (item2pos != -1))
			{
				var tempItem:Object = array[item2pos];
				array[item2pos] = array[item1pos];
				array[item1pos] = tempItem;
			}
		}

		public static function degToRad(deg:Number):Number
		{
			// Degrees to Radians
			return  deg * Math.PI / 180;	
		}
		
		public static function radToDeg(rad:Number):Number
		{
			// Radians to Degrees
			return  rad * 180 / Math.PI;	
		}
		
		public static function easeInOutQuad (t:Number, b:Number, c:Number, d:Number):Number{
			t /= d/2;
			if (t < 1) return c/2*t*t + b;
			t--;
			return -c/2 * (t*(t-2) - 1) + b;
		};

//		public static function bitmapFromDisplayObject(bound:Rectangle, object:DisplayObject):Bitmap
//		{			
//			var bd1:BitmapData = new BitmapData(bound.width,bound.height,true, 0x00FFFFFF);
//			var mat:Matrix = new Matrix();
//			mat.translate(bound.width / 2, bound.height / 2 );
//			bd1.draw(object, mat);
//			var bitmap1:Bitmap = new Bitmap(bd1);			
//			return bitmap1;
//		}

		public static function shuffleVector(array:Vector.<int>):Boolean
		{
			var i:uint = array.length;
			
			if (i < 2)
				return false;
			
			var j:uint;
			var o:int;
			while (--i)
			{
				j = Math.floor(Math.random() * (i + 1));
				o = array[i];
				array[i] = array[j];
				array[j] = o;
			}
			
			return true;
		}
	}
}