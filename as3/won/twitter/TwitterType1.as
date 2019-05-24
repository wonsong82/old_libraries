package won.twitter
{
	import won.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.xml.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class TwitterType1 extends MovieClip
	{		
		//variables		
		private var _size:Number = 200;
		private var _header:String = "";
		private var _footer:String = "";
		private var _duration:Number = 5;
		private var _font:String = "arial";
		private var _fontColor:uint = 0;
		private var _fontSize:Number = 12;
		private var _embedFont:Boolean = false;
					
		//getter & setter
		public function set size($size:Number):void{_size=$size;}
		public function get size():Number{return _size;}		
		public function set header($header:String):void{_header=$header;}
		public function get header():String{return _header;}
		public function set footer($footer:String):void{_footer=$footer;}
		public function get footer():String{return _footer;}
		public function set duration($duration:Number):void{_duration=$duration; if (_duration<2) _duration=2;}
		public function get duration():Number{return _duration;}
		public function font($font:String,$color:uint=0,$size:Number=12,$embed:Boolean=false):void{_font=$font;_fontColor=$color;_fontSize=$size;_embedFont=$embed;}
				
		private var _textCon:Sprite;
		private var _list:XMLList;
		private var _p:int = -1;
		private var _n:int = 0;
		private var _textU:TextField;
		private var _textD:TextField;
		private var _timer:Timer;
		
		public function load($url:String):void
		{
			// load XML
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, init);
			loader.load(new URLRequest($url));
		}
		
		private function init(e:Event):void
		{
			// cre textCon
			this.addChild(_textCon = new Sprite());
			_textD = WonMethods.writeText({font:_font, embed:_embedFont, size:_fontSize, text:"", selectable:false, color:_fontColor}) as TextField;
			_textU = WonMethods.writeText({font:_font, embed:_embedFont, size:_fontSize, text:"", selectable:false, color:_fontColor}) as TextField;
			_textCon.addChild(_textD);
			_textCon.addChild(_textU);
			
			// get xml
			e.target.removeEventListener(Event.COMPLETE, init);
			var xml:XML = XML(e.target.data);
			_list = xml.status;
			
			// start the timer
			displayContent();
			_timer = new Timer(_duration*1000);
			_timer.addEventListener(TimerEvent.TIMER, displayContent);
			_timer.start();
			
			// mouse events
			this.addEventListener(MouseEvent.MOUSE_OVER, over);
			this.addEventListener(MouseEvent.MOUSE_OUT, out);		
		}
		
		private function displayContent(e:TimerEvent = null):void
		{			
			// display Text on Timer			
			_textD.text = (_p!=-1)? _header+_list[_p].text+_footer : "";
			_textD.alpha = 1;			
			_textU.text = _header+_list[_n].text+_footer;
			_textU.alpha = 0;
			W.tween(_textD, 1, {alpha:0});
			W.tween(_textU, 1, {alpha:1});			
			_p++;
			_n++;
			if (_p==_list.length()) _p=0;
			if (_n==_list.length()) _n=0;			
			if (_timer!=null) e.updateAfterEvent();
		}
		
		private function over(e:MouseEvent):void
		{			
			if (_timer!=null) _timer.stop();
		}
		
		private function out(e:MouseEvent):void
		{
			if (_timer!=null) _timer.start();
		}		
	}	
}