/**
 * Author:  小神仙
 * Created at: 2010-03-02
 */
package com.netease.webgame.core.events {
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class GMouseEvent extends Event {
		
		public static const ITEM_DOWN:String = "advancedItemDown";
		public static const ITEM_CLICK:String = "advancedItemClick";
		public static const ITEM_DOUBLE_CLICK:String = "advancedItemDoubleClick";
		
		public var localX:Number;
		public var localY:Number;
		
		public var shiftKey:Boolean;
		public var ctrlKey:Boolean;
		public var altKey:Boolean;
		
		public function GMouseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		public function cloneMouseEvent(event:MouseEvent):void {
			this.localX = event.localX;
			this.localY = event.localY;
			this.shiftKey = event.shiftKey;
			this.ctrlKey = event.ctrlKey;
			this.altKey = event.altKey;
		}
		
	}
}