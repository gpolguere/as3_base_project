package com.sosappy.display
{
	import flash.display.Sprite;

	public interface IButton
	{
		
		function get container() : Sprite;
		
		function enable() : void;
		
		function disable() : void;
		
		function destroy() : void;
	}
}