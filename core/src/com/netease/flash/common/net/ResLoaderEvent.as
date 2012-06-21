package com.netease.flash.common.net {
	
	import flash.events.Event;
	
	/**
	 * pooled SWF loader event
	 */
	public class ResLoaderEvent extends Event {
		public static const RES_LOADED:String = "resLoaded";
		
		public function ResLoaderEvent(type:String) {
			super(type);
		}
	}
}