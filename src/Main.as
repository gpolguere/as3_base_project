package
{
	import com.sosappy.app.App;
	import com.sosappy.app.IMain;
	import com.sosappy.text.StyledTextField;
	import com.sosappy.text.Styles;
	import com.sosappy.video.VideoController;
	import com.sosappy.video.VideoControllerEvent;
	import com.sosappy.video.VideoPlayer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.text.TextField;
	
	import nl.base42.subtitles.SubtitleParser;
	
	import utils.object.isEmpty;
	
	public class Main extends Sprite implements IMain
	{
		private var _onReadyCallback : Function;
		private var _mainTitleTf:StyledTextField;
		private var _videoPlayer:VideoPlayer;
		
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
			
			var urlLoader : URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onSRTLoaded);
			urlLoader.load(new URLRequest("test.srt"));
		}
		
		protected function onSRTLoaded(event:Event):void
		{
			var urlLoader : URLLoader = event.target as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onSRTLoaded);
			_videoPlayer.srt = SubtitleParser.parseSRT(urlLoader.data);
			
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
			addChild(_mainTitleTf.asset);
			
			var vc : VideoController = new VideoController();
//			addChild(vc.container);
			vc.addEventListener(VideoControllerEvent.PROGRESS, onVideoProgress);
			vc.addEventListener(VideoControllerEvent.LOADED, onVideoLoaded);
			vc.loop = true;
			vc.load("video-01.mp4");
			vc.pause();
			vc.setStageVideo(true);
			
			_videoPlayer = new VideoPlayer(vc, null, false);
			addChild(_videoPlayer.container);
//			vp.fullscreen = true;
		}
		
		protected function onVideoProgress(event:VideoControllerEvent):void
		{
			trace(event.ratio);
		}
		
		protected function onVideoLoaded(event:VideoControllerEvent):void
		{
			trace("video loaded");
		}
		
		protected function onResize():void
		{
			_mainTitleTf.asset.x = (App.stage.stageWidth - _mainTitleTf.asset.width) >> 1;
		}
		
		public function start() : void {
			trace("Main.start()");
			
			_videoPlayer.videoController.play();
		}
	}
}