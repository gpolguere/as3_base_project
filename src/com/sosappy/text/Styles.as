package com.sosappy.text {
	import flash.text.StyleSheet;
	import flash.text.TextField;

	/**
	 * @author polgueregil
	 */
	public class Styles {
		
		static private var _instance : Styles;
		private var _styleSheet : StyleSheet;
		private var _cssText : String;
		
		public function Styles() : void {
			init();
		}
		
		static public function getInstance() : Styles {
			if(!_instance) {
				_instance = new Styles();
			}
			return _instance;
		}
		
		private function init() : void {
			_styleSheet = new StyleSheet();
		}
		
		/**
		 * 
		 * @description has to be called first to setup the base stylesheet
		 * @param css
		 * 
		 */
		public function parse(css : String) : void {
			_cssText = css;
			
			_styleSheet.parseCSS(_cssText);
			mergeStylesFromDefault(_styleSheet.getStyle(".defaultStyle"));
			mergeLocalizedStyles();
		}
		
		private function findLocalizedStyles() : Array {
			var stylesName : Array = _styleSheet.styleNames.slice();
			var localizedStylesName : Array = [];
			var nbStyles : int = stylesName.length;
			var associatedLocalizedStyle : Object;
			for(var i : int = 0; i < nbStyles; i++) {
				associatedLocalizedStyle = findAssociatedLocalizedStyle(stylesName[i]);
				if(associatedLocalizedStyle && associatedLocalizedStyle["langs"].length > 0) {
					localizedStylesName.push(associatedLocalizedStyle);
				}
			}
			return localizedStylesName;
		}
		
		private function findAssociatedLocalizedStyle(className : String) : Object
		{
			var stylesName : Array = _styleSheet.styleNames.slice();
			var pattern : RegExp = new RegExp(className + "_([a-zA-Z]{2})$");
			var pattern2 : RegExp = new RegExp(className + "_([a-zA-Z]{2}_[a-zA-Z]{2})$");
			var nbStyles : int = stylesName.length;
			var associatedLocalizedStyle : String;
			var associatedLocalizedStyles : Array = [];
			var result : Array;
			var association : Object = {"default": className};
			var langs : Array = [];
			for(var i : int = 0; i < nbStyles; i++) {
				result = null;
				if(stylesName[i] == className) {
					continue;
				}
				if(pattern.test(stylesName[i])) {
					result = pattern.exec(stylesName[i]);
				} else if(pattern2.test(stylesName[i])) {
					result = pattern2.exec(stylesName[i]);
				}
				if(result) {
					langs.push({"classname": result[0], "locale": result[1]});
				}
			}
			association["langs"] = langs;
			return association;
		}
		
		private function mergeLocalizedStyles() : void {
			var localizedStyles : Array = findLocalizedStyles();
			var i : int, j : int;
			var n : int = localizedStyles.length;
			var key : String;
			var langs : Array;
			var nbLangs : int;
			var obj : Object;
			var defaultStyle : Object;
			var className : String;
			for (i = 0; i < n; i++)
			{
				langs = localizedStyles[i]["langs"];
				nbLangs = langs.length;
				defaultStyle = _styleSheet.getStyle(localizedStyles[i]["default"]);
				for(j = 0; j < nbLangs; j++) {
					className = langs[j]["classname"];
					obj = _styleSheet.getStyle(className);
					for(key in defaultStyle) {
						if(obj[key] == undefined) {
							obj[key] = defaultStyle[key];
						}
					}
					_styleSheet.setStyle(className, obj);
				}
			}
		}
		
		private function mergeStylesFromDefault(defaultStyle : Object) : void {
			var i : int;
			var n : int = _styleSheet.styleNames.length;
			var key : String;
			var obj : Object;
			for (i = 0; i < n; i++)
			{
				obj = _styleSheet.getStyle(_styleSheet.styleNames[i]);
				for(key in defaultStyle)
				{
					if(obj[key] == undefined)
						obj[key] = defaultStyle[key];
					
				}
				_styleSheet.setStyle(_styleSheet.styleNames[i], obj);
			}
		}

		/**
		 * 
		 * @description default styles that can be set for a locale (for an example)
		 * @param defaultStyle
		 * 
		 */
		public function set defaultStyle(defaultStyle : String) : void {
			_styleSheet = new StyleSheet();
			_styleSheet.parseCSS(_cssText);
			
			var defaultStyleSheet : StyleSheet = new StyleSheet();
			defaultStyleSheet.parseCSS(defaultStyle);
			mergeStyles(".defaultStyle", defaultStyleSheet, _styleSheet);
			mergeLocalizedStyles();
			mergeStylesFromDefault(_styleSheet.getStyle(".defaultStyle"));
		}

		private function mergeStyles(styleClass : String, style : StyleSheet, styleToBeOverridden : StyleSheet) : void {
			var styleClassObject : Object = style.getStyle(styleClass);
			var styleToBeOverriddenClassObject : Object = styleToBeOverridden.getStyle(styleClass);
			for(var key : String in styleClassObject) {
				styleToBeOverriddenClassObject[key] = styleClassObject[key];
				_styleSheet.setStyle(".defaultStyle", styleToBeOverriddenClassObject);
			}
		}

		public function get styleSheet() : StyleSheet
		{
			return _styleSheet;
		}

	}
}

