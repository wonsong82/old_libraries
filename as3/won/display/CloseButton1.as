package won.display
{
	import flash.display.*;
	import flash.filters.*;
	import flash.events.*;
	import flash.geom.*;
	
	public class CloseButton1 extends Sprite
	{
		private var _color:uint;
		private var _onClicked:Function;
		private var _width:Number;
		private var _height:Number;
		private var _corner:Number;
		
		public function CloseButton1($onClickedFunction:Function, $color:uint=0xFFFFFF, $width:Number=50, $height:Number=50, $corner:Number=5)
		{
			_color = $color;
			_onClicked = $onClickedFunction;
			_width = $width;
			_height = $height;
			_corner = $corner;
			
			// create bg
			var bg:Shape = new Shape();			
			bg.graphics.lineStyle(1, _color, .4);
			bg.graphics.beginFill(_color,0);
			bg.graphics.drawRoundRect(1,1,_width-2,_height-2,_corner);
			bg.graphics.endFill();
			
			// close
			var cross:Shape = new Shape();
			var crossSize:Number = (_width>=_height)? _height/2 : _width/2;
			var crossThick:Number = 3;
			var xS:Number = crossSize/2;
			var xT:Number = crossThick/2;
			var g:Graphics = cross.graphics;
			g.lineStyle(1,0x000000);
			g.beginFill(_color);
			g.moveTo(-xS,-xT);
			g.lineTo(-xT,-xT);
			g.lineTo(-xT,-xS);
			g.lineTo(xT,-xS);
			g.lineTo(xT,-xT);
			g.lineTo(xS,-xT);
			g.lineTo(xS,xT);
			g.lineTo(xT,xT);
			g.lineTo(xT,xS);
			g.lineTo(-xT,xS);
			g.lineTo(-xT,xT);
			g.lineTo(-xS,xT);
			g.lineTo(-xS,-xT);			
			g.endFill();
			cross.rotation = 45;
			cross.x = _width/2;
			cross.y = _height/2;
			cross.alpha = .4;
			
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, _onClicked);
			this.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void{
				this.filters = [new GlowFilter(0xff0000,10,10)];
			});
			this.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void{
				this.filters = [];
			});		
			
			this.addChild(bg);
			this.addChild(cross);		
		}
	}
}