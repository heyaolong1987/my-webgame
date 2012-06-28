package com.netease.core.geom{
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
		public static const LINES_INTERSECT:int = 1;	
		public static const SEGMENTS_INTERSECT:int = 2;	
		public static const A_BISECTS_B:int = 3;
		public static const B_BISECTS_A:int = 4;
		/**
		 *平行 
		 */
		public static const PARALELL:int = 5;
		
		public var x1:int;
		public var y1:int;
		public var x2:int;
		public var y2:int;
		public function CLine()
		{
			
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
			(line1.x1-x1)
			(line1.y1-y1)
			
			
			var b1:int = (p1.x - p0.x) * (p2.y - p0.y) - (p2.x - p0.x) * (p1.y - p0.y);
			
			var b2:int = (a2-x1)*(a2-b2)*(a2-b2)*(a2-b1)>=0 
				
			var denom:int = (line1.y2-line1.y1)*(x2-x1)-(line1.x2-line1.x1)*(y2-y1);
			var u0:int = (line1.x2-line1.x1)*(y1-line1.y1)-(line1.y2-line1.y1)*(x1-line1.x1);
			var u1:int = (line1.x1-x1)*(y2-y1)-(line1.y1-y1)*(x2-x1);
			
			
			var t0:int = (line1.x1-line1.x2)*(x1*y2-x2*y1)-(x1-x2)*(line1.x1*line1.y2-line1.x2*line1.y1);
			var t1:int = (line1.y1-line1.y2)*(y1*x2-y2*x1)-(y1-y2)*(line1.y1*line1.x2-line1.y2*line1.x1);
			if(denom == 0) { 
				if(u0 == 0 && u1 == 0){ //共线
					return CLine.COLLINEAR;
				}
				else{ //平行
					return CLine.PARALELL;
				}
			}else{
				
					
				if (intersectionPoint != null){
					pIntersectPoint.x = t0/denom;
					pIntersectPoint.y = t1/denom;
				}
				if (u0*denom>=0 && u0<=denomu){
					if(u1*denom >= 0) && u1 <=denomu){
						return CLine.SEGMENTS_INTERSECT;
					}
					else{
						return CLine.B_BISECTS_A;
					}
				}
				else if(u1*denom>=0 && u1<=denomu){
					return CLine.A_BISECTS_B;
				}
				else{
					return CLine.LINES_INTERSECT;
				}
			}
		}
		
	}
}