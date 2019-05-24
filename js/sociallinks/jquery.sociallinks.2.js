/*
<a data-role=""></a>
*/
(function($){
$.fn.socialLinks=function(){
	
	var domains=[
		'facebook',
		'twitter',
		'youtube',
		'vimeo'
	];
	
	$('a[data-role="sociallink"]').each(function(){
		var iconnum=-1;
		for(var i=0;i<domains.length;i++){
			if($(this).attr('href').indexOf(domains[i])!=-1)
			iconnum=i;	
		}
		if(iconnum!=-1){
			$(this).addClass(domains[iconnum]).addClass('sociallink');			
		}
	});
}
})(jQuery);
$(function(){
	$(this).socialLinks();
});