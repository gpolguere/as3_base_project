package com.sosappy.video.controllers {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author gpolguere
	 */
	public class ControllersBar extends Sprite {
		
		private var _controllers : Vector.<Sprite>;
		private var _background : Shape;
		private var _container : Sprite;
		private var _playPauseButton : IPlayPauseButton;
		private var _progressBar : ProgressBar;
		private var _time : TextField;
		private var _fullscreenButton : IFullscreenButton;
		private var _volumeBar : VolumeBar;
		private var _bigPlayButton : IBigPlayButton;
		private var _videoWidth : Number;
		private var _videoHeight : Number;
		private var _barOffsetY : Number;
		
		public function ControllersBar() {
			init();
		}
		
		private function init() : void {
			_controllers = new Vector.<Sprite>();
			
			_container = new Sprite();
			addChild(_container);
			
			_background = new Shape();
			_background.graphics.beginFill(0x0);
			_background.graphics.drawRect(0, 0, 1, 1);
			_background.graphics.endFill();
//			_container.addChild(_background);
		}
		
		public function set playPauseButton(button : IPlayPauseButton) : void {
			if(button) {
				_container.addChild(button.container);
			} else {
				if(_playPauseButton && _container.contains(_playPauseButton.container)) {
					_playPauseButton.container.removeEventListener(MouseEvent.CLICK, onPlayPauseButtonClick);
					_container.removeChild(_playPauseButton.container);
				}
			}
			_playPauseButton = button;
			_playPauseButton.container.addEventListener(MouseEvent.CLICK, onPlayPauseButtonClick);
			
			updateLayout();
		}

		private function onPlayPauseButtonClick(event : MouseEvent) : void {
			var type : String = _playPauseButton.isPlaying ? ControllersBarEvent.PLAY : ControllersBarEvent.PAUSE;
			dispatchEvent(new ControllersBarEvent(type));
		}
		
		public function set bigPlayButton(button : IBigPlayButton) : void {
			if(button) {
				_container.addChild(button.container);
			} else {
				if(_bigPlayButton && _container.contains(_bigPlayButton.container)) {
					_bigPlayButton.container.removeEventListener(MouseEvent.CLICK, onBigPlayButtonClick);
					_container.removeChild(_bigPlayButton.container);
				}
			}
			_bigPlayButton = button;
			_bigPlayButton.container.addEventListener(MouseEvent.CLICK, onBigPlayButtonClick);
			
			updateLayout();
		}

		private function onBigPlayButtonClick(event : MouseEvent) : void {
			var type : String = _bigPlayButton.isPlaying ? ControllersBarEvent.PLAY : ControllersBarEvent.PAUSE;
			dispatchEvent(new ControllersBarEvent(type));
		}

		public function set progressBar(bar : ProgressBar) : void {
			if(bar) {
				_container.addChild(bar.container);
			} else {
				if(_progressBar && _container.contains(_progressBar.container)) {
					_progressBar.container.removeEventListener(MouseEvent.CLICK, onProgressBarClick);
					_container.removeChild(_progressBar.container);
				}
			}
			_progressBar = bar;
			_progressBar.container.addEventListener(MouseEvent.CLICK, onProgressBarClick);
			
			updateLayout();
		}

		private function onProgressBarClick(event : MouseEvent) : void {
			var controllersBarEvent : ControllersBarEvent = new ControllersBarEvent(ControllersBarEvent.SEEK);
			controllersBarEvent.ratio = _progressBar.container.mouseX / _progressBar.container.width;
			dispatchEvent(controllersBarEvent);
		}
		
		public function set time(time : TextField) : void {
			if(time) {
				_container.addChild(time);
			} else {
				if(_time && _container.contains(_time)) {
					_container.removeChild(_time);
				}
			}
			_time = time;
			
			updateLayout();
		}
		
		public function set fullscreenButton(fullscreenButton : IFullscreenButton) : void {
			if(fullscreenButton) {
				_container.addChild(fullscreenButton.container);
			} else {
				if(_fullscreenButton && _container.contains(_fullscreenButton.container)) {
					_fullscreenButton.container.removeEventListener(MouseEvent.CLICK, onFullscreenButtonClick);
					_container.removeChild(_fullscreenButton.container);
				}
			}
			_fullscreenButton = fullscreenButton;
			_fullscreenButton.container.addEventListener(MouseEvent.CLICK, onFullscreenButtonClick);
			
			updateLayout();
		}

		private function onFullscreenButtonClick(event : MouseEvent) : void {
			var type : String = _fullscreenButton.isFullscreen ? ControllersBarEvent.FULLSCREEN : ControllersBarEvent.NORMAL;
			dispatchEvent(new ControllersBarEvent(type));
		}
		
		public function set volumeBar(bar : VolumeBar) : void {
			if(bar) {
				_container.addChild(bar.container);
			} else {
				if(_volumeBar && _container.contains(_volumeBar.container)) {
					_volumeBar.container.removeEventListener(MouseEvent.MOUSE_DOWN, onVolumeBarDown);
					_container.removeChild(_volumeBar.container);
				}
			}
			_volumeBar = bar;
			_volumeBar.container.addEventListener(MouseEvent.MOUSE_DOWN, onVolumeBarDown);
			
			updateLayout();
		}
		
		private function onVolumeBarDown(event : MouseEvent) : void {
			_volumeBar.container.addEventListener(Event.ENTER_FRAME, onVolumeBarEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_UP, onVolumeBarUp);
		}

		private function onVolumeBarEnterFrame(event : Event) : void {
			var posX : Number = _volumeBar.container.mouseX;
			var barSize : Number = _volumeBar.container.width;
			if(posX < 0) {
				posX = 0;
			} else if(posX > barSize) {
				posX = barSize;
			}
			var controllersBarEvent : ControllersBarEvent = new ControllersBarEvent(ControllersBarEvent.VOLUME);
			controllersBarEvent.ratio = _volumeBar.ratio = posX / barSize;
			dispatchEvent(controllersBarEvent);
		}

		private function onVolumeBarUp(event : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onVolumeBarUp);
			_volumeBar.container.removeEventListener(Event.ENTER_FRAME, onVolumeBarEnterFrame);
		}
		
		public function setSize(w : Number, h : Number) : void {
			_background.width = w;
			_background.height = h;
			
			updateLayout();
		}

		private function updateLayout() : void {
			var marginX : Number = 5;
			var marginY : Number = 5;
			var lastX : Number = marginX;
			var lastY : Number = _barOffsetY + marginY;
			
			if(_bigPlayButton) {
				_bigPlayButton.container.x = (_videoWidth - _bigPlayButton.container.width) >> 1;
				_bigPlayButton.container.y = (_videoHeight - _bigPlayButton.container.height) >> 1;
			}
			
			if(_playPauseButton) {
				_playPauseButton.container.x = lastX;
				_playPauseButton.container.y = lastY;
				lastX += _playPauseButton.container.width + marginX + 5;
			}
			
			if(_progressBar) {
				_progressBar.container.x = lastX;
				_progressBar.container.y = lastY + 3;
				lastX += _progressBar.container.width + marginX;
			}
			
			if(_time) {
				_time.x = lastX + 2;
				_time.y = lastY - 4;
				lastX += _time.width + marginX + 4;
			}
			
			if(_fullscreenButton) {
				_fullscreenButton.container.x = lastX;
				_fullscreenButton.container.y = lastY;
				lastX += _fullscreenButton.container.width + marginX + 1;
			}
			
			if(_volumeBar) {
				_volumeBar.container.x = _background.width - _volumeBar.container.width;
				_volumeBar.container.y = lastY;
				lastX += _volumeBar.container.width + marginX;
			}
		}

		public function get background() : Shape {
			return _background;
		}
		
		public function set ratio(r : Number) : void {
			if(_progressBar) {
				_progressBar.ratio = r;
			}
		}
		
		public function set currentTime(t : Number) : void {
			if(_time) {
				var minutes : int = t / 60;
				var m : String = minutes.toString();
				if(minutes < 10) {
					m = "0" + m;
				}
				var seconds : int = t % 60;
				var s : String = seconds.toString();
				if(seconds < 10) {
					s = "0" + s;
				}
//				_time.setContent(m + ":" + s);
				_time.text = m + ":" + s;
			}
		}

		public function destroy() : void {
			if(_bigPlayButton) {
				_bigPlayButton.container.removeEventListener(MouseEvent.CLICK, onBigPlayButtonClick);
			}
			if(_playPauseButton) {
				_playPauseButton.container.removeEventListener(MouseEvent.CLICK, onPlayPauseButtonClick);
			}
			if(_progressBar) {
				_progressBar.container.removeEventListener(MouseEvent.CLICK, onProgressBarClick);
			}
			if(_fullscreenButton) {
				_fullscreenButton.container.removeEventListener(MouseEvent.CLICK, onFullscreenButtonClick);
			}
			if(_volumeBar) {
				_volumeBar.container.removeEventListener(MouseEvent.MOUSE_DOWN, onVolumeBarDown);
				_volumeBar.container.removeEventListener(Event.ENTER_FRAME, onVolumeBarEnterFrame);
				if(stage) {
					stage.removeEventListener(MouseEvent.MOUSE_UP, onVolumeBarUp);
				}
			}
		}

		public function showPlay() : void {
			if(_playPauseButton) {
				_playPauseButton.showPlay();
			}
			if(_bigPlayButton) {
				_bigPlayButton.showPlay();
			}
		}

		public function setVideoSize(w : Number, h : Number) : void {
			_videoWidth = w;
			_videoHeight = h;
		}

		public function set barOffsetY(barOffsetY : Number) : void {
			_barOffsetY = barOffsetY;
		}

		public function showPause() : void {
			if(_playPauseButton) {
				_playPauseButton.showPause();
			}
			if(_bigPlayButton) {
				_bigPlayButton.showPause();
			}
		}
	}
}
