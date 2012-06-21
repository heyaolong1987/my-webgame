package com.netease.core.events {
	import flash.events.Event;

	/**
	 * @author heyaolong
	 * 
	 * 2011-10-29
	 */ 
	public class GameEvent extends Event{
		
		public function GameEvent(type:String,data:Object=null)
		{
			super(type,false,false);
		}
	}
}