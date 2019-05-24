// Make a single elements passed in as a popup window
// Assign this to the variable and use show() , hide() function.
// Instead of removing the elements, this popup leaves the elements as hidden(display:none),
// so you can alter the contents
(function($){
	
$.fn.popup=function(args){
	
	// This Content
	var content=$(this);
	
	// Get Arguments
	args=$.extend({}, $.fn.popup.defaultArgs, args);
	
	// Display None the Content
	content.css('display','none');
	
	// Variables
	var loading, overlay, popup, closeButton, pSize, pScroll;
	
	pSize=getPageSize();
	pScroll=getPageScroll();	
	
	loading=$('<div/>')
				.addClass('popup-loading')
				.css({'position':'absolute'}); // Other style controlled in CSS
	
	overlay=$('<div/>') // BG
				.css({
					'position':'fixed',
					'top':'0px',
					'left':'0px',
					'margin':'0px',
					'padding':'0px',
					'width':pSize[0],
					'height':pSize[1],
					'display':'none',
					'opacity':0, // Later animated to desinated value
					'background':args.bgColor,
					'z-index':99998
				});				
				
	popup=$('<div/>') // Content Wrapper, and the Entry Object for Methods
				.css({
					display:'none',
					position:'absolute',
					width:content.width()+'px',
					top:pScroll[1]+(pSize[3]/10)+'px',
					left:pScroll[0]+((pSize[0]-content.width())/2)+'px',
					'z-index':99999
				});
				
				
	closeButton=$('<div/>')
				.css({
					cursor:'pointer',
					position:'absolute'
				})
				.addClass('popup-nav-x');
	
	
	/////////////////////////////
	// Set up POPUP Structure
	/////////////////////////////
	
	// Set the body to relative or absolute
	if($('body').css('position')=='static')
		$('body').css('position','relative');
	
	content.css('display','block').appendTo(popup);	
	closeButton.appendTo(popup);
	overlay.appendTo('body');
	popup.appendTo('body');
	
				
		
	// Functions
	popup.show=function(){
		
		// Show Overlay Then Contents
		overlay
			.stop(true,true,true)
			.css({
				display:'block',
				opacity:0
			})
			.appendTo('body')
			.animate({
				opacity:args.bgOpacity
			}, 300, function(){
				
				// POPUP
				pSize=getPageSize();
				pScroll=getPageScroll();
				
				popup
					.stop(true,true,true)
					.css({
						display:'block',
						opacity:0,
						width:content.width(),
						top:pScroll[1]+(pSize[3]/10)+'px',
						left:pScroll[0]+((pSize[0]-content.width())/2)+'px'
					})
					.delay(200)
					.animate({
						opacity:1
					},300, function(){
						args.onLoad();
					});
				
				
				
				
			});
		
		return popup;
	}
	
	// Hide Function
	popup.hide=function(){
		popup.stop(true,true,true).animate({
			opacity:0
		},200,function(){
			overlay.css({
				display:'none',
				opacity:1				
			});
			popup.css({
				display:'none',
				opacity:1
			});
		});
		
		return popup;
	}
	
	
	// Exit Interactions
	overlay.click(function(){
		popup.hide();
	});
	closeButton.click(function(){
		popup.hide();
	});
	$(document).keyup(function(e){
		if(e.keyCode==27)
			popup.hide();
	});
	
	
	
	
	$(window).resize(function(){
		pSize=getPageSize();
		pScroll=getPageScroll();
		overlay.css({
			width:pSize[0],
			height:pSize[1]
		});
		popup.css({
			top:pScroll[1]+(pSize[3]/10)+'px',
			left:pScroll[0]+((pSize[0]-content.width())/2)+'px'
		});		
	});
	
	
	
	/////////////////////////////
	// Extra Functions
	////////////////////////////
	function getPageSize() {
		var xScroll, yScroll;
			if (window.innerHeight && window.scrollMaxY) {	
				xScroll = window.innerWidth + window.scrollMaxX;
				yScroll = window.innerHeight + window.scrollMaxY;
			} else if (document.body.scrollHeight > document.body.offsetHeight){ // all ut Explorer Mac
				xScroll = document.body.scrollWidth;
				yScroll = document.body.scrollHeight;
			} else { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
				xScroll = document.body.offsetWidth;
				yScroll = document.body.offsetHeight;
			}
			var windowWidth, windowHeight;
			if (self.innerHeight) {	// all except Explorer
				if(document.documentElement.clientWidth){
					windowWidth = document.documentElement.clientWidth; 
				} else {
					windowWidth = self.innerWidth;
				}
				windowHeight = self.innerHeight;
			} else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
				windowWidth = document.documentElement.clientWidth;
				windowHeight = document.documentElement.clientHeight;
			} else if (document.body) { // other Explorers
				windowWidth = document.body.clientWidth;
				windowHeight = document.body.clientHeight;
			}	
			// for small pages with total height less then height of the viewport
			if(yScroll < windowHeight){
				pageHeight = windowHeight;
			} else { 
				pageHeight = yScroll;
			}
			// for small pages with total width less then width of the viewport
			if(xScroll < windowWidth){	
				pageWidth = xScroll;		
			} else {
				pageWidth = xScroll;
			}
			arrayPageSize = new Array(pageWidth,pageHeight,windowWidth,windowHeight);
			return arrayPageSize;
	}
	
	function getPageScroll() {
		var xScroll, yScroll;
		if (self.pageYOffset) {
			yScroll = self.pageYOffset;
			xScroll = self.pageXOffset;
		} else if (document.documentElement && document.documentElement.scrollTop) {	 // Explorer 6 Strict
			yScroll = document.documentElement.scrollTop;
			xScroll = document.documentElement.scrollLeft;
		} else if (document.body) {// all other Explorers
			yScroll = document.body.scrollTop;
			xScroll = document.body.scrollLeft;	
		}
		arrayPageScroll = new Array(xScroll,yScroll);
		return arrayPageScroll;
	};
	///////////////////////////////////////////////////
	
	
	return popup;
}

$.fn.popup.defaultArgs={
	bgColor:'#000000',
	bgOpacity:.7,
	onLoad:function(){}
}

})(jQuery);