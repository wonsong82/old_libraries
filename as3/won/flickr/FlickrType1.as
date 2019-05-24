package won.flickr
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.xml.*;
	import won.flickr.util.*;
	import won.flickr.event.*;
	import won.*;
	import flash.geom.*;	
	import flash.filters.*;
	import flash.text.*;	
	
	public class FlickrType1 extends MovieClip
	{
		// variables
		private var _numColumn:int = 4;	
		private var _themeColor:Number = 0xffffff;
		
		private var _thumbSize:Array = [300,300];	
		private var _thumbPos:Array = [0,0];
		private var _thumbGap:Number = 5; 
		private var _thumbMargin:Array = [10,10] //margin x, y
		private var _thumbAlpha:Number = .8;
		
		private var _frameSize:Number = 300;
		private var _framePos:Array = [300,0];
		private var _frameMargin:Array = [10,30];
		
		private var _twitterURL:String;
				
		// Getters and Setters
		public function set color($color:Number):void{_themeColor=$color;}
		public function set link($url:String):void{_twitterURL=$url;}
		public function set thumb($param:Object):void
		{
			if ($param.width!=null) _thumbSize[0] = $param.width;
			if ($param.height!=null) _thumbSize[1] = $param.height;
			if ($param.x!=null) _thumbPos[0] = $param.x;
			if ($param.y!=null) _thumbPos[1] = $param.y;
			if ($param.gap!=null) _thumbGap = $param.gap;
			if ($param.marginX!=null) _thumbMargin[0] = $param.marginX;
			if ($param.marginY!=null) _thumbMargin[1] = $param.marginY;
			if ($param.alpha!=null) _thumbAlpha = $param.alpha;
			if ($param.column!=null) _numColumn = $param.column;
		}		
		public function set frame($param:Object):void
		{
			if ($param.size!=null) _frameSize = $param.size;			
			if ($param.x!=null) _framePos[0] = $param.x;
			if ($param.y!=null) _framePos[1] = $param.y;
			if ($param.marginX!=null) _frameMargin[0] = $param.marginX;
			if ($param.marginY!=null) _frameMargin[1] = $param.marginY;
		}
		
		private var _list:XMLList;
		private var _thumb:Sprite;
		private var _frame:Sprite;	
		private var _frameCon:Sprite;
		private var _pages:int;
		private var _key:String;
		private var _user:String;
		private var _perPage:uint;
		
// Start ///////////////////////////////////////////////////////////////////////////////////////////////////////
		public function load($user:String,$key:String):void
		{
			_key = $key;
			_user = $user;
			
			// getPerpage
			var marginX:Number = _thumbMargin[0];
			var marginY:Number = _thumbMargin[1];
			var gap:Number = _thumbGap;
			var picSize:Number = (_thumbSize[0]-(marginX*2+(gap*_numColumn-1)))/_numColumn;
			var verticalWorkableSize:Number = _thumbSize[1] - (_thumbMargin[1]*2);
			var numPicVertical:uint = Math.floor((verticalWorkableSize+gap)/(picSize+gap));		
			_perPage = _numColumn * numPicVertical;
			
			//cre thumbs and frame
			creThumb();	
			creFrame();
		}
//END Start ////////////////////////////////////////////////////////////////////////////////////////////////////
		

// Create Thumb and Frame ////////////////////////////////////////////////////////////////////////////////////////
		private function creThumb():void // create thumbnail bg and animate it.
		{					
			//thumb window bg with center registration
			_thumb = createBox(_thumbSize[0],_thumbSize[1],6);
			_thumb.x = _thumbSize[0]/2; _thumb.y = _thumbSize[1]/2;
			_thumb.x += _thumbPos[0]; _thumb.y += _thumbPos[1];
			
			//container that will hold thumbnails.
			var thumbCon:Sprite = new Sprite();			
			thumbCon.name = "thumbnailsContainer";			
			thumbCon.x = -_thumbSize[0]/2; thumbCon.y  = -_thumbSize[1]/2;
			_thumb.addChild(thumbCon);
			
			//close button
			var closeBtn:Sprite = creCloseBtn(closeEntire);
			closeBtn.name = "thumbCloseBtn";
			closeBtn.x = _thumbSize[0] - closeBtn.width - 10 + _thumbPos[0];
			closeBtn.y = _thumbPos[1];
			_thumb.width = _thumb.height = 0;
			this.addChild(_thumb);		
			
			//animate to visually initialize
			_thumb.alpha = 0;			
			W.tween(_thumb, 1, {alpha:1, width:_thumbSize[0], height:_thumbSize[1], easing:"strongOut", onComplete:function(){																							   
			closeBtn.alpha = 0; 
			addChild(closeBtn);
			W.tween(closeBtn, .3, {alpha:1});
			// load the first page
			loadXml(1);
			}});
		}		
		
		private function creFrame():void // create frame and size it to 0
		{
			//frame window bg with center registartion
			_frame = createBox(_frameSize,_frameSize,6);
			_frame.x = _frameSize/2; _frame.y = _frameSize/2;
			_frame.x += _framePos[0]; _frame.y += _framePos[1];
			
			//container that will hold the frame.
			_frameCon = new Sprite();
			_frameCon.alpha = 1;
			_frameCon.x =_frame.x; _frameCon.y = _frame.y;	
			
			//close button
			var closeBtn:Sprite = creCloseBtn(closeFrame);
			closeBtn.name = "frameCloseBtn";			
			
			// invisible them.
			closeBtn.visible = false;
			closeBtn.alpha = 1;
			_frame.width = _frame.height = 0;
			_frame.alpha = 0;	
			
			this.addChild(_frame);
			this.addChild(closeBtn);	
			this.addChild(_frameCon);
		}
		
		
		public function closeEntire(e:MouseEvent = null):void
		{
			dispatchEvent(new FlickrEvent(FlickrEvent.CLOSE));
			W.stopTween(this);
			W.tween(this, 1, {alpha:0, easing:"strongOut", onComplete:removeThis});
			
			
		}
		
		private function removeThis():void
		{			
			this.parent.removeChild(this);
		}
		
		private function closeFrame(e:MouseEvent):void
		{
			var closeBtn:Sprite = this.getChildByName("frameCloseBtn") as Sprite;
			closeBtn.visible = false;
			closeBtn.alpha = 0;
			W.tween(_frame, 1, {width:0, height:0, alpha:0, easing:"strongOut"});
			_frameCon.removeChildAt(0);
			dispatchEvent(new FlickrEvent(FlickrEvent.FRAME_CLOSE));
		}
// END Create Thumb and Frame /////////////////////////////////////////////////////////////////////////////////////////////////



// Start loading XML and get pictures from Flickr , load XML //////////////////////////////////////////////////////////////////////		
		private function loadXml($page:uint):void
		{
			// load XML
			var url:String = "http://api.flickr.com/services/rest/?method=flickr.people.getPublicPhotos&api_key="+_key+"&user_id="+_user+"&per_page="+_perPage+"&page="+$page+"&&extras=url_sq,url_m,url_l,url_o,date_upload,description";
			var loader:URLLoader = new URLLoader();			
			loader.addEventListener(Event.COMPLETE, setList);
			loader.load(new URLRequest(url));
			
			function setList(e:Event):void
			{   //set xmlList
				var xml:XML = XML(e.target.data);
				_list = xml.photos.photo;
				_pages = xml.photos.@pages;
				
				// create thumbnails and page navigation button
				getThumbnails($page);
				getPageButtons($page);
			}
		}
// End Loading XML ////////////////////////////////////////////////////////////////////////////////////////////////////////////////


			
//create individual thumbnails //////////////////////////////////////////////////////////////////////////////////////////////
		private function getThumbnails($page):void // create thumb nails and display it
		{
			var thumbCon:Sprite = new Sprite();
			thumbCon.name = "thumbCon";
			thumbCon.buttonMode = true;
			Sprite(_thumb.getChildByName("thumbnailsContainer")).addChild(thumbCon);
			
			var marginX:Number = _thumbMargin[0];
			var marginY:Number = _thumbMargin[1];
			var gap:Number = _thumbGap;
			var picSize:Number = (_thumbSize[0]-(marginX*2+(gap*_numColumn-1)))/_numColumn;
			var j:int=0;
			for (var i:int=0; i<_list.length(); i++){				
				var con:Sprite = new Sprite();
				var bg:Shape = new Shape();
				bg.graphics.lineStyle(1,_themeColor,.5);
				bg.graphics.beginFill(0,.7);
				bg.graphics.drawRect(-1,-1,picSize+2,picSize+2);
				bg.graphics.endFill();				
				con.addChild(bg);
				var l:Loader = new Loader();
				l.contentLoaderInfo.addEventListener(Event.COMPLETE, resizeThumb);
				l.load(new URLRequest(_list[i].@url_sq));
				l.alpha = _thumbAlpha;
				con.addChild(l);
				con.x = marginX + (gap+picSize)*(i%_numColumn);
				con.y = marginY + (gap+picSize)*j;
				var color:ColorMatrixFilter = new ColorMatrixFilter([.33, .33, .33, 0, 0, .33, .33, .33, 0, 0, .33, .33, .33, 0, 0, .33, .33, .33, 1, 0]);
				l.filters = [color];
				
				con.name = i.toString();
				con.mouseChildren = false;				
				con.addEventListener(MouseEvent.MOUSE_OVER, over);
				con.addEventListener(MouseEvent.MOUSE_OUT, out);				
				thumbCon.addChild(con);
				thumbCon.addEventListener(MouseEvent.CLICK, thumbClicked);				
				if (i%_numColumn == _numColumn-1) j++;
			}
			function resizeThumb(e:Event):void //resize after thumbnails are loaded
			{				
				e.target.loader.width = picSize;
				e.target.loader.height = picSize;
			}
			function over(e:MouseEvent):void //thumbnails over : change alpha and remove grayscale filter
			{
				var target = e.currentTarget.getChildAt(1);
				W.tween(target, .3, {alpha:1});
				target.filters = [];
			}
			function out(e:MouseEvent):void //thumbnails out : change alpha and add grayscale filter
			{
				var target = e.currentTarget.getChildAt(1);
				W.tween(target, .3, {alpha:_thumbAlpha});
				var color:ColorMatrixFilter = new ColorMatrixFilter([.33, .33, .33, 0, 0, .33, .33, .33, 0, 0, .33, .33, .33, 0, 0, .33, .33, .33, 1, 0]);				
				target.filters = [color];
			}
			function thumbClicked(e:MouseEvent  ):void // resize the frame and display
			{		
				// remove Mouse Clicking Function from the thumbnail container until the picture is fully loaded
				var thumbCon:Sprite = Sprite(_thumb.getChildByName("thumbnailsContainer")).getChildByName("thumbCon") as Sprite;
				thumbCon.buttonMode = false;
				thumbCon.removeEventListener(MouseEvent.CLICK, thumbClicked);
				
				// hide close btn
				var closeBtn:Sprite = getChildByName("frameCloseBtn") as Sprite;
				closeBtn.visible = false;
				closeBtn.alpha = 0;
																	
				// get size of the picture to resize the frame.										
				var i:int = int(e.target.name);				
				var largeSize:Boolean = (_frameSize>500)? true : false;				
				var origWidth:Number = (largeSize)? _list[i].@width_l : _list[i].@width_m;
				var origHeight:Number = (largeSize)? _list[i].@height_l : _list[i].@height_m;				
				var adjustedWidth:Number;
				var adjustedHeight:Number;
				if (origWidth >= origHeight){
					adjustedWidth = _frameSize-(_frameMargin[0]*2);
					adjustedHeight = adjustedWidth*origHeight/origWidth;					
				} else {
					adjustedHeight = _frameSize-(_frameMargin[1]*2);
					adjustedWidth = adjustedHeight*origWidth/origHeight;
				}				
				
				// create loadingBar
				var loadingBar:Sprite = creLoadingBar(_themeColor, adjustedWidth/2, adjustedHeight/60);
				loadingBar.x = _frameCon.x - adjustedWidth/4;
				loadingBar.y = _frameCon.y - loadingBar.height/2;
				
				
				// animate the frame to its destinated size, resize the prevloader also if exist, loadPic afterwards
				W.tween(_frame, .5, {width:adjustedWidth+_frameMargin[0]*2, height:adjustedHeight+_frameMargin[1]*2, alpha:1, easing:"strongOut", onComplete:loadPic});								
				if (_frameCon.numChildren != 0){
					var prevLoaderCon:Sprite = Sprite(_frameCon.getChildAt(0));
					var color:ColorMatrixFilter = new ColorMatrixFilter([.33, .33, .33, 0, 0, .33, .33, .33, 0, 0, .33, .33, .33, 0, 0, .33, .33, .33, 1, 0]);				
					prevLoaderCon.filters = [color];
					//W.tween(prevLoader, .5, {width:adjustedWidth, height:adjustedHeight, tint:{color:0,saturation:.2}, easing:"strongOut"});
					W.tween(prevLoaderCon, .5, {width:adjustedWidth, height:adjustedHeight, easing:"strongOut"});
				}				
				
				function loadPic():void{ //load picture		
					addChild(loadingBar);
					var url:String = (largeSize)? _list[i].@url_l : _list[i].@url_m;				
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, resizeit);
					loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loading);
					loader.load(new URLRequest(url));				
				}	
				
				function loading(e:ProgressEvent):void //loadingBar
				{
					 var bar:Sprite = Sprite(loadingBar).getChildByName("bar") as Sprite;
					 bar.width = e.bytesLoaded/e.bytesTotal * adjustedWidth/2;
				}
										
				function resizeit(e:Event):void{ //resize it and alpha animate it, alpha the prevloader and removes it if exist. when done, add mouse function again
					
					//resize the loader
					var img:Loader = Loader(e.target.loader);
					img.width = adjustedWidth;
					img.height = adjustedHeight;
					
					//create loaderCon for center registration
					var loaderCon:Sprite = new Sprite();
					loaderCon.addChild(img);
					img.x = -adjustedWidth/2;
					img.y = -adjustedHeight/2;
					
					// fadeout previous loaderCon if exist then remove it.
					if (_frameCon.numChildren != 0){
						W.tween(prevLoaderCon, .5, {alpha:0, onComplete:function(){
							prevLoaderCon.parent.removeChild(prevLoaderCon);
						}});
					}			
					
					// show loaderCon, when done, set mouse functionality back to normal
					loaderCon.alpha=0;					
					_frameCon.addChild(loaderCon);
					W.tween(loaderCon, .5, {alpha:1, onComplete:function(){
						thumbCon.addEventListener(MouseEvent.CLICK, thumbClicked);
						thumbCon.buttonMode = true;
						closeBtn.visible = true; // show close button back
						closeBtn.x = _frame.x+adjustedWidth/2+_frameMargin[0]-closeBtn.width-10;
						closeBtn.y = _frame.y-adjustedHeight/2-_frameMargin[1];
						closeBtn.alpha = 1;
						removeChild(loadingBar); //remove loading
					}});				
				}
				
				// dispatch Events				
				dispatchEvent(new FlickrEvent(FlickrEvent.INFO, _list[i].@title, FlickrDate.convert(_list[i].@dateupload), _list[i].description));				
				
			}			
		}
