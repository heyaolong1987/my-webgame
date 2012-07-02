package com.netease.core.algorithm{
	import com.netease.core.geom.CCircle;
	import com.netease.core.geom.CLine;
	import com.netease.core.geom.CPoint;
	import com.netease.core.geom.CPolygon;
	import com.netease.core.geom.CRectangle;
	import com.netease.core.geom.CTriangle;
	
	import flash.geom.Point;
	
	/**
	 * @author heyaolong
	 * Delaunay三角剖分
	 * 2012-6-29
	 */ 
	public class CDelaunay{
		public function CDelaunay()
		{
		}
		
		public static function createDelaunay(polygonList:Vector.<CPolygon>):Vector.<CTriangle>{
			var vertexList:Vector.<CPoint> = new Vector.<CLine>(); //所有顶点列表
			var edgeList:Vector.<CLine> = new Vector.<CLine>();//所有边列表
			var triangleList:Vector.<CTriangle> = new Vector.<CTriangle>(); //所有生成的三角形列表
			var edgeStack:Vector.<CLine> = new Vector.<CLine>(); //线段堆栈
			
			var i:int,j:int;
			var len:int;
			var vertexLen:int;
			var vertex:CPoint;
			var edge:CLine;
			var poly:CPolygon;
			var p1:CPoint,p2:CPoint;
			
			
			len = polygonList.length;
			for(i=0; i<len; i++){
				poly = polygonList[i];
				//放入所有的顶点
				for each(var vertex:CPoint in poly.vertexList){
					vertexList.push(vertex);
				}
				//放入所有边
				vertexLen = poly.vertexList.length;
				p1= vertexList[0];
				for (j=1; j<vertexLen; j++) {
					p2 = poly.vertexList[j];
					edgeList.push(new CLine(p1.x,p1.y, p2.x, p2.y));
					p1 = p2;
				}
				p2 = poly.vertexList[0];
				edgeList.push(new CLine(p1.x,p1.y, p2.x,p2.y));
			}
			var initEdge:CLine = getInitOutEdge(edgeList,vertexList);
			edgeStack.push(initEdge);
			do{
				edge = edgeStack.pop();
				vertex = findDT(vertexList,edgeList,edge);
				if(vertex == null){
					continue;
				}
				var line13:CLine = new CLine(edge.x1, edge.y1, vertex.x, vertex.y);
				var line32:CLine = new CLine(vertex.x, vertex.y, edge.x2, edge.y2);
				
				var triangle:CTriangle = new CTriangle(edge.x1,edge.y1,edge.x2, edge.y2, vertex.x, vertex.y);
				triangleList.push(triangle);
				
				var index:int;
				if(isInLineList(line13, edgeList) < 0){
					index = isInLineList(line13, edgeStack);
					if(index > -1){
						edgeStack.splice(index,1);
					}
					else{
						edgeStack.push(line13);
					}
				}
				
				if(isInLineList(line32, edgeList) < 0){
					index = isInLineList(line32, edgeStack);
					if(index > -1){
						edgeStack.splice(index,1);
					}
					else{
						edgeStack.push(line32);
					}
				}
				
			}
			while(edgeStack.length > 0);
			
			return triangleList;
		}
		private static function isInLineList(line:CLine,lineList:Vector.<CLine>):int{
			var line2:CLine;
			var i:int;
			var len:int = lineList.length;
			for(i=0; i<len; i++){
				line2 = lineList[i];
				if(line.equals(line2)){
					return i;
				}
			}
			return -1;
		}
		/**
		 * 获取初始外边界
		 * @return 
		 */		
		private static function getInitOutEdge(edgeList:Vector.<CLine>,vertexList:Vector.<CPoint>):CLine {
			var initEdge:CLine;
			var hasOnlineVertex:Boolean;
			var i:int;
			var len:int = edgeList.length;
			for(i=0; i<len; i++){
				initEdge = edgeList[i];
				hasOnlineVertex = false;
				for each (var vertex:CPoint in vertexList) {
					if ((vertex.x == initEdge.x1 && vertex.y == initEdge.y1)
						||(vertex.x == initEdge.x2 && vertex.y == initEdge.y2)){
						continue;
					}
					if (initEdge.checkPointPos(vertex) == CLine.POINT_ON_LINE) {
						hasOnlineVertex = true;
						break;
					}
				}
				if(hasOnlineVertex == false){
					break;
				}
			}
			return initEdge;
		}
		
		private static function findDT(vertexList:Vector.<CPoint>, edgeList:Vector.<CLine>, edge:CLine):CPoint{
			var allVisibleVertex:Vector.<CPoint> = new Vector.<CPoint>();
			
			var line12:CLine = edge;
			var line13:CLine = new CLine();
			var line23:CLine = new CLine();
			
			line13.x1 = edge.x1;
			line13.y1 = edge.y1;
			line23.x2 = edge.x2;
			line23.y2 = edge.y2;
			
			for each(var vertex:CPoint in vertexList){
				//左边必定相交
				if(line12.checkPointPos(vertex) != CLine.POINT_ON_RIGHT){
					continue;
				}
				
				line13.x2 = vertex.x;
				line13.y2 = vertex.y;
				if(isIntersectWidthLines(line13,edgeList)== false){
					continue;
				}
				
				line23.x2 = vertex.x;
				line23.y2 = vertex.y;
				if(isIntersectWidthLines(line23,edgeList)== false){
					continue;
				}
				allVisibleVertex.push(vertex);
			}
			if(allVisibleVertex.length == 0){
				return null;
			}
			
			var p3:CPoint = allVisibleVertex[0];
			var isMaxAngle:Boolean;
			do{
				isMaxAngle = true;
				var circle:CCircle = CCircle.createCircle(edge.x1,edge.y1,edge.x2,edge.y2,p3.x,p3.y);
				var bounds:CRectangle = circleBounds(circle);
				var angle132:Number = Math.abs(CTriangle.lineAngle(edge.x1, edge.y1, p3.x, p3.y, edge.x2, edge.y2));
				for each(var p4:CPoint in allVisibleVertex){
					if((p4.x == edge.x1 && p4.y == edge.y1)
						|| (p4.x == edge.x2 && p4.y == edge.y2)
						|| (p4.x == p3.x && p4.y == p3.y)){
						continue;
					}
					if(bounds.contains(p4.x,p4.y) == false){
						continue;
					}
					
					var angle142:Number = Math.abs(CTriangle.lineAngle(edge.x1, edge.y1, p4.x, p4.y, edge.x2, edge.y2));
					if(angle142 > angle132){
						p3 = p4;
						isMaxAngle = false;
						break;
					}
					
				}
			}
			while(isMaxAngle==false);
			return p3;
			
		}
		/**
		 * 返回圆的包围盒
		 * @param c
		 * @return 
		 */		
		private static function circleBounds(c:CCircle):CRectangle {
			return new CRectangle(c.x-c.r, c.y-c.r, c.r*2, c.r*2);
		}
		
		/**
		 * 
		 * @param vertex
		 * @param line
		 * @return 
		 * 
		 */
		private static function isVisiblePointOfLine(vertex:CPoint,line:CLine):Boolean{
			
		}
		
		private static function isIntersectWidthLines(edge:CLine, edgeList:Vector.<CLine>):Boolean{
			var point:CPoint;
			for each(var line:CLine in edgeList){
				if(edge.intersection(line,point) == CLine.SEGMENTS_INTERSECT){
					if((edge.x1 != point.x || edge.y1 != point.y)
						&& (edge.x2 != point.x || edge.y2 != point.y)){
						return false;
					}
				}
			}
			return true;
		}
	}
}