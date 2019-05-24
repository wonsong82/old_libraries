package won
{
	import fl.transitions.easing.*;
	
	public class W
	{
		private static var tweenArray:Array = [];
			
		
		public static function remove($tw:Object):void
		{			
			for (var i:int=0; i<tweenArray.length; i++){
				if (tweenArray[i][1] == $tw) tweenArray.splice(i, i+1);
			}
		}
			
		private static function defineEase($e:String = null):Function
		{			
			var ease:Function;
			if ($e == null) ease = None.easeNone;
			else if ($e == "none") ease = None.easeNone;
			else if ($e == "regularIn") ease = Regular.easeIn;
			else if ($e == "regularOut") ease = Regular.easeOut;
			else if ($e == "regularInOut") ease = Regular.easeInOut;
			else if ($e == "strongIn") ease = Strong.easeIn;
			else if ($e == "strongOut") ease = Strong.easeOut;
			else if ($e == "strongInOut") ease = Strong.easeInOut;
			else if ($e == "backIn") ease = Back.easeIn;
			else if ($e == "backOut") ease = Back.easeOut;
			else if ($e == "backInOut") ease = Back.easeInOut;
			else if ($e == "bounceIn") ease = Bounce.easeIn;
			else if ($e == "bounceOut") ease = Bounce.easeOut;
			else if ($e == "bounceInOut") ease = Bounce.easeInOut;
			else if ($e == "elasticIn") ease = Elastic.easeIn;
			else if ($e == "elasticOut") ease = Elastic.easeOut;
			else if ($e == "elasticInOut") ease = Elastic.easeInOut;
			else ease = None.easeNone;
			
			return ease;
		}
		
		
		
		
//-- Available Static Methods -----------------------------------------------------------------------------------------
		public static function tween($t:Object, $s:Number, $p:Object):void
		{		
			var t:Tween = new Tween($t, $s, $p, defineEase($p.easing));
			tweenArray.push([$t, t]);
		}
		
		public static function stopTween($tar:Object):void
		{
			for (var i:int=0; i<tweenArray.length; i++){
				if (tweenArray[i][0] == $tar){ 
					tweenArray[i][1].stop();				
				}
			}
		}
		
		public static function traceRGB($color:Number):Object
		{
			var c:Number = $color;
			var r = Math.floor(c/0x10000);
			var g = Math.floor((c - Math.floor(c/0x10000)*0x10000) / 0x100);
			var b = c -(Math.floor(c/0x100)*0x100);
			var o:Object = new Object();
			o.red = r;
			o.green = g;
			o.blue = b;
			return o;
		}
		
		public static function shuffle(a,b):int 
		{
			var num:int = Math.round(Math.random()*2)-1;
			return num;
		}
		
		
//-- Help Command -----------------------------------------------------------------------------------------------------
		public static function get help():*
		{
			var t:String = "--------- Class:W version=\"1.0\" -----------\n";
			t += "\n";
			t += "W.tween(target, time, parameters);\n";
			t += "//Tweening Methods. For more detail, -> W.tweenhelp; \n";
			t += "\n";
			t += "W.traceRGB(color);\n";
			t += "//Parse R,G,B from Color. For more detail, -> W.traceRGBhelp; \n";			
			trace (t);
		}
		
		public static function get traceRGBhelp():*
		{
			var t:String = "------- W.traceRGB(color:Number):Object -------------------\n";
			t += "This function returns the object with three params. \n";
			t += "W.traceRGB(color).red; returns Red value from the color. \n";
			t += "W.traceRGB(color).green; returns Green value from the color. \n";
			t += "W.traceRGB(color).blue; returns Blue value from the color.";
			trace (t);
		}
		
		public static function get tweenhelp():*
		{
			var t:String = "------- W.tween(target:Object, time:Number, parameters:object):void ---- \n";
			t += "W.stopTween(target); -- Stops the tweening of the target.\n";
			t += "Avaialable Parameters : \n";
			t += "delay : Number of Seconds to delay start the tweening.\n";
			t += "onComplete: Function that would be executed once the tweening is done.\n";
			t += 'easing: "none", "regularIn", "regularOut", "regularInOut", "strongIn", "stringOut", "strongInOut", \n';
			t += '\t "backIn", "backOut", "backInOut", "bounceIn", "bounceOut", "bounceInOut", "elasticIn", "elasticOut", "elasticInOut"\n';
			t += 'x, y, z, rotation, rotationX, rotationY, rotationZ, width, height, alpha, scaleX, scaleY, scaleZ\n';
			t += 'tint:{color, saturation} <-- saturation must be between 0-1, color 0xRRGGBB format. \n';
			t += 'tint:"original" <-- back to original color; \n';
			t += 'example: \n';
			t += 'W.tween(target, 2, {tint:{0xff6600, saturation:.8}}); //tint the color with .8 saturation for 2 sec \n';
			t += 'W.tween(target, 2, {tint:"original"}); //remove the tint effect for 2 sec \n';
			t += 'W.tween(target, 1, {x:300, width:500, easing:"regularOut", delay:2}); //x to 300, width to 500 for 1 sec with regularOut easing and delay starting 2 sec \n';
			t += 'W.tween(target, 1, {alpha:.5, onComplete:nextFunction}); //alpha to .5 for 1 sec and when done execute nextFunction();\n';
			trace (t);
		}
	
	}
}