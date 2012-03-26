package
{
	import avmplus.getQualifiedClassName;
	import avmplus.getQualifiedSuperclassName;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.BinaryItem;
	import br.com.stimuli.loading.loadingtypes.URLItem;
	
	import com.sosappy.app.App;
	import com.sosappy.app.IMain;
	import com.sosappy.app.loader.ILoader;
	import com.sosappy.app.loader.MainLoader;
	import com.sosappy.text.FontsManager;
	import com.sosappy.text.StyledTextField;
	import com.sosappy.text.Styles;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	import utils.type.getClassByName;
	
	public class Preloader extends MainLoader implements ILoader
	{
		private var _loader : BulkLoader;
		private var _main : IMain;
		
		public function Preloader()
		{
			super();
		}
		
		override protected function init() : void
		{
			super.init();
			
			initStage();
			initLoader();
			//
			onInitEnd();
		}
		
		private function initStage():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			App.stage = stage;
		}
		
		private function initLoader():void
		{
			_loader = new BulkLoader("main_loader", int.MAX_VALUE);
			_loader.add("stylesheets/flash.css", {id: "css"});
			_loader.add("Main.swf", {id: "main"});
			_loader.add("xml/lang/en/lang_en.xml", {id: "xml"});
			_loader.add("font_latin_extended_a.swf", {id: "fonts", type: "binary"});
		}
		
		override protected function start() : void
		{
			super.start();
			
			_loader.start();
		}
		
		override protected function onEnterFrame(event : Event) : void
		{
			if(_loader.weightPercent == 1) {
				onReady();
			} else {
			}
		}
		
		override protected function onReady() : void {
			super.onReady();
			
			App.langXML = _loader.getXML("xml");
			
			Styles.getInstance().parse(_loader.getText("css"));
			Styles.getInstance().defaultStyle = App.langXML.child("default_style").toString();
			StyledTextField.globalStyleSheet = Styles.getInstance().styleSheet;
			
			FontsManager.verbose = true;
			FontsManager.registerFromSWF(_loader.getBinary("fonts"), onFontsRegistered);
		}
		
		private function onFontsRegistered() : void {
			_main = _loader.getSprite("main") as IMain;
			_main.onReady = onMainReady;
			_main.init();
		}
		
		private function onMainReady() : void {
			trace("Preloader.onMainReady()");
			addChild(_main as DisplayObject);
			_main.start();
		}
		
	}
}