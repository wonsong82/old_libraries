/*
<a data-role="

*/
(function($){
	
$.fn.socialIcons=function(){
	
	// Y position for color, y position for bw, size
	var pos=[
		[96,208,16], //small
		[64,176,32], //medium
		[0,112,64] //large
	];
	
	// Domains in icon sequence order to search for
	var domain=[
		'flickr.com',
		'facebook.com',
		'twitter.com',
		'yelp.com',
		'youtube.com',
		'citysearch.com',
		'rss.com',
		'foursquare.com'];
	
	$('a[data-role="sociallink"]').each(function(){
		var p;
		if($(this).attr('data-size')!='l' && $(this).attr('data-size')!='s')
			p = pos[1];		
		else
			p = $(this).attr('data-size')=='s'? pos[0]:pos[2];
		
		var iconnum=-1;
		for(var i=0;i<domain.length;i++)
			if($(this).attr('a').indexOf(domain[i])!=-1)
				iconnum=i;
		
		if(iconnum!=-1){
			$(this).css({
				'width':p[2]+'px',
				'height':p[2]+'px',
				'background-position':p*p[2]*-1+'px '+p[1]*-1+'px',
				'text-indent':'-9999px'
			}).addClass('sociallink');
			$(this).hover(function(){
				$(this).stop(true).animate({
					'background-position':p+p[2]*-1+'px '+p[0]*-1+'px'
				}, 300);
			},function(){
				$(this).stop(true).animate({
					'background-position':p*p[2]*-1+'px '+p[1]*-1+'px'
				}, 300);
			});
		}
		
		
	});	
	
}
	
	
})(jQuery);
$(function(){
	$.socialIcons();
});