// END Thumbs //////////////////////////////////////////////////////////////////////////////////////////////////////////////////


		 
// create a page navigation///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function getPageButtons($page:uint):void
		{
			var tff:TextFormat = new TextFormat("arial",12,_themeColor,true);
			var tff2:TextFormat = new TextFormat("arial",12,0xff6600,true);			
			
			// if pagenation is already created, just change the color
			if (Sprite(_thumb.getChildByName("thumbnailsContainer")).getChildByName("thumbNav") != null){
				var existingThumbNav:Sprite = Sprite(_thumb.getChildByName("thumbnailsContainer")).getChildByName("thumbNav") as Sprite;				
				for (var j:int=0; j<existingThumbNav.numChildren; j++){					 
					if (TextField(Sprite(existingThumbNav.getChildAt(j)).getChildAt(0)).text == $page.toString())
					 TextField(Sprite(existingThumbNav.getChildAt(j)).getChildAt(0)).setTextFormat(tff2);
					else TextField(Sprite(existingThumbNav.getChildAt(j)).getChildAt(0)).setTextFormat(tff);
				}
				return;
			}
			var thumbNav:Sprite = new Sprite();
			thumbNav.name = "thumbNav";
			thumbNav.alpha = .7;
			
			for (var i:int=0; i<_pages; i++){
				var sp:Sprite = new Sprite();
				sp.name = (i+1).toString();
				var tf:TextField = new TextField();
				tf.selectable = false;
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.mouseEnabled = false;
				tf.defaultTextFormat = (i+1 == $page)? tff2 : tff;
				tf.text = (i+1).toString();				
				tf.x = i*12;
				sp.addChild(tf);
				sp.buttonMode = true;
				
				thumbNav.addChild(sp);
			}
			
			thumbNav.x = _thumbMargin[0];
			thumbNav.y = _thumbSize[1] - 25;			
			thumbNav.addEventListener(MouseEvent.CLICK, thumbNavClicked);
			Sprite(_thumb.getChildByName("thumbnailsContainer")).addChild(thumbNav);
			
			function thumbNavClicked(e:MouseEvent):void
			{				
				var thumbContainer:Sprite = _thumb.getChildByName("thumbnailsContainer") as Sprite;
				if (thumbContainer.getChildByName("thumbCon") == null) return; //if clicked while loading, return
				var thumbCon:Sprite = thumbContainer.getChildByName("thumbCon") as Sprite;
				thumbContainer.removeChild(thumbCon);
				loadXml(uint(e.target.name));
			}
		}	
