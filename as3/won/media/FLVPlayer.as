package won.media
{
	import flash.net.*;
	import flash.media.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	public class FLVPlayer extends EventDispatcher
	{
		private var _currentMedia:MediaData;
		private var _cxn:NetConnection;
		private var _stream:NetStream;
		private var _timer:Timer;
		private var _soundTransform:SoundTransform;
		private var _lastPos:Number;
		private var _lastVolume:Number=1;
		private var _muted:Boolean=false;
		private var _paused:Boolean=false;
		private var _playing:Boolean=false;
		private var _mediaFinished:Boolean=false;
		private var _streamStatus:Array;
		private var _video:Video;
		private var _fullyLoaded:Boolean=false;
		private var _bufferTime:Number=1;
		private var _buffering:Boolean=false;
		
		public function set video($video:Video):void{_video=$video;}
		public function get video():Video{return _video;}
		public function get playing():Boolean{return _playing;}
		public function get paused():Boolean{return _paused;}
		public function get currentMedia():MediaData{return _currentMedia;}
		public function get volume():Number{return _lastVolume*100;}
		public function get position():Number{return (_stream!=null)? _stream.time:0;}
		public function get duration():Number{return (_currentMedia!=null)? _currentMedia.duration:-1;}
			
		public function FLVPlayer()
		{
			_soundTransform=new SoundTransform();
			_timer=new Timer(40);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			_streamStatus=[];
		}
		
		public function onTimer(e:TimerEvent):void
		{
			var total:Number = _stream.bytesTotal;
			var loaded:Number = _stream.bytesLoaded;
			
			dispatchEvent(new MediaTimeEvent(MediaTimeEvent.TIME,_stream.time,loaded,total));			
			if (loaded > 500 && loaded==total && !_fullyLoaded){
				dispatchEvent(new MediaEvent(MediaEvent.FULLY_LOADED));
				_fullyLoaded=true;				
			}
			
			if (_currentMedia!=null&&_playing){				
				var timeLoaded:Number = _stream.bytesLoaded/_stream.bytesTotal*_currentMedia.duration;
				if (loaded > 500 && timeLoaded < _stream.time+_bufferTime && timeLoaded>=_stream.time){
					var bufferPercent:Number = ((timeLoaded - _stream.time)/_bufferTime);
					_buffering = true;
					dispatchEvent(new MediaTimeEvent(MediaTimeEvent.BUFFER,_stream.time,loaded,total,bufferPercent));								
				} else {
					if (_buffering == true){
						_buffering = false;
						bufferPercent = 1;
						dispatchEvent(new MediaTimeEvent(MediaTimeEvent.BUFFER,_stream.time,loaded,total,bufferPercent));
					}
				}
			}
			
			
		}
		
		public function mute($muted:Boolean=true):void
		{
			_muted=$muted;
			if(_muted){
				_soundTransform.volume=0;
				_stream.soundTransform=_soundTransform;				
			}else{
				_soundTransform.volume=_lastVolume;
				_stream.soundTransform=_soundTransform;
			}
		}
		
		public function setVolume($vol:Number):void
		{
			_lastVolume=_soundTransform.volume=$vol/100;
			if(!_muted) _stream.soundTransform=_soundTransform;
		}
		
		public function connect():void
		{
			//stops the stream
			stop(); 
			
			//if _stream or _cxn open , close em
			if (_stream!=null){ 
				_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,onAsyncError);
				_stream.removeEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
				_stream.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
				_stream.close();
			}
			if (_cxn!=null){
				_cxn.removeEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
				_cxn.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
				_cxn.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
				_cxn.close();
			}
			
			//create a new connection
			_cxn=new NetConnection();
			_cxn.connect(null);
			_cxn.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			_cxn.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
			_cxn.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
			
			//create a new stream
			_stream=new NetStream(_cxn);
			_stream.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			_stream.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR,onAsyncError);
			_stream.client=this;
						
			_video.attachNetStream(_stream);
			_stream.bufferTime=_bufferTime;
			_stream.receiveAudio(true);
			_stream.receiveVideo(true);
		}
		
		public function playMedia($media:MediaData):void
		{
			_mediaFinished=false;
			if($media==null) return;
			_currentMedia=$media;
			_streamStatus=[];
			play(true);
		}
		
		public function reset():void
		{
			connect();
		}
		
		public function play($forced:Boolean=false):void
		{
			if(_paused&&!$forced){
				_stream.resume();
				_paused=false;
				_timer.start();
				return;
			}
			connect();
			_stream.play(currentMedia.url);
			setVolume(this._lastVolume*100);
			_playing=true;
			_paused=false;
			_timer.start();			
		}
		
		public function stop():void
		{
			if(!_playing) return;
			_stream.pause();
			_playing=false;
			_timer.stop();
		}
		
		public function pause():void
		{
			_stream.pause();
			_paused=true;
			_timer.stop();
		}
		
		public function seek($sec:Number):void
		{
			if ($sec<_currentMedia.duration-2&&_playing){
				_lastPos=_stream.time;
				_stream.seek($sec);
				_stream.resume();
				_paused=false;
			}
		}
		
		public function onMetaData(info:Object):void
		{
			if(info.duration!=null){
				dispatchEvent(new MediaTimeEvent(MediaTimeEvent.DURATION,info.duration));
				_currentMedia.duration=info.duration;
			}
			
			var lclHeight:Number=info.height;
			var lclWidth:Number=info.width;
			if(isNaN(lclHeight)||isNaN(lclWidth)){
				lclWidth=425;
				lclHeight=320;
			}
			dispatchEvent(new MediaSizeEvent(MediaSizeEvent.SIZE,lclWidth,lclHeight));
			if(!willTrigger(MediaSizeEvent.SIZE)){
				var yDif:Number=(_video.height-lclHeight)/2;
				_video.y+=yDif;
				_video.height=lclHeight;
			}
		}
		
		
		
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			trace ("Stream.securityError");
			dispatchEvent(new MediaEvent(MediaEvent.ERROR,e.text));
		}
		
		private function onIOError(e:IOErrorEvent):void		
		{
			trace ("Stream.ioError");
			dispatchEvent(new MediaEvent(MediaEvent.ERROR,e.text));
		}
		
		private function onAsyncError(e:AsyncErrorEvent):void
		{
			trace ("AsyncError");
			dispatchEvent(new MediaEvent(MediaEvent.ERROR,e.text));			
		}
		
		private function onNetStatus(e:NetStatusEvent):void
		{
			if(e.info.code=="NetStream.Seek.InvalidTime"){
				_stream.seek(_lastPos);
				_stream.resume();
			}else{
				pushStatus(e.info.code);
				analyzeStatus();
			}
		}
		
		private function pushStatus($status:String):void
		{
			_streamStatus.push($status);
			while(_streamStatus.length>3) _streamStatus.shift();
		}		
		
		private function analyzeStatus():void
		{
			var stopIdx:Number=_streamStatus.lastIndexOf("NetStream.Play.Stop");
			var flushIdx:Number=_streamStatus.lastIndexOf("NetStream.Buffer.Flush");
			var emptyIdx:Number=_streamStatus.lastIndexOf("NetStream.Buffer.Empty");
			var mediaFinished:Boolean=false;
			if(stopIdx>-1&&flushIdx>-1&&emptyIdx>-1){
				if(flushIdx<stopIdx&&stopIdx<emptyIdx) mediaFinished=true;
			}else if(flushIdx>-1&&emptyIdx>-1){
				if (flushIdx<emptyIdx) mediaFinished=true;
			}else if(stopIdx>-1&&flushIdx>-1) mediaFinished=true;
			if (mediaFinished){
				dispatchEvent(new MediaEvent(MediaEvent.FINISHED));
				while(_streamStatus.length>0) _streamStatus.pop();
			}else if(_streamStatus[_streamStatus.length-1]=="NetStream.Play.Start")
				dispatchEvent(new MediaEvent(MediaEvent.STARTED));
		}
	}
}