package com.netease.core.interfaces{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author heyaolong
	 * 
	 * 2011-11-5
	 */ 
	public interface ICDragManager{
		function get isDragging():Boolean;
		function doDrag(
			dragContainer:Sprite,
			dragSource:DisplayObject,
			mouseEvent:MouseEvent,
			dragImage:DisplayObject = null,
			xOffset:int = 0,
			yOffset:int = 0,
			imageAplpha:Number=0.5):void;
		function acceptDragDrop(target:Sprite):void;
		function endDrag():void;
	}
}