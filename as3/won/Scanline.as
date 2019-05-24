/* Program: Scanline.as
 * Desc:	params [
 					scanline:String = url of the pattern image file
					scanlineX:Number = the X location where the scanline will be at;
					scanlineY:Number = the Y locatino where the scanline will be at;
					scanlineWidth:Number = the value of the width either in pixel or percent.
					scanlineHeight:Number = the value of the height either in pixel or percent.
					percent:Boolean = if true, treat the width and height value as in percent.
					]
			This Class is a sprite class that generates the multiple pattern img file to desinated size and location.
			If the sizes are in percent, then adjust the size when the stage is resized.
 */

package won
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	public class Scanline extends Sprite
	{		
		private var thisX:Number;
		private var thisY:Number;
		private var thisWidth:Number;
		private var thisHeight:Number;		
		private var bitmap:BitmapData;		
		private var thisTarget:Object;
				
		public function Scanline(scanline:String, scanlineX:Number, scanlineY:Number, scanlineWidth:Number, scanlineHeight:Number)
		{			
			thisX = scanlineX;
			thisY = scanlineY;
			thisWidth = scanlineWidth;
			thisHeight = scanlineHeight;			
									
			var loader:Loader = new Loader();
			loader.load(new URLRequest(scanline));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, patternLoaded);
		}
		
		private function patternLoaded(e:Event):void
		{							
			bitmap = Bitmap(LoaderInfo(e.target).content).bitmapData;			
			drawPattern();					
		}
		
		private function drawPattern():void
		{			
			this.graphics.clear();
			this.graphics.beginBitmapFill(bitmap);
			this.graphics.drawRect(thisX,thisY,thisWidth,thisHeight);
			this.graphics.endFill();					
		}
		
		public function reDraw():void
		{
			thisWidth = stage.stageWidth;
			thisHeight = stage.stageHeight;
			drawPattern();
		}
	}
}