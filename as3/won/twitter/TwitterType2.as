package
{
	import won.*;
	import flash.display.*;	
	import flash.events.*;
	import flash.net.*;
	import flash.xml.*;
	import flash.text.*;
	
	public class Twitter extends MovieClip
	{
		private var _xmlList:XMLList;
		private var _size:Number = 500;
		private var _textCon:Sprite;		
		private var _textFont:String = "frankGB";
		private var _textSize:Number = 12;
		private var _textColor:uint = 0xcccccc;		
		private var _textBGColor:uint = 0x000000;
		private var _twitterURL:String = "www.twitter.com/karaokesingsing";
		private var _isOver:Boolean = false;		
				
		public function set size($size:Number):void{_size=$size}
		public function get size():Number{return _size}
		
		public function Twitter()
		{
			
		}
		
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
			_textCon.x = _size;
			
			// cre mask
			var maskLayer:Shape = new Shape();
			maskLayer.graphics.beginFill(0);
			maskLayer.graphics.drawRect(0,0,_size, _textSize*2);
			maskLayer.graphics.endFill();
			this.addChild(maskLayer);
			this.mask = maskLayer;
			
			// getxmlList
			e.target.removeEventListener(Event.COMPLETE, init);
			var xml:XML = XML(e.target.data);
			_xmlList = xml.status;
			
			// cre texts
			var itx:Sprite = new Sprite();			
			var itf:TextField = WonMethods.writeText({font:_textFont, size:_textSize, color:_textColor, text:"Welcome to KARAOKE SINGSING."}) as TextField;
			var itextBG:Shape = drawTextBG(itf);
			itx.addChild(itextBG);
			itx.addChild(itf);
			itx.mouseChildren = false;
			_textCon.addChild(itx);
			for (var i:int=0; i<_xmlList.length(); i++){
				var tx:Sprite = new Sprite();
				var txt:TextField = WonMethods.writeText({font:_textFont, size:_textSize, color:_textColor, text:_xmlList[i].text}) as TextField;
				var txtBG:Shape = drawTextBG(txt);
				var time:String = TwitterDate.convert(_xmlList[i].created_at, "Y.m.d E h:i:sA");				
				var date:TextField = WonMethods.writeText({font:_textFont, size:_textSize, color:_textColor, text:time}) as TextField;
				var dateBG:Shape = drawTextBG(date);
				txt.x = txtBG.x = date.width + 5;
				tx.addChild(txtBG); tx.addChild(dateBG); tx.addChild(txt); tx.addChild(date);
				tx.x = _textCon.width + 150;
				tx.mouseChildren = false;				
				tx.buttonMode = true;
				tx.addEventListener(MouseEvent.MOUSE_OVER, over);
				tx.addEventListener(MouseEvent.MOUSE_OUT, out);
				_textCon.addChild(tx);
			}		
			
			this.addEventListener(MouseEvent.CLICK, clicked);
			this.addEventListener(Event.ENTER_FRAME, moveText);
		}
		
		private function drawTextBG($tf:TextField):Shape
		{
			var s:Shape = new Shape();
			s.graphics.beginFill(_textBGColor);
			s.graphics.drawRect(0,0,$tf.width,$tf.height);
			s.graphics.endFill();
			return s;
		}
		
		private function moveText(e:Event):void
		{
			if (_isOver) return;
			_textCon.x -= 4;
		}
		
		private function over (e:MouseEvent):void
		{			
			_isOver = true;
			W.stopTween(e.target);
			W.tween(e.target, .5, {tint:{color:0x444444, saturation:1}, easing:"StrongOut"});
		}
		
		private function out (e:MouseEvent):void
		{
			_isOver = false;
			W.stopTween(e.target);
			W.tween(e.target, 1, {tint:"original", easing:"StrongIn"});
		}
		
		private function clicked (e:MouseEvent):void
		{
			navigateToURL(new URLRequest(_twitterURL), "_blank");
		}
		
		
	}	
}