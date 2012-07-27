package com.netease.core.events{
	import flash.display.InteractiveObject;
	import flash.events.Event;

	/**
	 * @author heyaolong
	 * 精确点击事件
	 * 2012-7-26
	 */ 
	public class PreciseClickEvent extends Event{
		/***点击了地图上的一个可交互item***/
		public static const ITEM_CLICK:String = "itemClick";
		/***鼠标over地图上的一个可交互item**/
		public static const ITEM_OVER:String = "itemOver";
		/***鼠标out地图上的一个可交互item***/
		public static const ITEM_OUT:String = "itemOut";
		public var item:InteractiveObject;
		public var localX:int;
		public var localY:int;
		public function PreciseClickEvent(type:String,localX:int,localY:int,target:InteractiveObject)
		{
			super(type, true);
			this.localX = localX;
			this.localY = localY;
			item = target;
		}
	}
}
