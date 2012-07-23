package com.netease.core.geom{
	
	/**
	 *
	 *@author heyaolong
	 *
	 *2012-7-1
	 */
	public class CCircle{
		public static const POINT_IN:int = -1;
		public static const POINT_ON:int = 0;
		public static const POINT_OUT:int = 1;
		
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
			a = 1.0*x1*(y2-y3)+1.0*x2*(y3-y1)+1.0*x3*(y1-y2);
			d = 1.0*(x1*x1+y1*y1)*(y2-y3)+1.0*(x2*x2+y2*y2)*(y3-y1)+1.0*(x3*x3+y3*y3)*(y1-y2);
			e = 1.0*(x1*x1+y1*y1)*(x3-x2)+1.0*(x2*x2+y2*y2)*(x1-x3)+1.0*(x3*x3+y3*y3)*(x2-x1);
			f = 1.0*(x1*x1+y1*y1)*(x2*y3-x3*y2)+1.0*(x2*x2+y2*y2)*(x3*y1-y3*x1)+1.0*(x3*x3+y3*y3)*(x1*y2-y1*x2);
			cx = d/a/2;
			cy = e/a/2;
			r = Math.sqrt(4*a*f+d*d+e*e)/Math.abs(a)/2;
		}
		public function checkPointPos(x:int,y:int):Boolean{
			
			var flag:Number = 1.0*a*(a*(x*x+y*y)-1.0*d*x-1.0*e*y-1.0*f);
			if(flag > 0){
				return POINT_OUT;
			}
			else if(flag < 0){
				return POINT_IN;
			}
			else{
				return POINT_ON;
			}
		}
	
	}
}