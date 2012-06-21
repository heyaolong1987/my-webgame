package com.netease.webgame.bitchwar.interfaces. {
	
	public interface IHotkey {
		function set hotkey(key:String):void;
		function get hotkey():String;
		function onHotkey():void;
	}
	
}