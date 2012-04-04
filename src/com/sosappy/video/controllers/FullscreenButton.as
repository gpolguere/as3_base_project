package com.sosappy.video.controllers {
	import flash.display.Sprite;
	import com.sosappy.display.Button;

	import flash.display.Shape;
	import flash.events.MouseEvent;

	/**
	 * @author gpolguere
	 */
	public class FullscreenButton extends Button implements IFullscreenButton {
		
		private var _fullscreenButton : E_VideoFullscreen;
		private var _normalButton : Sprite;
		private var _isFullscreen : Boolean;
		private var _hitZone : Shape;
		
		public function FullscreenButton() {
			super();
			
			init();
		}

		private function init() : void {
			drawUI();
			
			addListeners();
			
			_isFullscreen = false;
		}

		private function addListeners() : void {
			_container.buttonMode = true;
			_container.mouseChildren = false;
			_container.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(event : MouseEvent) : void {
			if(_isFullscreen) {
				showFullscreen();
			} else {
				showNormal();
			}
		}

		private function drawUI() : void {
			_fullscreenButton = new E_VideoFullscreen();
			_container.addChild(_fullscreenButton);
			
			_normalButton = new E_VideoFullscreen();
			_container.addChild(_normalButton);
			_normalButton.visible = false;
			
			_hitZone = new Shape();
			_hitZone.graphics.beginFill(0x00ffff, 0);
			_hitZone.graphics.drawRect(0, 0, 1, 1);
			_hitZone.graphics.endFill();
			_container.addChild(_hitZone);
			_hitZone.width = Math.max(_fullscreenButton.x + _fullscreenButton.width, _normalButton.x + _normalButton.width);
			_hitZone.height = Math.max(_fullscreenButton.y + _fullscreenButton.height, _normalButton.y + _normalButton.height);
		}
		
		public function showFullscreen() : void {
			_fullscreenButton.visible = true;
			_normalButton.visible = false;
			_isFullscreen = false;
		}
		
		public function showNormal() : void {
			_fullscreenButton.visible = false;
			_normalButton.visible = true;
			_isFullscreen = true;
		}

		public function get isFullscreen() : Boolean {
			return _isFullscreen;
		}
	}
}
