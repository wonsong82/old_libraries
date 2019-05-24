package won.twitter
{
	import won.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.xml.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class TwitterType1Multi extends MovieClip
	{		
		//variables		
		private var _size:Number = 200;
		private var _header:Array = [];
		private var _footer:Array = [];
		private var _duration:Number = 5;
		private var _font:String = "arial";
		private var _fontColor:uint = 0;
		private var _fontSize:Number = 12;
		private var _embedFont:Boolean = false;	
		private var _random:Boolean = false;
					
		//getter & setter
		public function set size($size:Number):void{_size=$size;}
		public function get size():Number{return _size;}		
		public function set header($header:Array):void{_header=$header;}
		public function get header():Array{return _header;}
		public function set footer($footer:Array):void{_footer=$footer;}
		public function get footer():Array{return _footer;}
		public function set duration($duration:Number):void{_duration=$duration; if (_duration<3) _duration=3;}
		public function get duration():Number{return _duration;}
		public function font($font:String,$color:uint=0,$size:Number=12,$embed:Boolean=false):void{_font=$font;_fontColor=$color;_fontSize=$size;_embedFont=$embed;}
				
		private var _textCon:Sprite;
		private var _list:Array = [];
		private var _p:int = -1;
		private var _n:int = 0;
		private var _textU:TextField;
		private var _textD:TextField;
		private var _timer:Timer;	
		private var _contents:Array;
		
		public function load($url:Array, $random:Boolean=false):void
		{
			_random=$random;
			
			//check _header and _footer
			if (_header.length==0){
				for (var i:int=0;i<$url.length;i++){
					_header.push("");
				}
			} else if (_header.length!=$url.length){
				throw("TwitterType1Error:incorrect number of arguments in /header. must match the number of URLs loaded.");
				return;
			}
			if (_footer.length==0){
				for (i=0;i<$url.length;i++){
					_footer.push("");
				}
			} else if (_footer.length!=$url.length){
				throw("TwitterType1Error:incorrect num of arguments in /footer. must match the number of URLs loaded.");
				return;
			}
					
			// load XML
			i=0;
			loadXML();
			function loadXML(e:Event=null):void{
				if (e!=null){ // add to the list
					var xml:XML = XML(e.target.data);
					_list.push(new XMLList(xml.status));
				}
				if (i==$url.length){ //if its last one
					creContents();
					return;
				}
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, loadXML);
				loader.load(new URLRequest($url[i]));
				i++;
			}
		}
		
		private function creContents():void
		{
			// create a new _contents Array containing all text, createdAt, header and footer one list after another.
			var total:int=0;
			
			for (var i:int=0;i<_list.length;i++){ // get total number of elements			
				total+=_list[i].length();
			}
			_contents = new Array(total);
			for (i=0;i<_list.length;i++){ //push one after one another
				for (var j:int=0;j<_list[i].length();j++){				
					_contents[i+j*_list.length] = [_header[i]+_list[i][j].text+_footer[i], _list[i][j].created_at];
				}
			}
			if (_random) _contents.sort(W.shuffle);
			
			init();
		}		
		
		private function init():void
		{		
			// cre textCon
			this.addChild(_textCon = new Sprite());
			_textD = WonMethods.writeText({font:_font, embed:_embedFont, size:_fontSize, text:"", selectable:false, color:_fontColor}) as TextField;
			_textU = WonMethods.writeText({font:_font, embed:_embedFont, size:_fontSize, text:"", selectable:false, color:_fontColor}) as TextField;
			_textCon.addChild(_textD);
			_textCon.addChild(_textU);
						
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
			_textD.text = (_p!=-1)? _contents[_p][0] : "";
			_textD.alpha = 1;			
			_textU.text = _contents[_n][0];
			_textU.alpha = 0;
			W.tween(_textD, 1, {alpha:0});
			W.tween(_textU, 1, {alpha:1});			
			_p++;
			_n++;
			if (_p==_contents.length) _p=0;
			if (_n==_contents.length) _n=0;			
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