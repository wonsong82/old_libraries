/*
Name : Banner
Pre-req : jquery, jquery ui, loadImages

Install : 
	single div element contains ul must be passed in.
	each li(s) will be slided.
	
	<div id="banner">
		<ul>
			<li><img src=""/></li>
			<li><h3>hello</h3><a href=""><img></a></li>
		</ul>
	</div>
	
	$('#banner').banner();

To be added : other transition types & thumbnail

*/
(function($){

$.fn.banner=function(args){
	
	/////////////////////////////////////////////////////
	// Error Checking
	if($('ul',this).length<1){ // ul
		throw "Banner:: Passed element do not contain ul.";
		return false;
	}
	if($.isFunction($.loadImages)!=true){ // loadimages
		throw "jquery.loadImages must be loaded first";
		return false;
	}
	
	var $this = $(this[0]);
		
	///////////////////////////////////////////////////////
	// Set Argumental Variables
	args=$.extend({}, $.fn.banner.defaultArgs, args);
	//args.width = args.width || $this.width();
	//args.height = args.height || $this.height();
	
	
	///////////////////////////////////////////////////////
	// Expandable
	// Parse args for specific types
	
	// Fade
	if(args.type=='fade')
		args.speed=args.speed||2;
	
	// Slide
	else if(args.type=='slide')
		args.speed=args.speed||1;
		
	
	if(args.speed>args.interval){
		throw "Transition speed cannot be larger than transition interval.";
		return false;
	}
	
	
	/////////////////////////////////////////////////////
	// Set Variables
	var cur=0;
	var timer=null; //Timer for the transition intervals
	var inhover=false;
	var intransit=false;
	var con=$('<div class="wonbanner"/>'); //Container that everything resides in (banner, loading, navs).
	var banner=$('<div/>');	
	var loading=$('<div class="loading"/>'); //Style controlled by css
	var navLeft=$('<div class="nav-left"/>'); //Style controlled by css
	var navRight=$('<div class="nav-right"/>'); //Style controlled by css
	var indicator=$('<div class="indicator"/>'); //Style controlled by css
	var list=[]; //Array of elements to be displayed and slided.
	var imgs=[]; //Separte imgs array for preload.
	
	// Clone elements so we can keep the original
	$this.find('li').each(function(){
		list.push($(this).clone());
	});
	if (list.length==0){
		throw "0 elements found for the slides.";
		return false;
	}
	
	// Get imgs for preload
	$this.find('img').each(function(){
		imgs.push($(this).attr('src'));
	});
	$this.find('ul').css({'opacity':0});
	
	// Define functions
	function showLoading(){
		loading.addClass('loading');
	}
	function hideLoading(){
		loading.removeClass('loading');
	}
	function showNav(){
		navLeft.css('display','block');
		navRight.css('display','block');
	}
	function hideNav(){
		navLeft.css('display','none');
		navRight.css('display','none');
	}
	indicator.hide=function(){
		indicator.css('display','none');
	};
	indicator.show=function(){
		indicator.css('display','block');
	};
	
	function play(){
		clearInterval(timer);
		if(list.length>1){
			timer=setInterval(function(){
				next();
			},args.interval*1000);
		}
	}
	function pause(){
		clearInterval(timer);
	}
	
	// Next function, differs by its transition types
	// Arg : true (forward), false(backword), int(index)
	function next(arg){
		intransit=false;
		f=typeof arg !== 'undefined'? arg:true;//Forward is true or false, false=backward
		
		var c=cur; //Cur Index
		var n; //Next Index
		var d; //Direction
		if(arg===true || arg==null || typeof arg === 'undefined'){
			n=c>=list.length-1?0:c+1; //Next
			d=1;
		}
		else if(arg===false){
			n=c==0?list.length-1:c-1; //Prev
			d=-1;
		}
		else if(parseInt(arg)>=0){
			n=parseInt(arg);
			d=n>c?1:-1;
		}
		else{
			n=c>=list.length-1?0:c+1;
			d=1;
		}
		
		hideNav(); //Hide nav and show when transition is done
		//indicator.hide(); //Hide indicator
		intransit=true;
		


/////////////////////////////////////////////////////////////////////////////////////////		
		///////////////////
		// Animation for each types
		
		// Fade
		if(args.type=='fade'){
			banner.empty();
			var element1,element2;
			element1=c==-1?$('<div/>'):list[c].clone();//if init is true, element1 is empty div, otherwise its the clone of the first one from list.
			element1.css({'opacity':1,'position':'absolute','top':'0px','left':'0px'}).appendTo(banner);
			element2=list[n].clone();
			element2.css({'opacity':0,'position':'absolute','top':'0px','left':'0px'}).appendTo(banner);
			element1.stop(true).animate({'opacity':0},args.speed*1000);
			element2.stop(true).animate({'opacity':1},args.speed*1000);
		}
		
		// Slide
		if(args.type=='slide'){
			banner.empty().css({'top':'0px','left':'0px'});
			var element1,element2,e2PosX;
			element1=c==-1?$('<div/>'):list[c].clone();
			element1.css({
				'position':'absolute','top':'0px','left':'0px'
			}).appendTo(banner);
			element2=list[n].clone();
			e2PosX=element1.width() * d;
			element2.css({
				'position':'absolute','top':'0px','left':e2PosX+'px'
			}).appendTo(banner);
			banner.stop(true).animate({'left':-1*e2PosX+'px'},args.speed*1000);
		}
		
		if(args.showIndicator==true){
			$('a',indicator).removeClass('current');
		}
		
		
		
		
		
		
		///////////////////////////////////
		banner.timer=setTimeout(function(){ //increase the timer when the time is completely done.
			if(arg==true||arg==null||typeof arg==='undefined')
				cur=cur>=list.length-1?0:cur+1;
			else if(arg===false)
				cur=cur==0?list.length-1:cur-1;
			else
				cur=parseInt(arg);
			
			intransit=false;
			if(inhover==true) showNav();
			
			if(args.showIndicator==true){
				$('a',indicator).each(function(i,e){
					if(cur==i) $(e).addClass('current');
				});
			}
						
		}, args.speed*1000);				
	}
	

///////////////////////////////////////////////////////////////////////////////////////////////////	
// STRUCTURE /////////////////////////////////////////////////////////////////////////////////////	
	
	
	//
	// Structures for general
	//
	
	//If root is static, make it to relative so other elements can be added.
	if ($this.css('position')=='static') 
		$this.css('position','relative');	
	
	//Where all the slide banners will resides
	banner.css({ 
		'width':'100%','height':'100%',
		'position':'absolute','left':'0px','top':'0px'
	}).appendTo(con);
	
	 //Add navs if its enabled
	if(args.showNav==true){
		navLeft.css({ //CSS defines img, width, height, top, left
			'position':'absolute',
			'cursor':'pointer',
			'display':'none'
		}).appendTo(con);
		navRight.css({
			'position':'absolute',
			'cursor':'pointer',
			'display':'none'
		}).appendTo(con);
	}
	
	//Add indicator if its enabled
	if(args.showIndicator==true){
		for(var i=0;i<list.length;i++){
			var dot = $('<a/>').attr('index',i).attr('href','#');
			if(cur==i) dot.addClass('current');
			dot.appendTo(indicator);
		}
		indicator.appendTo(con);
	}
	
	
	loading.css('position','absolute').removeClass('loading').appendTo(con);
	con.css({ //Container where all the elements resides in
		'width':'100%','height':'100%',
		'position':'absolute','top':'0px','left':'0px',
		'overflow':'hidden'
	}).appendTo($this);

	
	//
	// Structures for specific types
    //

	// Fade Slider
	if(args.type=='fade'){}
	
	// Slide Slider
	if(args.type=='slide'){}	
	
	




////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////


	// Start the Banner
	
	showLoading();
	$.loadImages(imgs,function(){
		hideLoading();
		if(args.init==true){
			cur=-1;
			next();
			play();
		}
		else{ // Init Elements			

//////////////////////////////////////////////////////////////////////////////////////////		
			// Fade
			if (args.type=='fade'){
				var element1=list[0].clone();
				element1.appendTo(banner);
			}
			
			// Slide Slider
			if (args.type=='slide'){
				var element1=list[0].clone();
				element1.appendTo(banner);
			}
			
			play();
		}
		
		//Interactions
		$this.hover(function(){
			inhover=true;
			if(intransit==false)
				showNav();
			pause();
		},function(){
			inhover=false;
			if(intransit==false)
				hideNav();
			play();
		});
		navLeft.click(function(){
			pause();
			next(false);
			play();
		});
		navRight.click(function(){
			pause();
			next(true);
			play();
		});
		$('a',indicator).click(function(){
			var index=$(this).attr('index');
			if(index!=cur && intransit==false){
				pause();
				next($(this).attr('index'));
				play();
			}
			return false;
		});
	});
	
	$this.destroy=function(){
		pause();
		con.remove();
		$this.find('ul').css({'opacity':1,'display':'block'});
	}
	
	$('ul',$this).css('display','none');
	return $this;		
};


// Args
$.fn.banner.defaultArgs={
	type:'fade',
	width:null,
	height:null,
	showNav:true,
	showThumb:false,
	showIndicator:true,
	interval:5,
	speed:null,
	init:false
};
	
})(jQuery);