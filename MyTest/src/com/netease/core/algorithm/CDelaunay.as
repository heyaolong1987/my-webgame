package com.netease.core.algorithm{
	import com.netease.core.geom.CLine;
	import com.netease.core.geom.CPoint;
	import com.netease.core.geom.CPolygon;
	import com.netease.core.geom.CTriangle;
	
	import flash.geom.Point;
	
	/**
	 * @author heyaolong
	 * Delaunay三角剖分
	 * 2012-6-29
	 */ 
	public class CDelaunay{
		private var polygonList:Vector.<CPolygon>; //所有多边形的集合
		private var vertexList:Vector.<CPoint>; //所有顶点列表
		private var edgeList:Vector.<CLine>; //所有边列表
		private var triangleList:Vector.<CTriangle>;
		
		private var lineStack:Vector.<CLine>; //线段堆栈
		
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
			var p1:Point,p2:Point;
			
			
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
					this.edgeList.push(new CLine(p1, p2));
					p1 = p2;
				}
				p2 = poly.vertexList[0];
				this.edgeList.push(new CLine(p1, p2));
			}
			var initEdge:CLine = getInitOutEdge();
			edgeStack.push(initEdge);
			do{
				edge = edgeStack.pop();
				vertex = findDT(edge);
				if(vertex){
					
				}
			}
				
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
		
		private static function findDT(vertexList:Vector.<CPoint>, edge:CLine):CPoint{
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
			
			var point:CPoint = allVisibleVertex[0];
			do{
				
			}
			
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