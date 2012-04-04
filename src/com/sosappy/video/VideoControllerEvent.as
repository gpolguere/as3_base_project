package com.sosappy.video {
	import flash.events.Event;

	/**
	 * @author gpolguere
	 */
	public class VideoControllerEvent extends Event {
		
		public static const PLAY : String = "PLAY";
		public static const PAUSE : String = "PAUSE";
		public static const STOP : String = "STOP";
		public static const LOADED : String = "LOADED";
		public static const PROGRESS : String = "PROGRESS";
		
		private var _ratio : Number = 0;
		
		public function VideoControllerEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}

		public function get ratio():Number
		{
			return _ratio;
		}

		public function set ratio(value:Number):void
		{
			_ratio = value;
		}

	}
}
