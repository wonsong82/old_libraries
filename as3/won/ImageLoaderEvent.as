package
{
	import flash.events.*;
	import flash.display.Loader;
	
	public class ImageLoaderEvent extends Event
	{
		public static const PROGRESS:String = "progress";
		public static const LOADED:String = "loaded";
		public static const COMPLETE:String = "complete";
		
		private var _target:Loader;
		private var _bytesLoaded:Number;
		private var _bytesTotal:Number;
		
		public function get loader():Loader{return _target;}
		public function get bytesLoaded():Number{return _bytesLoaded;}
		public function get bytesTotal():Number{return _bytesTotal;}
		
		public function ImageLoaderEvent($type:String, $target:Loader=null, $bytesLoaded=0, $bytesTotal=0)
		{
			super($type);
			_target = $target;
			_bytesLoaded = $bytesLoaded;
			_bytesTotal = $bytesTotal;			
		}
	}
}