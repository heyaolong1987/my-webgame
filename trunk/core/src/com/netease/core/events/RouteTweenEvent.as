package com.netease.core.events{
	import com.netease.core.utils.MovingTween;
	
	import flash.events.Event;

	/**
	 * @author heyaolong
	 * 
	 * 2012-5-23
	 */ 
	public class RouteTweenEvent extends Event{
		public static const ROUTE_START:String = "ROUTE_START";
		public static const POS_UPDATE:String = "POS_UPDATE";
		public static const ROUTE_END:String = "ROUTE_END";
		public var data:MovingTween;
		public var x:Number;
		public var y:Number;
		public var direction:int;
		public function RouteTweenEvent(type:String,data:MovingTween,x:Number=0,y:Number=0,direction:int=0)
		{
			this.data = data;
			this.x = x;
			this.y = y;
			this.direction = direction;
			super(type,false,false);
		}
	}
}