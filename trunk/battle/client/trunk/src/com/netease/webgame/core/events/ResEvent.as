package com.netease.webgame.core.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class ResEvent extends Event
	{
		public var data:DisplayObject;
		public function ResEvent(type:String,data:DisplayObject)
		{
			this.data = data;
			super(type,false,false);
		}
	}
}