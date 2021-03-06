﻿package won.media
{
	import flash.events.Event;
	
	public class MediaSizeEvent extends Event
	{
		public static const SIZE:String="media_size";
		
		private var _width:Number;
		private var _height:Number;
		
		public function get height():Number{return _height;}
		public function get width():Number{return _width;}
		
		public function MediaSizeEvent($type:String,$width:Number,$height:Number)
		{
			super($type);
			_width=$width;
			_height=$height;
		}
	}
}