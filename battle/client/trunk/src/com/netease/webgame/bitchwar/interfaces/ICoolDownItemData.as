package com.netease.webgame.bitchwar.interfaces. {
	
	public interface ICoolDownItemData {
		
		function set cdStart(value:Number):void;
		function get cdStart():Number;
		function set cdEnd(value:Number):void;
		function get cdEnd():Number;
		function set cdType(value:int):void;
		function get cdType():int;
		
		function get isInCd():Boolean;
		
	}
}