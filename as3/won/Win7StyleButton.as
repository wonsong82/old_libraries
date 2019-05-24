package won
{
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.media.*;
	import flash.net.*;
	
	public class Win7StyleButton extends MovieClip
	{
		private var _sizeX:Number = 60;
		private var _sizeY:Number = 60;
		private var _sizeCorner:Number = 6;		
		private var _strokeColor:Number = 0x000000;
		private var _bgColor:Number = 0xffffff;
		private var _bgAlpha:Number = 0;
		private var _overColor:Number = 0xffff00;
		private var _bMode:Boolean = false;
		private var _overImg:* = null;
		private var _upImg:* = null;
		private var _sound:String = null;
		private var _overSound:Sound;
		private var _channel:SoundChannel;
		
		
		public function Win7StyleButton($param:Object=null)
		{
			if ($param != null){
				if ($param.width != null) _sizeX = $param.width;
				if ($param.height != null) _sizeY = $param.height;
				if ($param.corner != null) _sizeCorner = $param.corner;				
				if ($param.strokeColor !=null) _strokeColor = $param.strokeColor;
				if ($param.overColor != null) _overColor = $param.overColor;
				if ($param.bgColor != null) _bgColor = $param.bgColor;
				if ($param.bgAlpha != null) _bgAlpha = $param.bgAlpha;
				if ($param.buttonMode != null) _bMode = $param.buttonMode;
				if ($param.overImg != null) _overImg = $param.overImg;
				if ($param.upImg != null) _upImg = $param.upImg;
				if ($param.sound != null) _sound = $param.sound;
			}
			this.buttonMode = _bMode;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.ROLL_OVER, over);
			this.addEventListener(MouseEvent.ROLL_OUT, out);
			
			this.addChild(createStroke());
			this.addChild(createBG());
			this.addChild(createOverBG($param));
						
			if (_upImg != null){
				_upImg.x = ($param.upImgX!=null)? $param.upImgX : (_sizeX-_upImg.width)/2;				
				_upImg.y = ($param.upImgY!=null)? $param.upImgY : (_sizeY-_upImg.height)/2;
				_upImg.name = "upImg";
				_upImg.mouseEnabled = false;
				this.addChild(_upImg);
			}
			
			if (_sound != null){
				_overSound = new Sound();
				_overSound.load(new URLRequest(_sound));				
			}
		}
		
				
		private function createStroke():Sprite
		{
			var s:Sprite = new Sprite();
			s.graphics.lineStyle(1,_strokeColor);
			s.graphics.drawRoundRect(0,0,_sizeX,_sizeY,_sizeCorner);			
			s.graphics.lineStyle(1,0xffffff,.6);
			s.graphics.drawRoundRect(1,1,_sizeX-2,_sizeY-2,_sizeCorner);			
			return s;
		}
		
		private function createBG():Sprite
		{
			var s:Sprite = new Sprite();
			var m:Matrix = new Matrix();
			m.createGradientBox(_sizeX,_sizeY,Math.PI*75/180,-_sizeX/3,-_sizeY/3);
			s.graphics.beginGradientFill(GradientType.LINEAR, [0xffffff,_bgColor], [.9,_bgAlpha], [100,255],m);
			s.graphics.drawRoundRect(1,1,_sizeX-2,_sizeY-2,_sizeCorner);
			s.graphics.endFill();
			s.name = "bg";
			return s;
		}		
		
		private function createOverBG($param:Object):Sprite
		{
			if (_overImg != null){
				this.addChild(_overImg);
				_overImg.x = ($param.overImgX!=null) ? $param.overImgX : (_sizeX-_overImg.width)/2;
				_overImg.y = ($param.overImgY!=null) ? $param.overImgY : (_sizeY-_overImg.height)/2;
				_overImg.alpha = 0;
				_overImg.name = "overImg";
				_overImg.mouseEnabled = false;
			}
			
			var s:Sprite = new Sprite();
									
			var b:Sprite = new Sprite();
			b.graphics.beginFill(_overColor, .4);
			b.graphics.drawCircle(0,0,_sizeY*1.2);
			b.graphics.endFill();
			b.filters = [new BlurFilter(_sizeX/2, _sizeY/2)];
			b.y = _sizeY*1.6;
			s.addChild(b);
						
			var p:Sprite = new Sprite();
			p.graphics.beginFill(0xffffff,.9);			
			p.graphics.drawCircle(0,0,_sizeY/3);			
			p.graphics.endFill();
			p.filters = [new BlurFilter(_sizeX/2,_sizeY/2)];
			p.y = _sizeY*1.2;
			s.addChild(p);
			
			var m:Sprite = new Sprite();
			m.graphics.beginFill(0);
			m.graphics.drawRoundRect(0,0,_sizeX,_sizeY,_sizeCorner);
			this.addChild(m);
			s.mask = m;
			
			s.name = "overBG";
			s.alpha = 0;
			return s;
		}
		
		private function over(e:MouseEvent):void
		{						
			W.tween(this.getChildByName("overBG"), .3, {alpha:1});			
			this.addEventListener(MouseEvent.MOUSE_MOVE, moveOverBG);
			if (_overImg != null){
				W.stopTween(_overImg);
				W.stopTween(_upImg);
				W.tween(_upImg, .3, {alpha:0});
				W.tween(_overImg, .3, {alpha:1, delay:.5});				
			}
			if (_sound!=null) _channel = _overSound.play();			
		}
		
		private function out(e:MouseEvent):void
		{
			W.tween(this.getChildByName("overBG"), .3, {alpha:0});
			this.removeEventListener(MouseEvent.MOUSE_MOVE, moveOverBG);
			if (_overImg != null){
				W.stopTween(_overImg);
				W.stopTween(_upImg);
				W.tween(_overImg, .3, {alpha:0});
				W.tween(_upImg, .3, {alpha:1});
			}
		}
		
		private function moveOverBG(e:MouseEvent):void
		{
			var p:Sprite = this.getChildByName("overBG") as Sprite;
			p.x = this.mouseX;
		}
		
		
		override public function get width():Number { return _sizeX; }
		override public function get height():Number { return _sizeY; }
		
	}
}