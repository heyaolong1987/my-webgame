package com.netease.core.events{
	import flash.events.Event;

	/**
	 * @author heyaolong
	 * 
	 * 2012-3-19
	 */ 
	public class ClickEvent extends Event{
		public var localX:Number;
		public var localY:Number;
		public static const MY_CLICK:String = "MY_CLICK";
		public function ClickEvent(localX:Number,localY:Number)
		{
			super(MY_CLICK,false,false);
			this.localX = localX;
			this.localY = localY;
		}
	}
}