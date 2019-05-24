var alert;
var alertDialog;

$(function(){
	
	var alertDialog=$('<div/>')
		.css({
			display:'none',
			position:'fixed',
			'z-index':999999
		})
		.addClass('alert');
	alertDialog.timer=null;
	
	alert=function(msg){
		clearTimeout(alertDialog.timer);		
		alertDialog.html(msg).css({'display':'block','opacity':0})
		.appendTo('body')
		.css({
			'margin-left':-1 * alertDialog.outerWidth() * 0.5 + 'px',
			'margin-top':-1 * alertDialog.outerHeight() * 0.5 + 'px'
		})
		.stop(true,true,true).animate({opacity:1},200);
		alertDialog.timer=setTimeout(function(){			
			alertDialog.animate({opacity:0},400, function(){
				alertDialog.css({'display':'none'}).remove();
			});
		},3000);	
	}
	
});