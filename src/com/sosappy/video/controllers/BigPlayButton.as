package com.sosappy.video.controllers {
	import com.sosappy.display.Button;

	import flash.display.Shape;
	import flash.events.MouseEvent;

	/**
	 * @author gpolguere
	 */
	public class BigPlayButton extends Button implements IBigPlayButton {
		
		private var _playButton : E_VideoPlayBig;
		private var _isPlaying : Boolean;
//		private var _hitZone : Shape;
		
		public function BigPlayButton() {
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
			_playButton = new E_VideoPlayBig();
			_container.addChild(_playButton);
			
//			_hitZone = new Shape();
//			_hitZone.graphics.beginFill(0x00ffff, 0);
//			_hitZone.graphics.drawRect(0, 0, 1, 1);
//			_hitZone.graphics.endFill();
//			_container.addChild(_hitZone);
//			_hitZone.width = _playButton.width;
//			_hitZone.height = _playButton.height;
		}
		
		public function showPlay() : void {
			_playButton.visible = true;
			_isPlaying = false;
		}
		
		public function showPause() : void {
			_playButton.visible = false;
			_isPlaying = true;
		}

		public function get isPlaying() : Boolean {
			return _isPlaying;
		}
	}
}
