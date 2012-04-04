package com.sosappy.video.controllers
{
	import com.sosappy.display.IButton;

	public interface IBigPlayButton extends IButton
	{
		function showPlay() : void;
		
		function showPause() : void;
		
		function get isPlaying() : Boolean;
	}
}