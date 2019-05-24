package won.media
{
	import flash.events.Event;
	
	public class MediaEvent extends Event
	{
		public static const FINISHED:String="finished_playing";
		public static const FULLY_LOADED:String="fully_loaded";
		public static const ERROR:String="error";
		public static const STARTED:String="started_playing";
		
		private var _text:String;
		public function get text():String{return _text;}
		
		public function MediaEvent($type:String,$text:String="")
		{
			super($type);
			_text=$text;
		}
		
		public override function toString():String{return "com.karaokesingsing.media.MediaEvent";}
		
		
	}
}