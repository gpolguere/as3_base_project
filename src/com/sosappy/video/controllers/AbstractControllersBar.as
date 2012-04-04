package com.sosappy.video.controllers
{
	import com.sosappy.display.IButton;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class AbstractControllersBar extends Sprite
	{
		private var _controllers : Vector.<IButton>;
		private var _container : Sprite;
		
		public function AbstractControllersBar() {
			init();
		}
		
		private function init() : void {
			_controllers = new Vector.<IButton>();
			
			_container = new Sprite();
			addChild(_container);
		}
		
		public function registerButton(button : IButton) : void {
			_container.addChild(button);
			_controllers.push(button);
			
			updateLayout();
		}
		
		public function setSize(w : Number, h : Number) : void {
			updateLayout();
		}
		
		protected function updateLayout() : void {
		}
		
		public function destroy() : void {
			for each(var controller : IButton in _controllers) {
				controller.destroy();
			}
			_controllers = null;
		}
		
	}
}