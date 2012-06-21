package com.netease.core.events{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.DragSource;
	import mx.core.IUIComponent;

	/**
	 * @author heyaolong
	 * 
	 * 2011-11-5
	 */ 
	public class CDragEvent extends MouseEvent{
		public static const DRAG_COMPLETE:String = "dragComplete";
		public static const DRAG_DROP:String = "dragDrop";
		public static const DRAG_ENTER:String = "dragEnter";
		public static const DRAG_EXIT:String = "dragExit";
		public static const DRAG_OVER:String = "dragOver";
		public static const DRAG_START:String = "dragStart";
		
		public var dragContainer:Sprite;
		public var dragSource:Object;
		public function CDragEvent(type:String,dragContainer:Sprite,dragSource:Object,ctrlKey:Boolean = false,altKey:Boolean = false,shiftKey:Boolean = false)
		{
			super(type,false,false);
			this.dragContainer = dragContainer;
			this.dragSource = dragSource;
			this.ctrlKey = ctrlKey;
			this.altKey = altKey;
			this.shiftKey = shiftKey;
		}
		
		override public function clone():Event
		{
			var cloneEvent:CDragEvent = new CDragEvent(type,dragContainer, dragSource,ctrlKey,altKey, shiftKey);
			return cloneEvent;
		}
	}
}