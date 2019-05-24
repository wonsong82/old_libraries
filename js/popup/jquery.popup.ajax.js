/*
	Make popup from a links passed in. the link is the content
*/
$.fn.popup = function() {
	
	var $this=$(this);
	
	//Error Checking
	$this.each(function(){
		if(!$(this).is('a')){
			throw "Passed collections must be <a/> element.";
			return false;
		}
	});
	
	
	// Arguments
	var args = arguments[0] || {};	
	
	args.overlayColor		= args.overlayColor	|| '#000000';
	args.overlayOpacity		= args.overlayOpacity || .7;
	args.width				= args.width || 0;
	args.onLoad = args.onLoad || function(){}
			
	// properties
	var loading 	= $('<div/>')
						.addClass('popup-loading')
						.css({'position':'absolute'});; //Loading Object
	
	var overlay		= $('<div/>');	//Overlay to disable the interactions in the back
	var popup		= $('<div/>'); //The popup itself
	var popupContent= $('<div/>'); //Actual html contents of the popup
					
	var nav 		= {}; //Navigations
	nav.left		= $('<div/>').addClass('popup-nav-left');
	nav.right		= $('<div/>').addClass('popup-nav-right');
	nav.x			= $('<div/>').addClass('popup-nav-x');
	
	
	var links	= [];
	$this.each(function(){		
		links.push($(this).attr('href'));		
	});
	
	// Helper Properties
	var i 			= 0;				
	var cur			= 0;
	
	
	
	// define functions	
	nav.show = function() {
		this.left.css('display' , 'block');
		this.right.css('display' , 'block');
		this.x.css('display','block');
	}
	
	nav.hide = function() {
		this.left.css('display' , 'none');
		this.right.css('display' , 'none');
		this.x.css('display','none');
	}
	
	
	
	popup.show = function(index) {
		
		popup.remove();		
		cur=index!=null?index:0;
		
		// Set the body to relative or absolute (if set already)
		if($('body').css('position')=='static')		
			$('body').css('position','relative');
		
		
		// Insert Overlay
		var pageSize = getPageSize();	
		var pageScroll = getPageScroll();
		
		nav.hide();
		
		overlay
		.css({
			'position':'fixed',
			'top':'0px',
			'left':'0px',
			'margin':'0px',
			'padding':'0px',
			'width':pageSize[0],
			'height':pageSize[1],
			'opacity': 0,
			'background':args.overlayColor,
			'z-index':99998		
		})
		.appendTo('body')
		.stop(true).animate({
			'opacity':args.overlayOpacity
		}, 300, function(){
		
			//After overlay animation is done,
			//Load the page first
			loading.appendTo(overlay);
			
			$.ajax({
				'url':links[index],
				'type':'post',
				'async':true,
				'cache':false,
				'data':{},
				'success':function(data){
					
					loading.remove();
					
					var content=$(data);
					popupContent.html(content);
					
					popup
					.css('opacity',0)
					.appendTo('body')
					.css({
						'opacity':0,
						'position':'absolute',
						'width':content.width()+'px',
						'top':pageScroll[1]+(pageSize[3]/10)+'px',
						'left':pageScroll[0]+((pageSize[0]-content.width())/2)+'px',
						'z-index':99999
					});
					args.onLoad();
								
					popup.stop(true)
					.delay(200)
					.animate({
						'opacity':1
					},300, function(){
						
						// Setup interactions
						nav.right.click(function(){
							cur++;
							if (cur>=links.length) cur=0;
														
							popup.play(cur);
						});
						nav.left.click(function(){
							cur--;
							if (cur<0) cur=links.length-1;
							popup.play(cur);
						});
						nav.x.click(function(){
							popup.hide();
						});
						overlay.click(function(){
							popup.hide();
						});		
						
						nav.show();
						
						
					});	
					popup.curWidth=content.width();			
				}
			});	
		});		
	}
	
		
	popup.empty = function() {
		popupContent.empty();
	}
	
	popup.hide = function() {
		cur=0;
		nav.hide();
		popup.stop(true).animate({
			'opacity':0
		},200,function(){
			popup.remove();
			overlay.remove();
		});				
	}
	
	popup.play = function(i) {
		i = parseInt(i);
		popup.show(i);
		
		/*
		popupContent.stop(true).animate({'opacity':0},200,function(){
			popupContent.empty();
			popupContent.append(contents[i]);
			popupContent.stop(true).animate({'opacity':1},200,function(){
				nav.show();
			});
		});*/	
	}
	
	
	
			
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
	
	

	popupContent.appendTo(popup);
	loading.appendTo(popup);
	nav.hide();	
	nav.left.css({'cursor':'pointer','position':'absolute'});
	nav.left.appendTo(popup);
	nav.right.css({'cursor':'pointer','position':'absolute'});
	nav.right.appendTo(popup);
	nav.x.css({'cursor':'pointer','position':'absolute'});
	nav.hide();
	nav.x.appendTo(popup);
	
	
	// start & Events	
	$(window).resize(function(){
		var pageSize = getPageSize();
		var pageScroll = getPageScroll();
		//var width = args.width!=0? args.width : contents[cur].width();
		var width = popup.curWidth;
		overlay.css({
			'width':pageSize[0],
			'height':pageSize[1]
		});
		popup.css({
			'top' : pageScroll[1]+(pageSize[3]/10)+'px',
			'left': pageScroll[0]+((pageSize[0]-width)/2)+'px'
		});
		
	});
	
	$this.each(function(i,el){
		$(this).click(function(){
			popup.show(i);
			return false;
		});
	});
	
	
	
	return popup;
	
	
	
}
