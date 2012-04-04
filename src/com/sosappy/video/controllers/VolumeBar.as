package com.sosappy.video.controllers {
	import com.sosappy.display.Button;

	import flash.display.Shape;
	import flash.events.MouseEvent;
	/**
	 * @author gpolguere
	 */
	public class VolumeBar extends Button {
		
		private var _ratio : Number;
		private var _background : Shape;
		private var _bars : Vector.<Shape>;
		private var _nbBars : int;
		
		public function VolumeBar(nbBars : int = 6) {
			super();
			
			_nbBars = nbBars;
			
			init();
			
			setSize((2 + 2) * _nbBars, 8);
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
			_background.graphics.beginFill(0x00ffff, 0);
			_background.graphics.drawRect(0, 0, 1, 1);
			_background.graphics.endFill();
			_container.addChild(_background);
			
			_bars = new Vector.<Shape>(_nbBars, true);
			
			var i : int = 0;
			var bar : Shape;
			for(; i < _nbBars; i++) {
				bar = new Shape();
				bar.graphics.beginFill(0x181818);
				bar.graphics.drawRect(0, -8, 2, 8);
				bar.graphics.endFill();
				_bars[i] = bar;
				_container.addChild(bar);
				bar.x = i * (2 + 2);
				bar.y = 8;
			}
			
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
			var nbBarsToShow : int = ratio * 6;
			var i : int = 0;
			for(; i < _nbBars; i++) {
				if(i + 1 <= nbBarsToShow) {
					_bars[i].scaleY = 1;
				} else {
					_bars[i].height = 1;
				}
			}
		}
		
		public function setSize(w : Number, h : Number) : void {
			_background.width = w;
			_background.height = h;
			
			updateLayout();
		}

		private function updateLayout() : void {
		}
		
	}
}
