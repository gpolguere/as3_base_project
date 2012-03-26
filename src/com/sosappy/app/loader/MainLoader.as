package com.sosappy.app.loader
{
	import com.sosappy.app.App;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class MainLoader extends Sprite
	{
		public function MainLoader()
		{
			super();
			init();
		}
		
		protected function init() : void
		{
			initStage();
		}
		
		private function initStage():void
		{
			App.stage = stage;
		}
		
		// TO OVERRIDE
		protected function start() : void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event : Event) : void
		{
		}
		
		protected function onInitEnd():void
		{
			start();
		}
		
		protected function onReady() : void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
	}
}