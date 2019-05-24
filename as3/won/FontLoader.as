//FontLoader.as

package won
{
	import flash.text.*;
	import flash.net.*;
	import flash.display.*;
	import flash.events.*;
	
	public class FontLoader
	{
		public function FontLoader(fontList:Array, onCompleteFunction:Function)
		{
			var i:int = 0;
			loadFont();
			
			function loadFont(e:Event = null):void
			{
				if (i >= fontList.length){
					onComplete(onCompleteFunction);
					return;
				}
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadingFont);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadFont);
				loader.load(new URLRequest(fontList[i]));
				i++;
			}
			
			function loadingFont(e:ProgressEvent):void
			{
				
			}
		}
		
		private function onComplete(onCompleteFunction:Function):void
		{
			onCompleteFunction();
		}
	}
}