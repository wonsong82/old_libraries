package won.media
{
	import flash.events.Event;
	
	public class MediaTimeEvent extends Event
	{
		public static const TIME:String="media_time";
		public static const DURATION:String="media_duration";
		public static const BYTES_LOADED:String="bytes_loaded";
		public static const BYTES_TOTAL:String="bytes_total";
		public static const BUFFER:String="buffer";
		
		private var _time:Number;		
		private var _bytesLoaded:Number;
		private var _bytesTotal:Number;
		private var _bufferPercent:Number;
		
		public function get time():Number{return _time;}
		public function get bytesLoaded():Number{return _bytesLoaded;}
		public function get bytesTotal():Number{return _bytesTotal;}
		public function get buffer():Number{return _bufferPercent;}
		
		public function MediaTimeEvent($type:String,$time:Number,$bytesLoaded:Number=-1,$bytesTotal:Number=0,$bufferPercent:Number=-1)
		{
			super($type);
			_time=$time;			
			_bytesLoaded=$bytesLoaded;
			_bytesTotal=$bytesTotal;
			_bufferPercent=$bufferPercent;
		}
	}
}