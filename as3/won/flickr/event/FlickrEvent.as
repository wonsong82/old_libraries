package won.flickr.event
{
	import flash.events.Event;
	
	public class FlickrEvent extends Event
	{		
		public static const INFO:String="info";
		public static const CLOSE:String="close";
		public static const FRAME_CLOSE:String="frame_closed";
		
		private var _title:String;
		private var _date:String;
		private var _desc:String;
		public function get title():String{return _title;}
		public function get date():String{return _date;}
		public function get description():String{return _desc;}
		
		public function FlickrEvent($type:String,$title:String="",$date:String="",$description:String="")
		{
			super($type);
			_title=$title;
			_date=$date;
			_desc=$description;
		}
	}
}