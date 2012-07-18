package com.netease.core.geom{
	
	/**
	 *
	 *@author heyaolong
	 *
	 *2012-7-1
	 */
	public class CCircle{
		public var x:Number;
		public var y:Number;
		public var r:Number;
		public function CCircle(x:Number,y:Number,r:Number):void
		{
			this.x = x;
			this.y = y;
			this.r = r;
		}
		public static function createCircle(x1:int, y1:int, x2:int, y2:int, x3:int, y3:int):CCircle{
			var x:Number,y:Number,r:Number;
			var a:Number,b:Number, c:Number, d:Number, e:Number;
			a = x1*(y2-y3)+x2*(y3-y1)+x3*(y1-y2);
			b = (x1*x1+y1*y1-x2*x2-y2*y2)/2;
			c = (x1*x1+y1*y1-x3*x3-y3*y3)/2;
			d = b*(y1-y3)-c*(y1-y2);
			e = c*(x1-x2)-b*(x1-x3);
			x = d/a;
			y = e/a;
			r = Math.sqrt((x-x1)*(x-x1)+(y-y1)*(y-y1));
			return new CCircle(x,y,r);
		}
	}
}