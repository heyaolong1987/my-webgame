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
			var denom:int = (y2-y1)*(line1.x2-line1.x1)-(x2-x1)*(line1.y2-line1.y1);
			if(denom == 0) {
				if((y2-y1)*(line1.x2-x1) - (x2-x1)*(line1.y2-y1)==0){ //共线
					if(x1==line1.x1&&y1==line1.y1 &&(x2-x1)*(line1.x2-x1)<=0){
						if (intersectionPoint != null){
							intersectionPoint.x = x1;
							intersectionPoint.y = y1;		
						}
						return CLine.SEGMENTS_INTERSECT;
					}
					if(x1==line1.x2&&y1==line1.y2 &&(x2-x1)*(line1.x1-x1)<=0){
						if (intersectionPoint != null){
							intersectionPoint.x = x1;
							intersectionPoint.y = y1;		
						}
						return CLine.SEGMENTS_INTERSECT;
					}
					if(x2==line1.x1&&y2==line1.y1 &&(x1-x2)*(line1.x2-x2)<=0){
						if (intersectionPoint != null){
							intersectionPoint.x = x2;
							intersectionPoint.y = y2;		
						}
						return CLine.SEGMENTS_INTERSECT;
					}
					if(x2==line1.x2&&y2==line1.y2 &&(x1-x2)*(line1.x1-x2)<=0){
						if (intersectionPoint != null){
							intersectionPoint.x = x2;
							intersectionPoint.y = y2;		
						}
						return CLine.SEGMENTS_INTERSECT;
					}
					return CLine.COLLINEAR;
				}
				else{ //平行
					return CLine.PARALELL;
				}
			}else{
				var x:Number = 1.0*((x2-x1)*(line1.x2-line1.x1)*(line1.y1-y1)
					+(y2-y1)*(line1.x2-line1.x1)*x1
					-(line1.y2-line1.y1)*(x2-x1)*line1.x1)
					/denom;
				var y:Number = 1.0*((y2-y1)*(line1.y2-line1.y1)*(line1.x1-x1)
					+(x2-x1)*(line1.y2-line1.y1)*y1
					-(line1.x2-line1.x1)*(y2-y1)*line1.y1)
					/(-denom);
				if (intersectionPoint != null){
					intersectionPoint.x = x;
					intersectionPoint.y = y;		
				}
				if ((x-x1)*(x-x2)<=0 && (x-line1.x1)*(x-line1.x2)<=0){
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
				return POINT_ON_LEFT;
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