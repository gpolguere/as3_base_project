package com.sosappy.text
{
	import com.flassari.swfclassexplorer.SwfClassExplorer;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.Font;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedSuperclassName;

	public class FontsManager
	{
		static public var verbose : Boolean = false;
		
		private static var _bytes : ByteArray;
		private static var _callback : Function;
		
		static public function registerFromSWF(bytes : ByteArray, callback : Function = null) : void {
			_bytes = bytes;
			_callback  = callback;
			
			var fontLoader : Loader = new Loader();
			var loaderContext : LoaderContext = new LoaderContext();
			fontLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderInit);
			fontLoader.loadBytes(_bytes, loaderContext);
		}
		
		static private function onLoaderInit(event : Event) : void {
			var loaderInfo : LoaderInfo = event.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, onLoaderInit);
			var fontLoader : Loader = loaderInfo.loader;
			var classes : Array = SwfClassExplorer.getClassNames(_bytes);
			var applicationDomain : ApplicationDomain = fontLoader.contentLoaderInfo.applicationDomain;
			var className : String;
			var fontClass : Class;
			var font : Font;
			for each(className in classes) {
				if(applicationDomain.hasDefinition(className) && getQualifiedSuperclassName(applicationDomain.getDefinition(className)) == "flash.text::Font") {
					fontClass = applicationDomain.getDefinition(className) as Class;
					font = new fontClass() as Font;
					if(!fontAlreadyRegistered(font)) {
						Font.registerFont(fontClass);
					}
//					trace("\"" + font.fontName + "\"", font.fontStyle);
				}
			}
			if(verbose) {
				trace("----------");
				trace("Fonts registered:");
				trace("----------");
				var fonts : Array = Font.enumerateFonts();
				for(var i : String in fonts) {
					font = fonts[i];
					trace("\"" + font.fontName + "\"", font.fontStyle);
				}
				trace("----------");
			}
			if(_callback != null) {
				_callback();
			}
		}
		
		static public function fontAlreadyRegistered(font : Font) : Boolean {
			var fontsRegistered : Array = Font.enumerateFonts();
			var i : int = 0;
			var f : Font;
			for(; i < fontsRegistered.length; i++) {
				f = fontsRegistered[i];
				if(f.fontName == font.fontName && f.fontStyle == font.fontStyle) {
					return true;
				}
			}
			return false;
		}
	}
}