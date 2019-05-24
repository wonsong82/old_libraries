package 
{
	import flash.display.*;
	import flash.utils.*;
	import flash.events.*;
	import flash.text.*;
	
	public class Banner extends MovieClip
	{
		private var _texts:Array;
		private var _pictures:Array;
		private var _width:Number;
		private var _height:Number;
		private var _type:String;
		private var _bgAlpha:Number = .3;
		private var _bgHeight:Number = 50;
		private var _bgColor:uint = 0;
		private var _timerTime:Number = 5;
		private var _animTime:Number = 2;
		
		public function set type($p:String):void{_type=$p;}
		public function set bgAlpha($p:Number):void{_bgAlpha=$p;}
		public function set bgHeight($p:Number):void{_bgHeight=$p;}
		public function set bgColor($p:uint):void{_bgColor=$p;}
		public function set timerTime($p:Number):void{_timerTime=$p;}
		public function set animTime($p:Number):void{_animTime=$p;}
				
		private var _textsCon:Sprite;
		private var _picturesCon:Sprite;					
		private var _prevText:int = -1;
		private var _nextText:int = 0;
		private var _prevPic:int = -1;
		private var _nextPic:int = 0;		
		
		public function Banner($texts:Array, $pictures:Array, $bannerWidth:Number, $bannerHeight:Number)
		{
			_texts = $texts;
			_pictures = $pictures;
			_width = $bannerWidth;
			_height = $bannerHeight;				
		}
		
		public function start():void
		{
			creMask();
			bg();
			crePicturesCon();
			creTextsCon();
			
			var timer1 = new Timer(_timerTime*1000);
			timer1.addEventListener(TimerEvent.TIMER, onTimer);
			timer1.start();
			
			var interval = setInterval(delayStart, 1000);
			function delayStart():void
			{
				clearInterval(interval);
				var timer2 = new Timer(_timerTime*1000);
				timer2.addEventListener(TimerEvent.TIMER, onTimer2);
				timer2.start();
			}
		}
		
		private function onTimer(e:TimerEvent):void
		{
			getPrevPic();
			getNextPic();			
			_prevPic++;
			_nextPic++;			
			if (_prevPic == _pictures.length) _prevPic = 0;
			if (_nextPic == _pictures.length) _nextPic = 0;
		}
		
		private function onTimer2(e:TimerEvent):void
		{
			getPrevText();
			getNextText();
			_prevText++;
			_nextText++;
			if (_prevText == _texts.length) _prevText = 0;
			if (_nextText == _texts.length) _nextText = 0;
		}
		
		function getPrevText():void
		{
			if (_prevText == -1) return;
			var t:Sprite = Sprite(_textsCon.getChildByName("text"+_prevText.toString()));
			W.tween(t, _animTime, {alpha:0, easing:"strongOut"});
		}
		
		function getNextText():void
		{
			var t:Sprite = Sprite(_textsCon.getChildByName("text"+_nextText.toString()));
			W.tween(t, _animTime, {alpha:1, easing:"strongOut"})
		}
		
		function getPrevPic():void
		{
			if (_prevPic == -1) return;
			var l:Loader = Loader(_picturesCon.getChildByName("pic"+_prevPic.toString()));
			W.tween(l, _animTime, {alpha:0, easing:"strongOut"});
		}
		
		function getNextPic():void
		{
			var l:Loader = Loader(_picturesCon.getChildByName("pic"+_nextPic.toString()));
			W.tween(l, _animTime, {alpha:1, easing:"strongOut"});
		}
		
		
		private function bg():void
		{
			var s:Shape = new Shape();
			s.graphics.beginFill(_bgColor);
			s.graphics.drawRect(0,0,_width,_height);
			this.addChild(s);
		}
		
		private function crePicturesCon():void
		{
			_picturesCon = new Sprite();
			_picturesCon.buttonMode = true;								
			addChild(_picturesCon);
			
			for (var i:int=0; i<_pictures.length; i++){
				var pic:Loader = Loader(_pictures[i]);
				pic.width = _width;
				pic.height = _height;
				pic.name = "pic"+i.toString();
				pic.alpha=0;
				_picturesCon.addChild(pic);
			}
		}
		
		private function creTextsCon():void
		{
			_textsCon = new Sprite();
			_textsCon.mouseChildren = false;
			var bg:Shape = new Shape();
			bg.graphics.beginFill(_bgColor,_bgAlpha);
			bg.graphics.drawRect(0,0, _width, _bgHeight);
			this.addChild(bg);
			this.addChild(_textsCon);
			
			for (var i:int=0; i<_texts.length; i++){
				var sp:Sprite = new Sprite();				
				var t:TextField = TextField(_texts[i]);
				sp.name = "text"+i.toString();
				sp.alpha = 0;
				sp.addChild(t);
				sp.y = (_bgHeight - sp.height)/2;
				_textsCon.addChild(sp);
			}
		}
		
		private function creMask():void
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0,0);
			sp.graphics.drawRect(0,0,_width,_height);
			sp.graphics.endFill();
			this.addChild(sp);
			this.mask = sp;
		}		
	}
}