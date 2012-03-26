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
	public class StyledTextField extends TextField
	{
		static public var globalStyleSheet : StyleSheet;
		static private var _suffix : String = "";
		
		private var _className:String;
		private var _text:String;
		
		public function StyledTextField(className : String)
		{
			super();
			if(globalStyleSheet) {
				this.styleSheet = globalStyleSheet;
				var cssClassObj : Object = globalStyleSheet.getStyle("." + className + suffix);
				if(isEmpty(cssClassObj)) {
					cssClassObj = globalStyleSheet.getStyle("." + className);
				} else {
					className += suffix;
				}
				for(var key : String in cssClassObj) {
					if(this.hasOwnProperty(key)) {
						this[key] = (cssClassObj[key] == "false") ? false : cssClassObj[key];
					}
				}
			}
			_className = className;
		}
		
		public function set className(name : String) : void {
			_className = name;
			applyStyle();
		}
		
		override public function set text(t : String) : void {
			this.htmlText = t;
			applyStyle();
		}
		
		override public function set htmlText(t : String) : void {
			_text = t;
			applyStyle();
		}
		
		private function applyStyle():void
		{
			super.htmlText = "<span class=\"" + _className + "\">" + _text + "</span>";
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


	}
}