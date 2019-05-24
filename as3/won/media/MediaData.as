package won.media
{
	public class MediaData
	{
		private var _url:String;
		private var _title:String;
		private var _duration:Number;
		private var _image:String;
		private var _width:Number;
		private var _height:Number;
		
		public function set url($url:String):void{_url=$url;}
		public function get url():String{return _url;}
		public function set title($title:String):void{_title=$title;}
		public function get title():String{return _title;}
		public function set duration($duration:Number):void{_duration=$duration;}
		public function get duration():Number{return _duration;}
		public function set image($image:String):void{_image=$image;}
		public function get image():String{return _image;}
		public function set width($width:Number):void{_width=$width;}
		public function get width():Number{return _width;}
		public function set height($height:Number):void{_height=$height;}
		public function get height():Number{return _height;}
		
		public function MediaData($url:String="",$title:String="",$duration:Number=0,$image:String="",$width:Number=320,$height:Number=200)
		{//main function
			_url=$url;_title=$title;_duration=$duration;_image=$image;_width=$width;_height=$height;
		}
	}
}