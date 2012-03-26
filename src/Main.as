package
{
	import com.sosappy.app.App;
	import com.sosappy.app.IMain;
	import com.sosappy.text.StyledTextField;
	import com.sosappy.text.Styles;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.Font;
	import flash.text.TextField;
	
	import utils.object.isEmpty;
	
	public class Main extends Sprite implements IMain
	{
		private var _onReadyCallback : Function;
		private var _mainTitleTf:StyledTextField;
		
		public function Main()
		{
			trace("toto");
		}
		
		public function set onReady(callback : Function) : void {
			trace("Main.onReady(callback)");
			
			_onReadyCallback = callback;
		}
		
		public function init() : void {
			trace("Main.init()");
			
			drawUI();
			
			App.registerForResize(onResize);
			onResize();
			
//			SWFAddress
			
			_onReadyCallback();
		}
		
		private function drawUI():void
		{
			/*
			var tf : StyledTextField = new StyledTextField("test");
			tf.htmlText = "<i>Hello</i>";
			addChild(tf);
			
			var tf2 : TextField = new TextField();
			addChild(tf2);
			tf2.text = "Hello";
			tf2.x = 100;
			tf2.y = 100;
			tf2.border = true;
			
			var o : Object = Styles.getInstance().styleSheet.getStyle(".lang_button_cn_CN");
			for(var i : String in o) {
				//				trace(i, o[i]);
			}
			*/
			StyledTextField.suffix = "cn_CN";
			
			_mainTitleTf = new StyledTextField("main_title");
			_mainTitleTf.htmlText = App.langXML["main_title"].toString();
			addChild(_mainTitleTf);
		}
		
		protected function onResize():void
		{
			_mainTitleTf.x = (App.stage.stageWidth - _mainTitleTf.width) >> 1;
		}
		
		public function start() : void {
			trace("Main.start()");
		}
	}
}