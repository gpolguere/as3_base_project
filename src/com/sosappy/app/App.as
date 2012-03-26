package com.sosappy.app
{
	import flash.display.Stage;
	import flash.events.Event;

	public class App
	{
		E_Fonts;
		
		static public var stage : Stage;
		static public var langXML : XML;
		private static var _resizeCallbacks : Vector.<Function> = new Vector.<Function>();
		
		static public function get stageWidth() : int {
			if(!stage)
			{
				throw new Error("App::stage is not defined");
			}
			return stage.stageWidth;
		}
		
		static public function get stageHeight() : int {
			if(!stage)
			{
				throw new Error("App::stage is not defined");
			}
			return stage.stageHeight;
		}
		
		public static function registerForResize(onResizeCallback : Function):void
		{
			_resizeCallbacks.push(onResizeCallback);
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		protected static function onResize(event:Event):void
		{
			for each(var callback : Function in _resizeCallbacks) {
				callback();
			}
		}
	}
}