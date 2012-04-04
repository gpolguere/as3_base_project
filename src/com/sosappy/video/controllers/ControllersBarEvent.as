package com.sosappy.video.controllers {
	import flash.events.Event;

	/**
	 * @author gpolguere
	 */
	public class ControllersBarEvent extends Event {
		
		public static const PLAY : String = "PLAY";
		public static const PAUSE : String = "PAUSE";
		public static const SEEK : String = "SEEK";
		public static const FULLSCREEN : String = "FULLSCREEN";
		public static const NORMAL : String = "NORMAL";
		public static const VOLUME : String = "VOLUME";
		
		private var _ratio : Number;
		
		public function ControllersBarEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}

		public function get ratio() : Number {
			return _ratio;
		}

		public function set ratio(ratio : Number) : void {
			_ratio = ratio;
		}
	}
}
