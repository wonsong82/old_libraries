package won.twitter.util
{
	
	public class TwitterDate
	{		
		public static function convert($time:String, $format:String):String	
		{
			var date:Date = new Date($time);
			var y:Number = date.getFullYear();
			var m:Number = date.getMonth()+1;
			var d:Number = date.getDate();
			var h:Number = date.getHours();
			var i:Number = date.getMinutes();
			var s:Number = date.getSeconds();
			var day:Number = date.getDay();
			
			if ($format.indexOf('Y') != -1) $format = getFullYear($format, y);
			if ($format.indexOf('y') != -1) $format = getShortYear($format, y);
			if ($format.indexOf('M') != -1) $format = getRegMonth($format, m);
			if ($format.indexOf('m') != -1) $format = getZeroMonth($format, m);			
			if ($format.indexOf('D') != -1) $format = getRegDay($format, d);
			if ($format.indexOf('d') != -1) $format = getZeroDay($format, d);						
			if ($format.indexOf('H') != -1) $format = getHour($format, h);
			if ($format.indexOf('h') != -1) $format = getZeroHour($format, h);
			if ($format.indexOf('i') != -1) $format = getZeroMin($format, i);
			if ($format.indexOf('s') != -1) $format = getZeroSec($format, s);
			if ($format.indexOf('a') != -1) $format = getampm($format, h);
			if ($format.indexOf('A') != -1) $format = getAMPM($format, h);
			if ($format.indexOf('th') != -1) $format = getDayth($format, d);
			if ($format.indexOf('e') != -1) $format = getDayNameShort($format, day);
			if ($format.indexOf('E') != -1) $format = getDayNameFull($format, day);
			if ($format.indexOf('name_M') != -1) $format = getFullNameMonth($format, m);
			if ($format.indexOf('name_m') != -1) $format = getShortNameMonth($format, m);
			return $format;
		}
		
		private static function getFullYear($format:String, $y:Number):String
		{
			var y:String = $y.toString();
			return $format.replace('Y', y);
		}
		
		private static function getShortYear($format:String, $y:Number):String
		{
			var y:String = $y.toString().substr(2);
			return $format.replace('y', y);
		}
		
		private static function getRegMonth($format:String, $m:Number):String
		{
			var m:String = $m.toString();
			return $format.replace('M', m);
		}
		
		private static function getZeroMonth($format:String, $m:Number):String
		{
			var m:String = $m.toString();			
			if (m.length == 1) m = "0" + m;			
			return $format.replace('m', m);
		}
		
		private static function getFullNameMonth($format:String, $m:Number):String
		{
			var m:String;
			if ($m == 1) m = "January";
			if ($m == 2) m = "Feburary";
			if ($m == 3) m = "March";
			if ($m == 4) m = "April";
			if ($m == 5) m = "May";
			if ($m == 6) m = "June";
			if ($m == 7) m = "July";
			if ($m == 8) m = "August";
			if ($m == 9) m = "September";
			if ($m == 10) m = "October";
			if ($m == 11) m = "November";
			if ($m == 12) m = "December";
			return $format.replace('name_M',m);
		}
		
		private static function getShortNameMonth($format:String, $m:Number):String
		{
			var m:String;
			if ($m == 1) m = "Jan";
			if ($m == 2) m = "Feb";
			if ($m == 3) m = "Mar";
			if ($m == 4) m = "Apr";
			if ($m == 5) m = "May";
			if ($m == 6) m = "Jun";
			if ($m == 7) m = "Jul";
			if ($m == 8) m = "Aug";
			if ($m == 9) m = "Sep";
			if ($m == 10) m = "Oct";
			if ($m == 11) m = "Nov";
			if ($m == 12) m = "Dec";		
			return $format.replace('name_m',m);
		}
		
		private static function getRegDay($format:String, $d:Number):String
		{
			var d:String = $d.toString();
			return $format.replace('D',d);
		}
		
		private static function getZeroDay($format:String, $d:Number):String
		{
			var d:String = $d.toString();
			if (d.length == 1) d = "0" + d;
			return $format.replace('d',d);
		}
		
		private static function getDayNameFull($format:String, $d:Number):String
		{
			var d:String;
			if ($d == 0) d = "Sunday";
			if ($d == 1) d = "Monday";
			if ($d == 2) d = "Tuesday";
			if ($d == 3) d = "Wendesday";
			if ($d == 4) d = "Thursday";
			if ($d == 5) d = "Friday";
			if ($d == 6) d = "Saturday";
			return $format.replace('E',d);
		}
		
		private static function getDayNameShort($format:String, $d:Number):String
		{
			var d:String;
			if ($d == 0) d = "Sun";
			if ($d == 1) d = "Mon";
			if ($d == 2) d = "Tue";
			if ($d == 3) d = "Wed";
			if ($d == 4) d = "Thu";
			if ($d == 5) d = "Fri";
			if ($d == 6) d = "Sat";
			return $format.replace('e',d);
		}
		
		private static function getDayth($format:String, $d:Number):String
		{
			var d:String;
			if ($d == 1) d = "1st";
			else if ($d == 2) d = "2nd";
			else if ($d == 3) d = "3rd";
			else d = $d+"th";
			return $format.replace('th',d);
		}
		
		private static function getHour($format:String, $h:Number):String
		{
			var h:String;
			if ($format.indexOf('a') != -1 || $format.indexOf('A') != -1)
			{
				if ($h > 12) h = ($h - 12).toString();
				else h = $h.toString();
			} 
			
			else 
			{
				h = $h.toString();
			}
					
			return $format.replace('H',h);			
		}
		
		private static function getZeroHour($format:String, $h:Number):String
		{
			var h:String;
			if ($format.indexOf('a') != -1 || $format.indexOf('A') != -1)
			{
				if ($h > 12) h = ($h - 12).toString();
				else h = $h.toString();
			} 
			
			else 
			{
				h = $h.toString();
			}
			
			if (h.length == 1) h = "0" + h;
			return $format.replace('h',h);			
		}
		
		private static function getZeroMin($format:String, $i:Number):String
		{
			var i:String = $i.toString();
			if (i.length == 1) i = "0" + i;
			return $format.replace('i',i);
		}
		
		private static function getZeroSec($format:String, $s:Number):String
		{
			var s:String = $s.toString();
			if (s.length == 1) s = "0" + s;
			return $format.replace('s',s);
		}
		
		private static function getampm($format, $h):String
		{
			var a:String;
			if ($h > 12) a = "pm";
			else a = "am";
			return $format.replace('a', a);
		}
		
		private static function getAMPM($format, $h):String
		{
			var a:String;
			if ($h > 12) a = "PM";
			else a = "AM";
			return $format.replace('A', a);
		}
		
		
	}
}