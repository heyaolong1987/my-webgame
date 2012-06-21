package com.netease.webgame.bitchwar.events {
	
	import flash.events.Event;
	
	public class GPageEvent extends Event {
		
		public static const PAGE_CHANGE:String = "pageChange";
		
		public var pageNo:int;
		
		public function GPageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}

	}
}