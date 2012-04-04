package com.sosappy.video {
	import com.sosappy.video.controllers.ControllersBar;
	import com.sosappy.video.controllers.ControllersBarEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.EventDispatcher;
	import flash.events.FullScreenEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import nl.base42.subtitles.SubtitleParser;

	/**
	 * @author gpolguere
	 */
	public class VideoPlayer extends EventDispatcher {
		
		private var _videoController : VideoController;
		private var _controllersBar : ControllersBar;
		private var _stage : Stage;
		private var _isFullscreen : Boolean;
		private var _datasBeforeFullscreen : Object;
		private var _background : Sprite;
		private var _container : Sprite;
		private var _barTimer : Timer;
		private var _subtitles:Array;
		private var _lastSubtitle : String = "";

		public function VideoPlayer(
			videoController : VideoController = null,
			controllersBar : ControllersBar = null,
			background : Boolean = true
		) : void {
			_videoController = videoController || new VideoController();
			_controllersBar = controllersBar || new ControllersBar();
			
			_background = new Sprite();
			_background.graphics.beginFill(0x0);
			_background.graphics.drawRect(0, 0, _videoController.video.width, _videoController.video.height);
			_background.graphics.endFill();
			_background.visible = background;
			
			_controllersBar.setVideoSize(_videoController.video.width, _videoController.video.height);
			
			_container = new Sprite();
			_container.addChild(_background);
			_container.addChild(_videoController.container);
			_container.addChild(_controllersBar);
			
			_barTimer = new Timer(10);
			
			_controllersBar.background.visible = false;
			
			_controllersBar.addEventListener(ControllersBarEvent.PLAY, onControllersBarPlay);
			_controllersBar.addEventListener(ControllersBarEvent.PAUSE, onControllersBarPause);
			_controllersBar.addEventListener(ControllersBarEvent.SEEK, onControllersBarSeek);
			_controllersBar.addEventListener(ControllersBarEvent.FULLSCREEN, onControllersBarFullscreen);
			_controllersBar.addEventListener(ControllersBarEvent.NORMAL, onControllersBarNormal);
			_controllersBar.addEventListener(ControllersBarEvent.VOLUME, onControllersBarVolume);
			
			_videoController.addEventListener(VideoControllerEvent.PLAY, onVideoControllerPlay);
			_videoController.addEventListener(VideoControllerEvent.PAUSE, onVideoControllerPause);
			_videoController.addEventListener(VideoControllerEvent.STOP, onVideoControllerStop);
			
			updateLayout();
		}

		private function onControllersBarVolume(event : ControllersBarEvent) : void {
			_videoController.volume = event.ratio;
		}

		private function onControllersBarNormal(event : ControllersBarEvent) : void {
			this.fullscreen = false;
		}

		private function onControllersBarFullscreen(event : ControllersBarEvent) : void {
			this.fullscreen = true;
		}

		private function onControllersBarSeek(event : ControllersBarEvent) : void {
			_videoController.ratio = event.ratio;
		}

		private function onVideoControllerStop(event : VideoControllerEvent) : void {
			_barTimer.removeEventListener(TimerEvent.TIMER, onBarTimer);
			_barTimer.stop();
			
			_videoController.ratio = 0;
			
			updateRatio();
			updateTime();
			
			_controllersBar.showPlay();
		}

		private function onVideoControllerPause(event : VideoControllerEvent) : void {
			_barTimer.removeEventListener(TimerEvent.TIMER, onBarTimer);
			_barTimer.stop();
		}

		private function onVideoControllerPlay(event : VideoControllerEvent) : void {
			_barTimer.addEventListener(TimerEvent.TIMER, onBarTimer);
			_barTimer.start();
		}

		private function onBarTimer(event : TimerEvent) : void {
			updateRatio();
			updateTime();
			updateSubtitles();
		}
		
		private function updateSubtitles():void
		{
			if(_lastSubtitle != SubtitleParser.getCurrentSubtitle(_videoController.currentTime, _subtitles)) {
				_lastSubtitle = SubtitleParser.getCurrentSubtitle(_videoController.currentTime, _subtitles);
				trace(_lastSubtitle);
			}
		}
		
		private function updateTime() : void {
			_controllersBar.currentTime = _videoController.currentTime;
		}

		private function updateRatio() : void {
			_controllersBar.ratio = _videoController.ratio;
		}

		private function onControllersBarPause(event : ControllersBarEvent) : void {
			_controllersBar.showPlay();
			_videoController.pause();
		}

		private function onControllersBarPlay(event : ControllersBarEvent) : void {
			_controllersBar.showPause();
			_videoController.play();
		}

		private function updateLayout() : void {
			_controllersBar.barOffsetY = _background.height;
		}
		
		public function get videoController() : VideoController {
			return _videoController;
		}

		public function get controllersBar() : ControllersBar {
			return _controllersBar;
		}
		
		public function set fullscreen(on : Boolean) : void {
			_stage = _videoController.video.stage;
			if(_stage) {
				_stage.removeEventListener(FullScreenEvent.FULL_SCREEN, onFullscreen);
				_stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullscreen);
				_stage.displayState = on ? StageDisplayState.FULL_SCREEN : StageDisplayState.NORMAL;
			}
		}
		
		private function onFullscreen(event : FullScreenEvent) : void {
			_isFullscreen = event.fullScreen;
			if(_isFullscreen) {
				_datasBeforeFullscreen = _videoController.datas;
				_datasBeforeFullscreen["parent"] = _container.parent;
				_datasBeforeFullscreen["x"] = _container.x;
				_datasBeforeFullscreen["y"] = _container.y;
//				_controllersBar.setSize(_stage.fullScreenWidth, 15);
				_videoController.setSize(_stage.fullScreenWidth, _stage.fullScreenHeight);
				_background.width = _stage.fullScreenWidth;
				_background.height = _stage.fullScreenHeight;
				_videoController.video.x = (_stage.fullScreenWidth - _videoController.video.width) >> 1;
				_videoController.video.y = (_stage.fullScreenHeight - _videoController.video.height) >> 1;
				_container.x = 0;
				_container.y = 0;
				_stage.addChild(_container);
//				_controllersBar.y = _background.height - 20;
				_controllersBar.visible = false;
			} else {
				_videoController.datas = _datasBeforeFullscreen;
				(_datasBeforeFullscreen["parent"] as DisplayObjectContainer).addChild(_container);
				_container.x = _datasBeforeFullscreen["x"];
				_container.y = _datasBeforeFullscreen["y"];
//				_controllersBar.setSize(640, 15);
				_controllersBar.visible = true;
				
				_background.scaleX = 1;
				_background.scaleY = 1;
			}
		}

		public function get container() : Sprite {
			return _container;
		}

		public function destroy() : void {
			if(_videoController) {
				_videoController.destroy();
			
				_videoController.removeEventListener(VideoControllerEvent.PLAY, onVideoControllerPlay);
				_videoController.removeEventListener(VideoControllerEvent.PAUSE, onVideoControllerPause);
				_videoController.removeEventListener(VideoControllerEvent.STOP, onVideoControllerStop);
			}
			
			if(_controllersBar) {
				_controllersBar.destroy();
				
				_controllersBar.removeEventListener(ControllersBarEvent.PLAY, onControllersBarPlay);
				_controllersBar.removeEventListener(ControllersBarEvent.PAUSE, onControllersBarPause);
				_controllersBar.removeEventListener(ControllersBarEvent.SEEK, onControllersBarSeek);
				_controllersBar.removeEventListener(ControllersBarEvent.FULLSCREEN, onControllersBarFullscreen);
				_controllersBar.removeEventListener(ControllersBarEvent.NORMAL, onControllersBarNormal);
				_controllersBar.removeEventListener(ControllersBarEvent.VOLUME, onControllersBarVolume);
			}
			
			_barTimer.removeEventListener(TimerEvent.TIMER, onBarTimer);
			
			if(_stage) {
				_stage.removeEventListener(FullScreenEvent.FULL_SCREEN, onFullscreen);
			}
			trace(_stage);
			
			_videoController = null;
			_controllersBar = null;
		}

		public function pause() : void {
			if(_videoController) {
				_videoController.pause();
			}
			if(_controllersBar) {
				_controllersBar.showPlay();
			}
		}
		
		public function set srt(subtitles : Array) : void {
			_subtitles = subtitles;
		}
	}
}
