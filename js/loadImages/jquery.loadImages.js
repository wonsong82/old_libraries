(function(c){
	var h=[];
	c.loadImages=function(a,d){
		a instanceof Array||(a=[a]);
		for(var e=a.length,f=0,g=e;g--;){
			var b=document.createElement("img");
			b.onload=function(){
				f++;
				f>=e&&c.isFunction(d)&&d();
			}
			b.src=a[g];
			h.push(b);
		}
	}
})(jQuery);// JavaScript Document