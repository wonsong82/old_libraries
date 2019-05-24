(function($){

$.hash=function(){
	var hash=$({});
	var defaultHash='';
	
	var names=[];
	var funcs=[];
	
	hash.add=function(name, func){	
		if(names.indexOf(name)==-1){
			names.push(name);
			funcs.push(func);
			if(currentHash()==name){
				func(name);
			}
		}		
	};
	
	hash.remove=function(name){
		if(names.indexOf(name)!=-1){
			var i = names.indexOf(name);
			names.splice(i,1);
			funcs.splice(i,1);			
		}
	};
	
	hash.change=function(name){
		if(names.indexOf(name)!=-1){
			window.location.hash=name;			
		}
	};
	
	hash.forceDefault=function(name){
		if(names.indexOf(name)==-1){
			throw('hash: Default Hash must be added first.');
			return;
		}
		defaultHash=name;
		if(currentHash()==''){
			hash.change(name);
		}
	};
	
	window.addEventListener("hashchange",function(){
		var i = names.indexOf(currentHash());
		if(i!=-1){
			funcs[i](names[i]);
			return false;
		}				
	});
	
	function currentHash(){
		return (window.location.hash).replace("#","");
	}
	
	return hash;
}


	
})(jQuery);