// END page navigation //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		
		
// Functions ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
		private function createBox($width:Number,$height:Number,$corner:Number=6):Sprite
		{
			var g:Sprite = new Sprite();
			// stroke
			var s:Sprite = new Sprite();
			s.graphics.lineStyle(1,0x333333);
			s.graphics.drawRoundRect(-$width/2,-$height/2,$width,$height,$corner);			
			s.graphics.lineStyle(1,_themeColor,.6);
			s.graphics.drawRoundRect(-$width/2+1,-$height/2+1,$width-2,$height-2,$corner);			
			// bg
			var b:Sprite = new Sprite();
			var m:Matrix = new Matrix();
			m.createGradientBox($width,$height,Math.PI*75/180,-$width/3,-$height/3);
			b.graphics.beginGradientFill(GradientType.LINEAR, [_themeColor,_themeColor], [.7,0], [100,255],m);
			b.graphics.drawRoundRect(-$width/2+1,-$height/2+1,$width-2,$height-2,$corner);
			b.graphics.endFill();			
			g.addChild(s);
			g.addChild(b);
			return g;						
		}
		
		private function creLoadingBar($color:Number,$width:Number,$height:Number):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.lineStyle(1,$color, .5);
			sp.graphics.drawRect(0,0,$width,$height);
			var bar:Sprite = new Sprite();
			bar.name = "bar";
			bar.graphics.beginFill($color, .5);
			bar.graphics.drawRect(0,0,1,$height);
			sp.addChild(bar);
			return sp;
		}		
		
		private function creCloseBtn(f:Function):Sprite
		{
			var sp:Sprite = new Sprite();
			var bg:Shape = new Shape();
			var m:Matrix = new Matrix();
			m.createGradientBox(20,40,Math.PI*90/180,0,0);
			bg.graphics.lineStyle(1,_themeColor, .4);			
			//bg.graphics.beginGradientFill(GradientType.LINEAR, [0xdd0000, 0x330000], [.7,.7], [100,150], m);
			bg.graphics.beginFill(_themeColor,0);
			bg.graphics.drawRoundRect(1,1,38,18,5);
			bg.graphics.endFill();			
			sp.addChild(bg);
			// x graphic
			var xs:Shape = new Shape();
			var xSize:Number = 11;
			var xThickness:Number = 3;
			var xS:Number = xSize*.5;
			var xT:Number = xThickness*.5;
			var g:Graphics = xs.graphics;
			g.lineStyle(1,0x000000);
			g.beginFill(_themeColor);
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
			xs.rotation = 45;
			xs.x = sp.width/2;
			xs.y = sp.height/2;
			xs.alpha = .4;
			sp.addChild(xs);
			//button
			sp.buttonMode = true;
			sp.addEventListener(MouseEvent.CLICK, f);
			sp.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void{
				sp.filters = [new GlowFilter(0xff0000,10,10)];
			});
			sp.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void{
				sp.filters = [];
			});
			return sp;
			
		}		
		
	}
}