package com.netease.webgame.bitchwar.interfaces. {
	import flash.display.BitmapData;
	
	
	public interface IDragDropItem {
		
		/**
		 * 提供dragDrop的显示内容，如果返回Null，则会使用BitmapData绘制该DragableItem对象
		 */ 
		function get dragIcon():BitmapData;
		
		function set data(value:IDragDropItemData):void;
		function get data():IDragDropItemData;
		
		function set enabled(value:Boolean):void;
		
		function set width(value:Number):void;
		function set height(value:Number):void;
		
		function set contentWidth(value:Number):void;
		function get contentWidth():Number;
		function set contentHeight(value:Number):void;
		function get contentHeight():Number;
		
		function get dragScaleX():Number;
		function get dragScaleY():Number;
		
		function set cellData(value:BitmapData):void;
		function set cellImage(value:Boolean):void;
		
		function set itemBelongGridType(value:String):void;
		function get itemBelongGridType():String;
		
		function updatePosition(x:int, y:int):void;
		
	}
}