package com.sosappy.video {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;

	/**
	 * @author gpolguere
	 */
	public class VideoController extends EventDispatcher {
		
		private var _video : Video;
		private var _nc : NetConnection;
		private var _ns : NetStream;
		private var _listener : Object;
		private var _status : String;
		private var _container : Sprite;
		private var _metaData : MetaData;
		private var _loadTimer:Timer;
		private var _stage:Stage;
		private var _stageVideoAvailable:Boolean;
		private var _stageVideo:StageVideo;
		private var _stageVideoOn:Boolean;
		private var _stageVideoAvailabilitySet:Boolean;
		private var _setStageVideoWhenAvailable:Boolean;
		private var _loop:Boolean;
		
		public function VideoController(width : Number = 640, height : Number = 360, video : Video = null) : void {
			_video = video || new Video(width, height);
			
			_video.smoothing = true;
			
			_nc = new NetConnection();
			_nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_nc.connect(null);
			
			_ns = new NetStream(_nc);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_video.attachNetStream(_ns);
			
			_listener = {};
			_listener["onMetaData"] = onMetaData;
			_ns.client = _listener;
			
			_container = new Sprite();
			_container.addChild(_video);
			
			_loadTimer = new Timer(10);
			_loadTimer.addEventListener(TimerEvent.TIMER, onLoadTimer);
			
//			_video.x = (_background.width - _video.width) >> 1;
//			_video.y = (_background.height - _video.height) >> 1;
			
			_video.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			_video.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_stage = _video.stage;
			_stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideo);
		}
		
		protected function onStageVideo(event:StageVideoAvailabilityEvent):void
		{
			_stageVideoAvailabilitySet = true;
			_stageVideoAvailable = (event.availability == StageVideoAvailability.AVAILABLE);
			if(_setStageVideoWhenAvailable) {
				setStageVideo(_stageVideoAvailable);
			}
		}
		
		public function setStageVideo(on : Boolean):void
		{
			if(!_stageVideoAvailabilitySet && on) {
				_setStageVideoWhenAvailable = true;
				return;
			}
			if(_stageVideoAvailable && on) {
				if(!_stageVideo) {
					_stageVideo = _stage.stageVideos[0];
					_stageVideo.addEventListener(StageVideoEvent.RENDER_STATE, onStageVideoState);
				}
				_stageVideo.attachNetStream(_ns);
				_stageVideoOn = true;
//				onResize();
			} else {
				_video.attachNetStream(_ns);
				_stageVideoOn = false;
			}
		}
		
		protected function onStageVideoState(event:StageVideoEvent):void
		{
			onResize();
		}
		
		private function onResize():void
		{
			if(_stageVideoOn) {
				_stageVideo.viewPort = new Rectangle(0, 0, _video.width, _video.height);
			}
		}
		
		private function onLoadTimer(event:TimerEvent):void
		{
			if(_ns.bytesLoaded == _ns.bytesTotal) {
				_loadTimer.stop();
				dispatchEvent(new VideoControllerEvent(VideoControllerEvent.LOADED));
			}
			var progressEvent : VideoControllerEvent = new VideoControllerEvent(VideoControllerEvent.PROGRESS);
			progressEvent.ratio = _ns.bytesLoaded / _ns.bytesTotal;
			dispatchEvent(progressEvent);
		}
		
		private function onMetaData(metadata : Object) : void {
			_metaData = MetaData.parse(metadata);
//			trace("onMetaData", _metaData.duration, _metaData.width, _metaData.height, _metaData.framerate);
			
			// Stops the video once loaded
			if (_status == VideoControllerStatus.STOPPED) {
				_ns.pause();
			}
		}

		private function onNetStatus(event : NetStatusEvent) : void {
			trace(event.info["code"]);
			if(event.info["code"] == "NetStream.Play.Stop") {
				if(_loop) {
					_ns.seek(0);
				} else {
					_status = VideoControllerStatus.STOPPED;
					_ns.pause();
					dispatchEvent(new VideoControllerEvent(VideoControllerEvent.STOP));
				}
			}
		}

		public function get video() : Video {
			return _video;
		}
		
		public function load(url : String) : void {
			_status = VideoControllerStatus.STOPPED;
			_ns.play(url);
			_loadTimer.start();
		}
		
		public function set datas(d : Object) : void {
			_video.x = 0;
			_video.y = 0;
			_video.width = d["video_width"];
			_video.height = d["video_height"];
		}

		public function get datas() : Object {
			var d : Object = {};
			d["video_width"] = _video.width;
			d["video_height"] = _video.height;
			return d;
		}
		
		public function setSize(width : Number, height : Number) : void {
			var wantedVideoRatio : Number = width / height;
			var videoRatio : Number = _video.width / _video.height;
			if(videoRatio < wantedVideoRatio) {
				_video.width = height * videoRatio;
				_video.height = height;
			} else {
				_video.width = width;
				_video.height = width / videoRatio;
			}
			onResize();
		}

		public function get container() : Sprite {
			return _container;
		}

		public function play() : void {
			_ns.resume();
			_status = VideoControllerStatus.PLAYING;
			dispatchEvent(new VideoControllerEvent(VideoControllerEvent.PLAY));
		}

		public function pause() : void {
			_ns.pause();
			dispatchEvent(new VideoControllerEvent(VideoControllerEvent.PAUSE));
		}
		
		public function get ratio() : Number {
			if(!_metaData) {
				return 0;
			}
			return _ns.time / _metaData.duration;
		}
		
		public function get currentTime() : Number {
			return _ns.time;
		}
		
		public function set ratio(r : Number) : void {
			_ns.seek(r * _metaData.duration);
		}
		
		public function get duration() : Number {
			return _metaData.duration;
		}
		
		public function set volume(v : Number) : void {
			var st : SoundTransform = _ns.soundTransform;
			st.volume = v;
			_ns.soundTransform = st;
		}

		public function destroy() : void {
			_ns.close();
			_nc.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_ns.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_stage = null;
		}

		public function get loop():Boolean
		{
			return _loop;
		}

		public function set loop(value:Boolean):void
		{
			_loop = value;
		}

	}
}
