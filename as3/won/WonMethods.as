//WonMethods.as

package won
{
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.filters.*;
	
	public class WonMethods  // change the unixtimestamp to the real date format
	{
		
		public static function unixToDate(_date:Number):String
		{
			var currDate:Date = new Date(_date * 1000);
			var d:String = currDate.getDate().toString();
			var m:String = monthName((currDate.getMonth()+1));
			var year:String = currDate.getFullYear().toString();
			var day:String = engDay(currDate.getDay());
			
			var theDate:String = (m + " " + d + ", " + year + " (" + day + ")");
			return theDate;
			
			// required Functions ---------------------------------------
			function engDay(_day:Number):String
			{				
				var day:String;
				if (_day == 1) day = "Monday";
				if (_day == 2) day = "Tuesday";
				if (_day == 3) day = "Wendesday";
				if (_day == 4) day = "Thursday";
				if (_day == 5) day = "Friday";
				if (_day == 6) day = "Saturday";
				if (_day == 0) day = "Sunday";
				return day;
			}
			
			function korDay(_day:Number):String
			{
				var day:String;
				if (_day == 1) day = "월요일";
				if (_day == 2) day = "화요일";
				if (_day == 3) day = "수요일";
				if (_day == 4) day = "목요일";
				if (_day == 5) day = "금요일";
				if (_day == 6) day = "토요일";
				if (_day == 0) day = "일요일";
				return day;
			}
			
			function monthName(_month:Number):String
			{
				var month:String;
				if (_month == 1) month = "January";
				if (_month == 2) month = "Feburary";
				if (_month == 3) month = "March";
				if (_month == 4) month = "April";
				if (_month == 5) month = "May";
				if (_month == 6) month = "June";
				if (_month == 7) month = "July";
				if (_month == 8) month = "August";
				if (_month == 9) month = "September";
				if (_month == 10) month = "October";
				if (_month == 11) month = "November";
				if (_month == 12) month = "December";			
				return month;
			}
			
			function monthNameShort(_month:Number):String
			{
				var month:String;
				if (_month == 1) month = "Jan";
				if (_month == 2) month = "Feb";
				if (_month == 3) month = "Mar";
				if (_month == 4) month = "Apr";
				if (_month == 5) month = "May";
				if (_month == 6) month = "Jun";
				if (_month == 7) month = "Jul";
				if (_month == 8) month = "Aug";
				if (_month == 9) month = "Sep";
				if (_month == 10) month = "Oct";
				if (_month == 11) month = "Nov";
				if (_month == 12) month = "Dec";			
				return month;
			}
		}
		
		
		public static function resizePosition(_target:Object, _param:Object):void
		{
			if (_param.width != null)
			{
				if (_param.width.toString().indexOf("%") != -1) _target.width = _target.stage.stageWidth * Number(_param.width.substr(0, _param.width.length-1)) / 100;
				if (_param.width is Number) _target.width = _param.width;
			}
			
			if (_param.height != null)
			{
				if (_param.height.toString().indexOf("%") != -1) _target.height = _target.stage.stageHeight * Number(_param.height.substr(0, _param.height.length-1)) / 100;
				if (_param.height is Number) _target.height = _param.height;
			}
			
			if (_param.x != null)
			{
				if (_param.x.toString().indexOf("%") != -1)
				{
					var _x:Number = Number(_param.x.substr(0, _param.x.length-1))/100;
					if (_param.alignx == null) _param.alignx = "center";
					if (_param.alignx == "left") _target.x = _target.stage.stageWidth * _x;
					if (_param.alignx == "center") _target.x = (_target.stage.stageWidth - _target.width) * _x;
					if (_param.alignx == "right") _target.x = _target.stage.stageWidth * _x - _target.width;					
				}
				
				if (_param.x.toString().indexOf("%") == -1)
				{
					if (_param.alignx == null) _param.alignx = "left";
					if (_param.alignx == "left") _target.x = _param.x;					
					if (_param.alignx == "right") _target.x = _target.stage.stageWidth - _target.width - _param.x;					
				}			 
			}
			
			if (_param.y != null)
			{
				if (_param.y.toString().indexOf("%") != -1)
				{
					var _y:Number = Number(_param.y.substr(0, _param.y.length-1))/100;
					if (_param.aligny == null) _param.aligny = "center";
					if (_param.aligny == "top") _target.y = _target.stage.stageHeight * _y;
					if (_param.aligny == "center") _target.y = (_target.stage.stageHeight - _target.height) * _y;
					if (_param.aligny == "bottom") _target.y = (_target.stage.stageHeight * _y) - _target.height;					
				}
				
				if (_param.y.toString().indexOf("%") == -1)
				{
					if (_param.aligny == null) _param.aligny = "top";
					if (_param.aligny == "top") _target.y = _param.y;					
					if (_param.aligny == "bottom") _target.y = _target.stage.stageHeight - _target.height - _param.y;					
				}			 
			}
		}
		
		public static function drawRect(_param):Sprite
		{
			if (_param.color == null) _param.color = 0x000000;
			if (_param.alpha == null) _param.alpha = 1;
			if (_param.x == null) _param.x = 0;
			if (_param.y == null) _param.y = 0;
			if (_param.width == null) _param.width = 100;
			if (_param.height == null) _param.height = 100;
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(_param.color,_param.alpha);
			sp.graphics.drawRect(_param.x, _param.y, _param.width, _param.height);
			sp.graphics.endFill();
			
			return sp;
		}
		
				
		public static function writeText(_param:Object):TextField
		{
			if (_param.font == null) _param.font = 'arial';
			if (_param.size == null) _param.size = '12';
			if (_param.color == null) _param.color = 0x000000;
			if (_param.letterSpacing == null) _param.letterSpacing = 0;
			if (_param.autoSize == null) _param.autoSize = TextFieldAutoSize.LEFT;
			if (_param.antiAliasType == null) _param.antiAliasType = AntiAliasType.ADVANCED;
			if (_param.filters == null) _param.filters = null;
			if (_param.x == null) _param.x = 0;
			if (_param.y == null) _param.y = 0;
			if (_param.embed == null) _param.embed = false;
			if (_param.text == null) _param.text = "";
			if (_param.selectable == null) _param.selectable = true;
			if (_param.align == null) _param.align = TextFormatAlign.LEFT;
			if (_param.bold == null) _param.bold = false;			
			
			var tff:TextFormat = new TextFormat(_param.font, _param.size, _param.color);
			tff.letterSpacing = _param.letterSpacing;
			tff.align = _param.align;
			tff.bold = _param.bold;
			var tf:TextField = new TextField();
			tf.defaultTextFormat = tff;
			tf.embedFonts = _param.embed;
			tf.selectable = _param.selectable;
			tf.autoSize = _param.autoSize;
			tf.antiAliasType = _param.antiAliasType;
			tf.text = _param.text;
			tf.filters = _param.filters;
			tf.x = _param.x;
			tf.y = _param.y;
			if (_param.width != null) tf.width = _param.width;
			if (_param.wordWrap != null) tf.wordWrap = _param.wordWrap;
			
			return tf;			
		}
		
	}
}