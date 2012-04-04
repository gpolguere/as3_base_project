package com.sosappy.video.controllers {
	import com.sosappy.display.Button;

	import flash.display.Shape;
	import flash.events.MouseEvent;

	/**
	 * @author gpolguere
	 */
	public class PlayPauseButton extends Button implements IBigPlayButton {
		
		private var _playButton : E_VideoPlay;
		private var _pauseButton : E_VideoPause;
		private var _isPlaying : Boolean;
		private var _hitZone : Shape;
		
		public function PlayPauseButton() {
			super();
			
			init();
		}

		private function init() : void {
			drawUI();
			
			addListeners();
			
			_isPlaying = false;
		}

		private function addListeners() : void {
			_container.buttonMode = true;
			_container.mouseChildren = false;
			_container.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(event : MouseEvent) : void {
			if(_isPlaying) {
				showPlay();
			} else {
				showPause();
			}
		}

		private function drawUI() : void {
			_playButton = new E_VideoPlay();
			_container.addChild(_playButton);
			
			_pauseButton = new E_VideoPause();
			_container.addChild(_pauseButton);
			_pauseButton.visible = false;
			
			_hitZone = new Shape();
			_hitZone.graphics.beginFill(0x00ffff, 0);
			_hitZone.graphics.drawRect(0, 0, 1, 1);
			_hitZone.graphics.endFill();
			_container.addChild(_hitZone);
			_hitZone.width = Math.max(_playButton.x + _playButton.width, _pauseButton.x + _pauseButton.width);
			_hitZone.height = Math.max(_playButton.y + _playButton.height, _pauseButton.y + _pauseButton.height);
		}
		
		public function showPlay() : void {
			_playButton.visible = true;
			_pauseButton.visible = false;
			_isPlaying = false;
		}
		
		public function showPause() : void {
			_playButton.visible = false;
			_pauseButton.visible = true;
			_isPlaying = true;
		}

		public function get isPlaying() : Boolean {
			return _isPlaying;
		}
	}
}
