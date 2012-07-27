package com.netease.core.events{
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 *
	 *@author heyaolong
	 *
	 *2012-1-2
	 */
	public class TileMouseEvent extends Event{
		public static const CLICK:String = "CLICK";
		public var targetPoint:Point;
		public var targetStagePoint:Point;
		public function TileMouseEvent(type:String,targetPoint:Point,targetStagePoint:Point)
		{
			super(type,false,false);
			this.targetPoint = targetPoint;
			this.targetStagePoint = targetStagePoint;
			
		}
	}
}