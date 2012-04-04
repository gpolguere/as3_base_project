package com.sosappy.display {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import utils.frame.getFrameNumberForLabel;

	/**
	 * @author gpolguere
	 */
	public class Button implements IButton {
		
		protected var _container : MovieClip;
		
		public function Button(asset : MovieClip = null) : void {
			_container = asset || new MovieClip();
			
			init();
		}
		
		private function init() : void {
			_container.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			_container.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			_container.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_container.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			if(getFrameNumberForLabel(_container, "over") > -1) {
				_container.gotoAndPlay("over");
			}
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			if(getFrameNumberForLabel(_container, "out") > -1) {
				_container.gotoAndPlay("out");
			}
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			if(getFrameNumberForLabel(_container, "down") > -1) {
				_container.gotoAndPlay("down");
			}
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			if(getFrameNumberForLabel(_container, "up") > -1) {
				_container.gotoAndPlay("up");
			}
		}
		
		public function get container() : Sprite {
			return _container;
		}
		
		public function enable() : void {
			_container.mouseEnabled = true;
		}
		
		public function disable() : void {
			_container.mouseEnabled = false;
		}
		
		public function destroy() : void {
			_container.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			_container.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			_container.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_container.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp)
		}
		
	}
}
