package com.sosappy.text
{
	import flash.text.StyleSheet;
	import flash.text.TextField;
	
	import utils.object.isEmpty;
	
	/**
	 * 
	 * @author gilp
	 * @example
			StyledTextField.globalStyleSheet = Styles.getInstance().styleSheet;
			var tf : StyledTextField = new StyledTextField("test");
			tf.text = "hello";
			addChild(tf);
	 */	
	public class StyledTextField
	{
		static public var globalStyleSheet : StyleSheet;
		static private var _suffix : String = "";
		
		private var _className:String;
		private var _text:String;
		private var _asset:TextField;
		
		public function StyledTextField(className : String, asset : TextField = null)
		{
			_asset = asset || new TextField();
			super();
			if(globalStyleSheet) {
				_asset.styleSheet = globalStyleSheet;
				var cssClassObj : Object = globalStyleSheet.getStyle("." + className + suffix);
				if(isEmpty(cssClassObj)) {
					cssClassObj = globalStyleSheet.getStyle("." + className);
				} else {
					className += suffix;
				}
				for(var key : String in cssClassObj) {
					if(_asset.hasOwnProperty(key)) {
						_asset[key] = (cssClassObj[key] == "false") ? false : cssClassObj[key];
					}
				}
			}
			_className = className;
		}
		
		public function set className(name : String) : void {
			_className = name;
			applyStyle();
		}
		
		public function set text(t : String) : void {
			this.htmlText = t;
			applyStyle();
		}
		
		public function set htmlText(t : String) : void {
			_text = t;
			applyStyle();
		}
		
		private function applyStyle():void
		{
			_asset.htmlText = "<span class=\"" + _className + "\">" + _text + "</span>";
		}

		public static function get suffix():String
		{
			return _suffix;
		}

		public static function set suffix(value:String):void
		{
			_suffix = value;
			if(_suffix.charAt() != "_") {
				_suffix = "_" + _suffix;
			}
		}

		public function get asset():TextField
		{
			return _asset;
		}


	}
}