/** Program : Tween.as
 *	Desc 	: Custom Tweening Class
 */

package won
{
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	import flash.filters.*;
			
	public class Tween
	{
		private var target:Object; // target
		private var maxFrame:Number; // time		
		private var parameters:Object; // parameters		
		private var curFrame:uint = 0;
		private var ease:Function;
		private var delayTimer:uint;
		
		public function Tween($t:Object, $s:Number, $p:Object, $e:Function)
		{
			if ($t.stage == null){
				W.remove(this);
				return;
			}
			target = $t;
			maxFrame = Math.floor($t.stage.frameRate * $s);							
			ease = $e;
									
			parameters = $p;
			parameters.x = defineParam($t.x, $p.x);
			parameters.y = defineParam($t.y, $p.y);
			//parameters.z = defineParam($t.z, $p.z);
			parameters.width = defineParam($t.width, $p.width);
			parameters.height = defineParam($t.height, $p.height);
			parameters.scaleX = defineParam($t.scaleX, $p.scaleX);
			parameters.scaleY = defineParam($t.scaleY, $p.scaleY);
			//parameters.scaleZ = defineParam($t.scaleZ, $p.scaleZ);
			parameters.alpha = defineParam($t.alpha, $p.alpha);
			parameters.rotation = defineParam($t.rotation, $p.rotation);
			//parameters.rotationX = defineParam($t.rotationX, $p.rotationX);
			//parameters.rotationY = defineParam($t.rotationY, $p.rotationY);
			//parameters.rotationZ = defineParam($t.rotationZ, $p.rotationZ);
			parameters.tint = defineTint($t,$p);
			parameters.filters = defineFilters($t,$p);
			
			if (!$p.delay) target.addEventListener(Event.ENTER_FRAME, update);
			else {				
				delayTimer = setInterval(function(){
					target.addEventListener(Event.ENTER_FRAME, update);					
					clearInterval(delayTimer);
				}, $p.delay*1000);
				
			}
		}		
		
		
		
		private function defineParam($init, $final):Array //if the param was set, return the array of [initial value, final(range)value], otherwise return null;
		{
			return ($final != null) ? [$init, ($final-$init)] : null;
		}	
		
		private function defineRGBParam($init, $final):Object
		{
			var initColor:String = toHex($init);
			var finalColor:String = toHex($final);
			var initR:uint = uint("0x"+initColor.substr(2,2));
			var initG:uint = uint("0x"+initColor.substr(4,2));
			var initB:uint = uint("0x"+initColor.substr(6,2));
			var finalR:uint = uint("0x"+finalColor.substr(2,2));
			var finalG:uint = uint("0x"+finalColor.substr(4,2));
			var finalB:uint = uint("0x"+finalColor.substr(6,2));			
			
			return {r:defineParam(initR,finalR), g:defineParam(initG,finalG), b:defineParam(initB,finalB)};			
		}
		
		
		private function defineTint($t:Object, $p:Object):Object
		{			
			if ($p.tint == null) return null;
			else {				
				var init:ColorTransform = $t.transform.colorTransform;		
			
				var final:ColorTransform;
				if ($p.tint == "original"){
					final = new ColorTransform(1,1,1,1,0,0,0,0);				
				} else {
					final = new ColorTransform();			
					final.redMultiplier = final.blueMultiplier = final.greenMultiplier = ($p.tint.saturation)? $p.tint.saturation : 0;
					final.alphaMultiplier = 1;
					final.redOffset = W.traceRGB($p.tint.color).red;
					final.greenOffset = W.traceRGB($p.tint.color).green;
					final.blueOffset = W.traceRGB($p.tint.color).blue;
					final.alphaOffset = 0;
				}
				
				var tint:Object = new Object();
				tint.redMultiplier = defineParam(init.redMultiplier, final.redMultiplier);
				tint.greenMultiplier = defineParam(init.greenMultiplier, final.greenMultiplier);
				tint.blueMultiplier = defineParam(init.blueMultiplier, final.blueMultiplier);
				tint.alphaMultiplier = defineParam(init.alphaMultiplier, final.alphaMultiplier);
				tint.redOffset = defineParam(init.redOffset, final.redOffset);
				tint.greenOffset = defineParam(init.greenOffset, final.greenOffset);
				tint.blueOffset = defineParam(init.blueOffset, final.blueOffset);
				tint.alphaOffset = defineParam(init.alphaOffset, final.alphaOffset);
				
				return tint;
			}
		}		
		
		private function defineFilters($t:Object, $p:Object):Object
		{
			if ($p.blur==null && $p.shadow==null && $p.glow==null) return null;
			else {
				var filter:Array = $t.filters;
				var hasBlurFilter:Boolean = hasFilter($t.filters, BlurFilter);
				var hasShadowFilter:Boolean = hasFilter($t.filters, DropShadowFilter);
				var hasGlowFilter:Boolean = hasFilter($t.filters, GlowFilter);
				
				if ($p.blur!=null){
					var blurInit:BlurFilter = (hasBlurFilter)? getFilterFrom($t.filters, BlurFilter) as BlurFilter : new BlurFilter(0,0);
					var blurFinal:Object = {
						blurX : ($p.blur.blurX!=null)? $p.blur.blurX : 4,
						blurY : ($p.blur.blurY!=null)? $p.blur.blurY : 4,
						quality : ($p.blur.quality!=null)? $p.blur.quality : 1
					}
					var blurF:Object = {
						name : "blur",
						blurX : defineParam(blurInit.blurX, blurFinal.blurX),
						blurY : defineParam(blurInit.blurY, blurFinal.blurY),
						quality : defineParam(blurInit.quality, blurFinal.quality)
					}
					if (hasBlurFilter) replaceFilter(filter, blurF, BlurFilter);
					else filter.push(blurF);
				}
				
				if ($p.shadow!=null){
					var shadowInit:DropShadowFilter = (hasShadowFilter)? getFilterFrom($t.filters, DropShadowFilter) as DropShadowFilter : new DropShadowFilter(0,45,0,1,0,0,1,1);
					var shadowFinal:Object = {
						distance : ($p.shadow.distance!=null)? $p.shadow.distance : 4,
						angle : ($p.shadow.angle!=null)? $p.shadow.angle : 45,
						alpha : ($p.shadow.alpha!=null)? $p.shadow.alpha : 1,
						blurX : ($p.shadow.blurX!=null)? $p.shadow.blurX : 4,						
						blurY : ($p.shadow.blurY!=null)? $p.shadow.blurY : 4,
						strength : ($p.shadow.strength!=null)? $p.shadow.strength : 1,
						quality : ($p.shadow.quality!=null)? $p.shadow.quality : 1,
						color: ($p.shadow.color!=null)? $p.shadow.color : shadowInit.color,
						inner: ($p.shadow.inner!=null)? $p.shadow.inner : shadowInit.inner,
						knockout: ($p.shadow.knockout!=null)? $p.shadow.knockout : shadowInit.knockout,
						hideObject: ($p.shadow.hideObject!=null)? $p.shadow.hideObject : shadowInit.hideObject
					}
					var shadowF:Object = {
						name : "shadow",
						distance : defineParam(shadowInit.distance, shadowFinal.distance),
						angle : defineParam(shadowInit.angle, shadowFinal.angle),
						alpha : defineParam(shadowInit.alpha, shadowFinal.alpha),
						blurX : defineParam(shadowInit.blurX, shadowFinal.blurX),
						blurY : defineParam(shadowInit.blurY, shadowFinal.blurY),
						strength : defineParam(shadowInit.strength, shadowFinal.strength),
						quality : defineParam(shadowInit.quality, shadowFinal.quality),
						color : defineRGBParam(shadowInit.color, shadowFinal.color),
						inner : shadowInit.inner,
						knockout : shadowInit.knockout,
						hideObject : shadowInit.hideObject
					}
					if (hasShadowFilter) replaceFilter(filter, shadowF, DropShadowFilter);
					else filter.push(shadowF);				
				}
				
				if ($p.glow!=null){
					var glowInit:GlowFilter = (hasGlowFilter)? getFilterFrom($t.filters, GlowFilter) as GlowFilter : new GlowFilter(0xff0000,1,0,0);
					var glowFinal:Object = {
						alpha : ($p.glow.alpha!=null)? $p.glow.alpha : 1,
						blurX : ($p.glow.blurX!=null)? $p.glow.blurX : 6,
						blurY : ($p.glow.blurY!=null)? $p.glow.blurY : 6,
						strength: ($p.glow.strength!=null)? $p.glow.strength : 2,
						quality: ($p.glow.quality!=null)? $p.glow.quality : 1,
						color: ($p.glow.color!=null)? $p.glow.color : glowInit.color,
						inner: ($p.glow.inner!=null)? $p.glow.inner : glowInit.inner,
						knockout: ($p.glow.knockout!=null)? $p.glow.knockout : glowInit.knockout
					}
					var glowF:Object={
						name : "glow",
						alpha: defineParam(glowInit.alpha, glowFinal.alpha),
						blurX: defineParam(glowInit.blurX, glowFinal.blurX),
						blurY: defineParam(glowInit.blurY, glowFinal.blurY),
						strength: defineParam(glowInit.strength, glowFinal.strength),
						quality: defineParam(glowInit.quality, glowFinal.quality),
						color: defineRGBParam(glowInit.color, glowFinal.color),
						inner: glowFinal.inner,
						knockout: glowFinal.knockout
					}					
					if (hasGlowFilter) replaceFilter(filter, glowF, GlowFilter);
					else filter.push(glowF);				
				}			
			}
			return filter;
		}
		
		private function hasFilter($t:Array, $f:*):Boolean
		{
			for (var i:int=0; i<$t.length; i++){
				if ($t[i].constructor == $f) return true;
			}
			return false;
		}
		
		private function getFilterFrom($t:Array, $f:*):*
		{
			for (var i:int=0; i<$t.length; i++){
				if ($t[i].constructor == $f){										
					return $t[i];
				}
			}
		}
		
		private function replaceFilter($t:Array, $r:*, $f:*):void
		{
			for (var i:int=0; i<$t.length; i++){
				if ($t[i].constructor == $f) $t[i] = $r;
			}
		}
		
		
		private function changeColor():void
		{
			var color:ColorTransform = new ColorTransform();
			color.redMultiplier = updateValue(parameters.tint.redMultiplier);
			color.greenMultiplier = updateValue(parameters.tint.greenMultiplier);
			color.blueMultiplier = updateValue(parameters.tint.blueMultiplier);
			color.alphaMultiplier = updateValue(parameters.tint.alphaMultiplier);
			color.redOffset = updateValue(parameters.tint.redOffset);
			color.greenOffset = updateValue(parameters.tint.greenOffset);
			color.blueOffset = updateValue(parameters.tint.blueOffset);
			color.alphaOffset = updateValue(parameters.tint.alphaOffset);			
			target.transform.colorTransform = color;				
		}
		
		private function changeFilters():void
		{			
			var newFilters:Array = [];	
						
			for (var i:int=0; i<parameters.filters.length; i++){
				if (parameters.filters[i].constructor==Object){
					if (parameters.filters[i].name == "blur"){
						var blurBlurX:Number = updateValue(parameters.filters[i].blurX);
						var blurBlurY:Number = updateValue(parameters.filters[i].blurY);
						var blurQuality:int = Math.round(updateValue(parameters.filters[i].quality));
						newFilters[i] = new BlurFilter(blurBlurX, blurBlurY, blurQuality);						
					}
					if (parameters.filters[i].name == "shadow"){
						var shadowDistance:Number = updateValue(parameters.filters[i].distance);
						var shadowAngle:Number = updateValue(parameters.filters[i].angle);
						var shadowColor:uint = updateColorValue(parameters.filters[i].color);
						var shadowAlpha:Number = updateValue(parameters.filters[i].alpha);
						var shadowBlurX:Number = updateValue(parameters.filters[i].blurX);
						var shadowBlurY:Number = updateValue(parameters.filters[i].blurY);
						var shadowStrength:Number = updateValue(parameters.filters[i].strength);
						var shadowQuality:int = Math.round(updateValue(parameters.filters[i].quality));
						var shadowInner:Boolean = parameters.filters[i].inner as Boolean;
						var shadowKnockout:Boolean = parameters.filters[i].knockout as Boolean;
						var shadowHideObject:Boolean = parameters.filters[i].hideObject as Boolean;						
						newFilters[i] = new DropShadowFilter(shadowDistance,shadowAngle,shadowColor,shadowAlpha,
															 shadowBlurX,shadowBlurY,shadowStrength,shadowQuality,
															 shadowInner,shadowKnockout,shadowHideObject);
					}
					if (parameters.filters[i].name == "glow"){
						var glowColor:uint = updateColorValue(parameters.filters[i].color);
						var glowAlpha:Number = updateValue(parameters.filters[i].alpha);
						var glowBlurX:Number = updateValue(parameters.filters[i].blurX);
						var glowBlurY:Number = updateValue(parameters.filters[i].blurY);
						var glowStrength:Number = updateValue(parameters.filters[i].strength);
						var glowQuality:int = Math.round(updateValue(parameters.filters[i].quality));
						var glowInner:Boolean = parameters.filters[i].inner as Boolean;
						var glowKnockout:Boolean = parameters.filters[i].knockout as Boolean;
						newFilters[i] = new GlowFilter(glowColor,glowAlpha,glowBlurX,glowBlurY,glowStrength,
													   glowQuality,glowInner,glowKnockout);
					}
				}			
				
				else {
					newFilters[i] = parameters.filters[i];
				}
			}
			target.filters = newFilters;						
		}
						
		private function update(e:Event):void
		{
			if (target.stage == null){
				W.remove(this);
				return;
			}
			//trace (target.x);
			curFrame++;			
			if (parameters.x) target.x = updateValue(parameters.x); 
			if (parameters.y) target.y = updateValue(parameters.y);
			//if (parameters.z) target.z = updateValue(parameters.z);
			if (parameters.width) target.width = updateValue(parameters.width);
			if (parameters.height) target.height = updateValue(parameters.height);
			if (parameters.scaleX) target.scaleX = updateValue(parameters.scaleX);
			if (parameters.scaleY) target.scaleY = updateValue(parameters.scaleY);
			//if (parameters.scaleZ) target.scaleZ = updateValue(parameters.scaleZ);
			if (parameters.alpha) target.alpha = updateValue(parameters.alpha);
			if (parameters.rotation) target.rotation = updateValue(parameters.rotation);
			if (parameters.rotationX) target.rotationX = updateValue(parameters.rotationX);
			if (parameters.rotationY) target.rotationY = updateValue(parameters.rotationY);
			//if (parameters.rotationZ) target.rotationZ = updateValue(parameters.rotationZ);			
			if (parameters.tint) changeColor();
			if (parameters.filters) changeFilters();
			
			if (curFrame >= maxFrame){
				if (parameters.onComplete) parameters.onComplete();				
				stop();
			}
		}
		
				
		
		private function updateValue($pArray):Number //returns the current value in time depending on the ease you use;
		{			
			return ease(curFrame, $pArray[0], $pArray[1], maxFrame); //initial time, initial value, value in changes(final), final time
		}
		
		private function updateColorValue($pArray):uint
		{
			var r:String = toHex(Math.round(ease(curFrame, $pArray.r[0], $pArray.r[1], maxFrame)),2).substr(2,2);
			var g:String = toHex(Math.round(ease(curFrame, $pArray.g[0], $pArray.g[1], maxFrame)),2).substr(2,2);
			var b:String = toHex(Math.round(ease(curFrame, $pArray.b[0], $pArray.b[1], maxFrame)),2).substr(2,2);;
			
			return uint("0x"+r+g+b);			
		}
		
		private function toHex($number:uint, minimumLength:uint = 6):String 
		{
			var string:String = $number.toString(0x10).toUpperCase();
			while (minimumLength > string.length) {
				string = "0" + string;
			}
			return "0x" + string;			
		}
		
		
		
		
		// public functions
		public function stop():void
		{
			clearInterval(delayTimer);
			target.removeEventListener(Event.ENTER_FRAME, update);
			W.remove(this);
		}
		
	}
}