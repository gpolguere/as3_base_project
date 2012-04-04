package com.sosappy.video.controllers {
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import com.sosappy.display.Button;
	/**
	 * @author gpolguere
	 */
	public class ProgressBar extends Button {
		
		private var _ratio : Number;
		private var _background : Shape;
		private var _bar : Shape;
		
		public function ProgressBar(width : Number = 522, height: Number = 3) {
			super();
			
			init();
			
			setSize(width, height);
		}

		private function init() : void {
			drawUI();
			
			addListeners();
		}

		private function addListeners() : void {
			_container.buttonMode = true;
			_container.mouseChildren = false;
			_container.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(event : MouseEvent) : void {
		}

		private function drawUI() : void {
			_background = new Shape();
			_background.graphics.beginFill(0x181818, .4);
			_background.graphics.drawRect(0, 0, 1, 1);
			_background.graphics.endFill();
			_container.addChild(_background);
			
			_bar = new Shape();
			_bar.graphics.beginFill(0x181818);
			_bar.graphics.drawRect(0, 0, 1, 1);
			_bar.graphics.endFill();
			_container.addChild(_bar);
			
			/*
			_hitZone = new Shape();
			_hitZone.graphics.beginFill(0x00ffff, 0);
			_hitZone.graphics.drawRect(0, 0, 1, 1);
			_hitZone.graphics.endFill();
			_container.addChild(_hitZone);
			_hitZone.width = Math.max(_playButton.x + _playButton.width, _pauseButton.x + _pauseButton.width);
			_hitZone.height = Math.max(_playButton.y + _playButton.height, _pauseButton.y + _pauseButton.height);
			*/
		}

		public function get ratio() : Number {
			return _ratio;
		}

		public function set ratio(ratio : Number) : void {
			_ratio = ratio;
			_bar.width = _background.width * _ratio;
		}
		
		public function setSize(w : Number, h : Number) : void {
			_background.width = w;
			_background.height = h;
			
			_bar.width = w * _ratio;
			_bar.height = h;
			
			updateLayout();
		}

		private function updateLayout() : void {
		}
		
	}
}
