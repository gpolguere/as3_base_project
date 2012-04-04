package com.sosappy.video {
	/**
	 * @author gpolguere
	 */
	public class MetaData {
		
		private var _duration : Number;
		private var _framerate : Number;
		private var _width : Number;
		private var _height : Number;
		
		static public function parse(metaDataObject : Object) : MetaData {
			var metaData : MetaData = new MetaData();
			metaData.duration = metaDataObject["duration"];
			metaData.framerate = metaDataObject["framerate"];
			metaData.width = metaDataObject["width"];
			metaData.height = metaDataObject["height"];
			return metaData;
		}

		public function get duration() : Number {
			return _duration;
		}

		public function set duration(duration : Number) : void {
			_duration = duration;
		}

		public function get framerate() : Number {
			return _framerate;
		}

		public function set framerate(framerate : Number) : void {
			_framerate = framerate;
		}

		public function get width() : Number {
			return _width;
		}

		public function set width(width : Number) : void {
			_width = width;
		}

		public function get height() : Number {
			return _height;
		}

		public function set height(height : Number) : void {
			_height = height;
		}
	}
}
