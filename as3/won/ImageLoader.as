package 
{
	import flash.events.*;
	import flash.display.*;
	import flash.net.*;
	
	public class ImageLoader extends EventDispatcher
	{
		private var _index:int = 0;
		private var _imgs:Array;
		
		public function load($imageStrings:Array):void
		{
			_imgs= $imageStrings;
			loadImg();			
		}
		
		private function loadImg(e:Event=null):void
		{
			if (_index != 0){
				_imgs[_index-1] = e.target.loader;
				dispatchEvent(new ImageLoaderEvent(ImageLoaderEvent.LOADED, e.target.loader));
			}
			
			if (_index == _imgs.length){
				onComplete();
				return;
			}
			
			var l:Loader = new Loader();
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, loadImg);
			l.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			l.load(new URLRequest(_imgs[_index]));
			_index++;			
		}
		
		private function onProgress(e:ProgressEvent):void
		{
			dispatchEvent(new ImageLoaderEvent(ImageLoaderEvent.PROGRESS, e.target.loader, e.bytesLoaded, e.bytesTotal));
		}		
		
		
		private function onComplete():void
		{
			dispatchEvent(new ImageLoaderEvent(ImageLoaderEvent.COMPLETE));
		}
	}
}