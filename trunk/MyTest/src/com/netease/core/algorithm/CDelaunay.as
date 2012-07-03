package com.netease.core.algorithm{
	import com.netease.core.geom.CCircle;
	import com.netease.core.geom.CLine;
	import com.netease.core.geom.CPoint;
	import com.netease.core.geom.CPolygon;
	import com.netease.core.geom.CRectangle;
	import com.netease.core.geom.CTriangle;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
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
			var vertexList:Vector.<CPoint> = new Vector.<CPoint>(); //所有顶点列表
			var edgeList:Vector.<CLine> = new Vector.<CLine>();//所有边列表
			var noVisitEdgeList:Dictionary = new Dictionary(); //所有没有作为三角形边的边列表
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
				//放入所有边
				vertexLen = poly.vertexList.length;
				//放入所有的顶点
				for(j=0; j<vertexLen; j++){
					vertexList.push(poly.vertexList[j]);
				}
				
				p1= poly.vertexList[0];
				for (j=1; j<vertexLen; j++) {
					p2 = poly.vertexList[j];
					edgeList.push(new CLine(p1.x,p1.y, p2.x, p2.y));
					p1 = p2;
				}
				p2 = poly.vertexList[0];
				edgeList.push(new CLine(p1.x,p1.y, p2.x,p2.y));
			}
			var edgeListLen:int = edgeList.length;
			for(i=0; i<edgeListLen; i++){
				noVisitEdgeList[i] = true;
			}
			var initEdge:CLine;
			initEdge = getInitOutEdge(edgeList,noVisitEdgeList,vertexList);
			while(initEdge){
				edgeStack.push(initEdge);
				do{
					edge = edgeStack.pop();
					vertex = findDT(vertexList,edgeList,edge);
					if(vertex == null){
						continue;
					}
					var line13:CLine = new CLine(edge.x1, edge.y1, vertex.x, vertex.y);
					var line32:CLine = new CLine(vertex.x, vertex.y, edge.x2, edge.y2);
					
					var triangle:CTriangle = new CTriangle(edge.x1,edge.y1, vertex.x, vertex.y,edge.x2, edge.y2);
					triangleList.push(triangle);
					
					var index:int = isInEdgeList(line13, edgeList);
					if(index < 0){
						index = isInEdgeList(line13, edgeStack);
						if(index > -1){
							edgeStack.splice(index,1);
						}
						else{
							edgeStack.push(line13);
						}
					}
					else{
						noVisitEdgeList[index] = null;
						delete noVisitEdgeList[index];
					}
					index = isInEdgeList(line32, edgeList);
					if(index < 0){
						index = isInEdgeList(line32, edgeStack);
						if(index > -1){
							edgeStack.splice(index,1);
						}
						else{
							edgeStack.push(line32);
						}
					}
					else{
						noVisitEdgeList[index] = null;
						delete noVisitEdgeList[index];
					}
				}
				while(edgeStack.length > 0);
				initEdge = getInitOutEdge(edgeList,noVisitEdgeList,vertexList);
			}
			
			
			return triangleList;
		}
		private static function isInEdgeList(line:CLine,edgeList:Vector.<CLine>):int{
			var line2:CLine;
			var i:int;
			var len:int = edgeList.length;
			for(i=0; i<len; i++){
				line2 = edgeList[i];
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
		private static function getInitOutEdge(edgeList:Vector.<CLine>,noVisitEdgeList:Dictionary,vertexList:Vector.<CPoint>):CLine {
			var initEdge:CLine;
			var i:int,j:int;
			var allVisibleVertex:Vector.<CPoint> = new Vector.<CPoint>();
			var line12:CLine;
			var line13:CLine = new CLine();
			var line23:CLine = new CLine();
			for(var k:String in noVisitEdgeList){
				line12 = edgeList[int(k)];
				line13.x1 = line12.x1;
				line13.y1 = line12.y1;
				line23.x2 = line12.x2;
				line23.y2 = line12.y2;
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
					
					line23.x1 = vertex.x;
					line23.y1 = vertex.y;
					if(isIntersectWidthLines(line23,edgeList)== false){
						continue;
					}
					noVisitEdgeList[k] = null;
					delete noVisitEdgeList[k];
					return line12;
				}
			}
			return null;
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
				
				line23.x1 = vertex.x;
				line23.y1 = vertex.y;
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
		
		
		private static function isIntersectWidthLines(edge:CLine, edgeList:Vector.<CLine>):Boolean{
			var point:CPoint = new CPoint();
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
		
		public function unionAllPolygons(polygonList:Vector.<CPolygon>):Vector.<CPolygon>{
			var i:int,j:int;
			for (i=1; i<polygonList.length; i++) {
				var p0:CPolygon = polygonList[i];
				for (var j:int=i+1; j<polygonList.length; j++) {
					var p1:CPolygon = polygonList[j];
					if ((p0.isClockwise() && p0.isClockwise()) ||(!p0.isClockwise() && !p0.isClockwise())) {
						var v:Vector.<CPolygon> =union(p0,p1);	//合并
						
						if (v != null && v.length > 0) {
							trace("delete");
							polygonList.splice(polygonList.indexOf(p0), 1);
							polygonList.splice(polygonList.indexOf(p1), 1);
							
							for each (var pv:CPolygon in v) {
								polygonList.push(pv);
							}
							
							i = 1;	//重新开始
							break;
						}
					}
				}
			}
		}
		
		
		/**
		 * 合并两个多边形(Weiler-Athenton算法)
		 * @param polygon
		 * @return 
		 * 			null--两个多边形不相交，合并前后两个多边形不变
		 * 			Polygon--一个新的多边形
		 */		
		public function union(polygon0:CPolygon,polygon1:CPolygon):Vector.<CPolygon> {
			//包围盒不相交
			if (polygon0.rectangle().intersection(polygon1.rectangle()) == false) {
				return null;
			}
			var i:int,j:int;
			//所有顶点和交点
			var cv0:Vector.<Node> = new Vector.<Node>();//主多边形
			var cv1:Vector.<Node> = new Vector.<Node>();//合并多边形
			//初始化
			var node:Node;
			for (i=0; i<polygon0.vertexNum; i++) {
				node = new Node(this.vertexList[i], false, true);
				if (i > 0) {
					cv0[i-1].next = node;
				}
				cv0.push(node);
			}
			for (i=0; i<polygon1.vertexNum; i++) {
				node = new Node(polygon1.vertexList[i], false, false);
				if (i > 0) {
					cv1[i-1].next = node;
				}
				cv1.push(node);
			}
			
			
			var insCnt:int = 0;		//交点数
			
			var findEnd:Boolean = false;
			var startNode0:Node = cv0[0];
			var startNode1:Node;
			var line0:CPoint;
			var line1:CPoint;
			var ins:CPoint;
			var hasIns:Boolean;
			var result:int;		//进出点判断结果
			while (startNode0 != null) {		//主多边形
				if (startNode0.next == null) {  //最后一个点，跟首点相连
					line0 = new CPoint(startNode0.v, cv0[0].v);
				} else {
					line0 = new CPoint(startNode0.v, startNode0.next.v);
				}
				
				startNode1 = cv1[0];
				hasIns = false;
				
				while (startNode1 != null) {		//合并多边形
					if (startNode1.next == null) {
						line1 = new CPoint(startNode1.v, cv1[0].v);
					} else {
						line1 = new CPoint(startNode1.v, startNode1.next.v);
					}
					ins = new CPoint();	//接受返回的交点
					//有交点
					if (line0.intersection(line1, ins) == LineClassification.SEGMENTS_INTERSECT) {
						//忽略交点已在顶点列表中的
						if (this.getNodeIndex(cv0, ins) == -1) {
							insCnt++;
							
							///////// 插入交点
							var node0:Node = new Node(ins, true, true);
							var node1:Node = new Node(ins, true, false);
							cv0.push(node0);
							cv1.push(node1);
							//双向引用
							node0.other = node1;
							node1.other = node0;
							//插入
							node0.next = startNode0.next;
							startNode0.next = node0;
							node1.next = startNode1.next;
							startNode1.next = node1;
							//出点
							if (line0.classifyPoint(line1.getPointB()) == PointClassification.RIGHT_SIDE) {
								node0.o = true;
								node1.o = true;
							}
							//TODO 线段重合
							//							trace("交点****", node0);
							
							hasIns = true;		//有交点
							
							//有交点，返回重新处理
							break;
						}
					}
					startNode1 = startNode1.next;
				}
				//如果没有交点继续处理下一个边，否则重新处理该点与插入的交点所形成的线段
				if (hasIns == false) {
					startNode0 = startNode0.next;
				}
			}
			
			if (insCnt > 0) {
				//保存合并后的多边形数组
				var rtV:Vector.<CPolygon> = new Vector.<CPolygon>();
				
				//1. 选取任一没有被跟踪过的交点为始点，将其输出到结果多边形顶点表中．
				for each (var testNode:Node in cv0) {
					//相交，而且还没有处理
					if (testNode.isIntersection == true && testNode.processed == false) {
						var rcNodes:Vector.<CPoint> = new Vector.<CPoint>();
						while (testNode != null) {
							testNode.processed = true;
							// 如果是交点
							if (testNode.isIntersection == true) {
								testNode.other.processed = true;
								if (testNode.out == false) {		//该交点为进点（跟踪裁剪多边形边界）
									if (testNode.isMain == true) {		//当前点在主多边形中
										testNode = testNode.other;		//切换到裁剪多边形中
									}
								} else {					//该交点为出点（跟踪主多边形边界）
									if (testNode.isMain == false) {		//当前点在裁剪多边形中
										testNode = testNode.other;		//切换到主多边形中
									}
								}
							}
							
							rcNodes.push(testNode.vertex);  		////// 如果是多边形顶点，将其输出到结果多边形顶点表中
							
							if (testNode.next == null) {	//末尾点返回到开始点
								if (testNode.isMain) {
									testNode = cv0[0];
								} else {
									testNode = cv1[0];
								}
							} else {
								testNode = testNode.next;
							}
							
							//与首点相同，生成一个多边形
							if (testNode.vertex.equals(rcNodes[0])){
								break;
							}
						}
						//提取
						rtV.push(new Polygon(rcNodes));
					}
				}
				return rtV;
				
			} else {
				return null;
			}
			
			return null;
		}
	}
}


import com.netease.core.geom.CPoint;
/**
 * 顶点(合并多边形用)
 * @author blc
 */
class Node {
	/** 坐标点 */
	public var vertex:CPoint;
	/** 是否是交点 */
	public var isIntersection:Boolean;
	/** 是否已处理过 */
	public var processed:Boolean = false;	
	/** 进点--false； 出点--true */
	public var out:Boolean = false;
	/** 交点的双向引用 */
	public var other:Node;	
	/** 点是否在主多边形中*/
	public var isMain:Boolean;
	
	/** 多边形的下一个点 */
	public var next:Node;
	
	public function Node(pt:CPoint, isInters:Boolean, main:Boolean){
		this.vertex = pt;
		this.isIntersection = isInters;
		this.isMain = main;
	}
}