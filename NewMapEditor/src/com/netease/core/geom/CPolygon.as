package com.netease.core.geom{
	/**
	 * @author heyaolong
	 * 
	 * 2012-6-26
	 */ 
	public class CPolygon{
		public var vertexNum:int;
		public var vertexList:Vector.<CPoint>;
		private var rect:CRectangle;
		public function CPolygon(vertexList:Vector.<CPoint>){
			this.vertexList = vertexList;
			this.vertexNum = vertexList.length;
		}
		
		/**
		 *是否是顺时针 
		 * @return 
		 * 
		 */
		public function isClockwise():Boolean {
			if (vertexNum <= 2){
				return false;
			}
			//最上（y最小）最左（x最小）点， 肯定是一个凸点
			//寻找最上点
			var bottomLeftPoint:CPoint = this.vertexList[0];
			var bottomLeftPointId:int = 0;	//点的索引
			for (var i:int=1; i<vertexNum; i++) {
				if (bottomLeftPoint.y > vertexList[i].y) {
					bottomLeftPoint = vertexList[i];
					bottomLeftPointId = i;
				} else if (bottomLeftPoint.y == vertexList[i].y) { //y相等时取x最小
					if (bottomLeftPoint.x > vertexList[i].x) {
						bottomLeftPoint = vertexList[i];
						bottomLeftPointId = i;
					}
				}
			}
			//凸点的邻点
			var lastId:int = bottomLeftPointId-1>=0 ? bottomLeftPointId-1 : vertexNum-1;
			var nextId:int = bottomLeftPointId+1>=vertexNum ? 0 : bottomLeftPointId+1;
			var last:CPoint = vertexList[lastId];
			var next:CPoint = vertexList[nextId];
			if ((last.x-bottomLeftPoint.x)*(next.y-bottomLeftPoint.y)-(next.x-bottomLeftPoint.x)*(last.y-bottomLeftPoint.y) > 0) {
				return true;
			}
			else{
				return false;
			}
		}
		/**
		 * 返回矩形包围盒
		 * @return 
		 */		
		public function rectangle():CRectangle {
			if (vertexList == null || vertexList.length < 0) return null;
			
			if (rect != null) return rect;
			
			var lx:Number = vertexList[0].x;
			var rx:Number = vertexList[0].x;
			var ty:Number = vertexList[0].y;
			var by:Number = vertexList[0].y;
			
			var v:CPoint;
			for (var i:int=1; i<vertexNum; i++) {
				v = vertexList[i];
				if (v.x < lx) {
					lx = v.x;
				}
				if (v.x > rx) {
					rx = v.x;
				}
				if (v.y < ty) {
					ty = v.y;
				}
				if (v.y > by) {
					by = v.y;
				}
			}
			
			rect = new CRectangle(lx,ty,rx-lx,by-ty);
			return rect;
		}
	}
}

