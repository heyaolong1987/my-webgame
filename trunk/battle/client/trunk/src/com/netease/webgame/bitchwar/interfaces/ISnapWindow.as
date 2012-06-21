package com.netease.webgame.bitchwar.interfaces. {
	import mx.core.IFlexDisplayObject;
	
	public interface ISnapWindow extends IFlexDisplayObject {
		
		function addSnap(child:ISnapWindow):void;
		function setSnapParent(parent:ISnapWindow):void;
		function snapClose(child:ISnapWindow):void;
		function snapMove(child:ISnapWindow, x:int, y:int):void;
		function moveSnap(x:int, y:int):void;
		
		function get snapWidth():int;
		function get snapHeight():int;
		
	}
}