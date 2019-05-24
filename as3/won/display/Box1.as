package won.display
{
	import flash.display.*;
	import flash.geom.*;
	
	public class Box1 extends Sprite
	{
		private var _width:Number;
		private var _height:Number;
		private var _corner:Number;
		private var _color:uint;
		
		public function Box1($width:Number=100,$height:Number=100,$corner:Number=6,$color:uint=0xffffff)
		{
			_width=$width;
			_height=$height;
			_corner=$corner;
			_color=$color;
			
			//stroke
			var s:Sprite = new Sprite();
			s.graphics.lineStyle(1,0x333333);
			s.graphics.drawRoundRect(-_width/2,-_height/2,_width,_height,_corner);			
			s.graphics.lineStyle(1,_color,.6);
			s.graphics.drawRoundRect(-_width/2+1,-_height/2+1,_width-2,_height-2,_corner);	
			
			//bg
			var b:Sprite = new Sprite();
			var m:Matrix = new Matrix();
			m.createGradientBox(_width,_height,Math.PI*75/180,-_width/3,-height/3);
			b.graphics.beginGradientFill(GradientType.LINEAR, [_color,_color], [.7,0], [100,255], m);
			b.graphics.drawRoundRect(-_width/2+1,-_height/2+1,_width-2,_height-2,_corner);
			b.graphics.endFill();
			
			this.addChild(s);
			this.addChild(b);			
		}
	}
}