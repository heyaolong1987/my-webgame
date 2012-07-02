package com.netease.core.geom{
	import flash.geom.Point;

	/**
	 * @author heyaolong
	 * 
	 * 2012-6-26
	 */ 
	public class CLine{
		/**
		 *共线 
		 */
		public static const COLLINEAR:int = 0;
		/**
		 *平行 
		 */
		public static const PARALELL:int = 1;
		/**
		 *当是两条直线时，才相交
		 */
		public static const LINES_INTERSECT:int = 2;	
		/**
		 *线段相交 
		 */
		public static const SEGMENTS_INTERSECT:int = 3;
		
		
		public static const POINT_ON_LINE:int = 0;
		public static const POINT_ON_LEFT:int = 1;
		public static const POINT_ON_RIGHT:int = 2;
		
		public var x1:int;
		public var y1:int;
		public var x2:int;
		public var y2:int;
		public function CLine(x1:int=0, y1:int=0, x2:int=0, y2:int=0)
		{
			this.x1 = x1;
			this.y1 = y1;
			this.x2 = x2;
			this.y2 = y2;
		}
		
		/**
		 * 判断两个直线关系
		 * @param line1
		 * @param intersectionPoint
		 * @return 
		 * 
		 */
		public function intersection(line1:CLine,intersectionPoint:CPoint=null):int
		{
			var denom:Number = (line1.y2-line1.y1)*(x2-x1)-(line1.x2-line1.x1)*(y2-y1);
			var u0:Number = (line1.x2-line1.x1)*(y1-line1.y1)-(line1.y2-line1.y1)*(x1-line1.x1);
			var u1:Number = (line1.x1-x1)*(y2-y1)-(line1.y1-y1)*(x2-x1);
			if(denom == 0) { 
				if(u0 == 0 && u1 == 0){ //共线
					return CLine.COLLINEAR;
				}
				else{ //平行
					return CLine.PARALELL;
				}
			}else{
				u0 = u0/denom;
				u1 = u1/denom;
				if (intersectionPoint != null){
					intersectionPoint.x = x1 + u0*(x2-x1);
					intersectionPoint.y = y1 + u0*(y2-y1);
				}
				if (u0>=0 && u0<=1 && u1>=0 && u1 <=1){
					return CLine.SEGMENTS_INTERSECT;
				}
				else{
					return CLine.LINES_INTERSECT;
				}
			}
		}
		
		public function checkPointPos(p:CPoint):int{
			var t:int = (y2-y1)*(p.x-x1)-(x2-x1)*(p.y-y1);
			 
			if(t > 0){
				return POINT_ON_RIGHT;
			}
			else if(t < 0){
				return POINT_ON_RIGHT;
			}
			else{
				return POINT_ON_LINE;
			}
		}
		
		public function equals(line:CLine):Boolean{
			return (x1 == line.x1 && y1 == line.y1 && x2 == line.x2 && y2 == line.y2)
			        || (x2 == line.x1 && y2 == line.y1 && x1 == line.x2 && y1 == line.y2);
		}
		
	}
}