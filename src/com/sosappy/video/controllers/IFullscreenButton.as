package com.sosappy.video.controllers
{
	import com.sosappy.display.IButton;

	public interface IFullscreenButton extends IButton
	{
		
		function showFullscreen() : void;
		
		function showNormal() : void;
		
		function get isFullscreen() : Boolean;
	}
}