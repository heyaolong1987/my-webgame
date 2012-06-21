package com.netease.webgame.core.events
{
	import flash.events.Event;

	public class GameEvent extends Event
	{
		public var data:Object;
		public function GameEvent(type:String,data:Object=null)
		{
			this.data = data;
			super(type,false,true);
		}
	}
}