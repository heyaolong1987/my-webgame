package com.netease.core.geom{
	/**
	 * @author heyaolong
	 * 
	 * 2012-6-26
	 */ 
	public class CPoint{
		public var x:int;
		public var y:int;
		public function CPoint(x:int=0,y:int=0):void
		{
			this.x = x;
			this.y = y;
		}
		
		public static function distance(p1:CPoint,p2:CPoint):Number{
			return Math.sqrt((p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y));
		}
	}
}