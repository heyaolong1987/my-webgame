package com.netease.core.geom{
	
	/**
	 *
	 *@author heyaolong
	 *
	 *2012-7-1
	 */
	public class CCircle{
		public var cx:Number;
		public var cy:Number;
		public var r:Number;
		private var a:Number;
		private var b:Number;
		private var c:Number;
		private var d:Number;
		private var e:Number;
		private var f:Number;
		public function CCircle(x1:int, y1:int, x2:int, y2:int, x3:int, y3:int):void
		{
			a = x1*(y2-y3)+x2*(y3-y1)+x3*(y1-y2);
			d = (x1*x1+y1*y1)*(y2-y3)+(x2*x2+y2*y2)*(y3-y1)+(x3*x3+y3*y3)*(y1-y2);
			e = (x1*x1+y1*y1)*(x3-x2)+(x2*x2+y2*y2)*(x1-x3)+(x3*x3+y3*y3)*(x2-x1);
			f = (x1*x1+y1*y1)*(x2*y3-x3*y2)+(x2*x2+y2*y2)*(x3*y1-y3*x1)+(x3*x3+y3*y3)*(y2*x1-x2*y1);
			cx = d/a/2;
			cy = e/a/2;
			r = Math.sqrt(4*a*f+d*d+e*e)/a/2;
		}
		public function isIn(x:int,y:int):Boolean{
			return a*(x*x+y*y)-d*x-e*y-f > 0;
		}
		public function isOn(x:int,y:int):Boolean{
			return a*(x*x+y*y)-d*x-e*y-f == 0;
		}
	}
}