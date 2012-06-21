/**
 * Author:  小神仙
 * Created at: 2010-03-02
 */
package com.netease.webgame.core.events {
	import com.netease.webgame.bitchwar.interfaces..IDragDropGrid;
	import com.netease.webgame.bitchwar.interfaces..IDragDropItem;
	import com.netease.webgame.bitchwar.interfaces..IDragDropItemData;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;

	public class DragDropEvent extends Event {
		
		public static const DRAG_START:String = "gridDragStart";
		public static const DRAG_OVER:String = "gridDragOver";
		public static const DRAG_DROP:String = "gridDragDrop";
		public static const DRAG_FAILURE:String = "gridDragFailure";
		public static const DRAG_OUT:String = "gridDragOut";
		public static const DRAG_STOP:String = "gridDragStop";
		
		public var dragGrid:IDragDropGrid;
		public var dragPosition:int;
		public var dragData:IDragDropItemData;
		
		public var dragSource:BitmapData;
		public var dragScaleX:Number;
		public var dragScaleY:Number;
		
		public var dropGrid:IDragDropGrid;
		public var dropPosition:int;
		public var dropData:IDragDropItemData;
		
		public var splitMode:Boolean = false;
		public var splitNum:int;
		
		public var dragIcon:Sprite;
		
		public function DragDropEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		public function copyProperties(source:DragDropEvent):void {
			dragGrid = source.dragGrid;
			dragData = source.dragData;
			dragSource = source.dragSource;
			dragScaleX = source.dragScaleX;
			dragScaleY = source.dragScaleY;
			dragPosition = source.dragPosition;
			dropData = source.dropData;
			dropGrid = source.dropGrid;
			dropPosition = source.dropPosition;
			splitMode = source.splitMode;
			splitNum = source.splitNum;
		}
	}
}