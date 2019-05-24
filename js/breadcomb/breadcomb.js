/*
Whatever contains list of anchors
<section class="breadcomb">
	<a href="#aaa">dfasf</a>
	<a href="#bbb">dafdasf</a>
</section>

var bc = $('.breadcomb').breadComb();
bc.step(1); // move the breadcomb arrow to step1

*/
(function($){
	$.fn.breadComb=function(){
		var $this=$(this);
		var last=$('a', this).length-1;
		var barStart=0;
		var barEnd=0;
		var steps=[];
		var stepbar;
		if($(this).css('position')=='static')
			$(this).css('position','relative');
		$(this).height($(this).height()+50);	
		$('a',this).each(function(i,e){
			$(this).css({'position':'relative','top':'50px'});
			$(this).attr('arrow-x', (($(this).width()-12)*0.5)+$(this).position().left+parseInt($(this).css('margin-left')));
			$(this).attr('bar-x', parseInt($(this).attr('arrow-x'))+7);		
			if(i==0){
				barStart=$(this).attr('bar-x');
			}
			else if(i==last){			
				barEnd=$(this).attr('bar-x');
			}
			
			var arrow=$('<div/>').addClass('arrow').addClass('arrow'+i).addClass('step').css({
					'position':'absolute',
					'width':'12px',
					'height':'20px',
					'left':$(this).attr('arrow-x')+'px',
					'top':'12px'
				}).appendTo($this);					
			
			steps.push($(this));
		});
		$('<div/>').css({
				'width':barEnd-barStart+'px',
			'height':'4px',
			'position':'absolute',
			'left':barStart+'px',
			'top':'20px',
			'background':'#dbdbdb'
		}).prependTo(this);
		
		stepbar=$('<div/>').css({
			'position':'absolute',
			'top':'20px',
			'left':barStart+'px',
			'width':'0px',
			'height':'4px',
			'background':'#ff41b2'
		}).appendTo(this);
		
		steparrow=$('<div/>').addClass('arrow').addClass('active').css({
			'position':'absolute',
			'top':'12px',
			'left':parseInt(steps[0].attr('arrow-x'))+'px',
			'width':'12px',
			'height':'20px'
		}).appendTo(this);
		
		$this.step=function(stepNumber){
			stepbar.stop(true,true,true)
				.animate({width:(parseInt(steps[stepNumber-1].attr('bar-x'))-barStart)+'px'},300);
			steparrow.stop(true,true,true)
				.animate({left:parseInt(steps[stepNumber-1].attr('arrow-x'))+'px'},300);
			$('.step').removeClass('active');				
			for(var i=0; i<stepNumber-1; i++){				
				$('.arrow'+i).addClass('active');
			}
		};
		
		
		return $this;
	};
		
		
})(jQuery);