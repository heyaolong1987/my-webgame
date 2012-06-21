package com.netease.core.events{
	import flash.events.Event;

	/**
	 * @author heyaolong
	 * 
	 * 2012-3-19
	 */ 
	public class DoubleClickEvent extends Event{
		public var localX:Number;
		public var localY:Number;
		public static const MY_DOUBLE_CLICK:String = "MY_DOUBLE_CLICK";
		public function DoubleClickEvent(localX:Number,localY:Number)
		{
			super(MY_DOUBLE_CLICK,false,false);
			this.localX = localX;
			this.localY = localY;
		}
	}
}