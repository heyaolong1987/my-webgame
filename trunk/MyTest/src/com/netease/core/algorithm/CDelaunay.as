package com.netease.core.algorithm{
	import com.netease.core.geom.CCircle;
	import com.netease.core.geom.CLine;
	import com.netease.core.geom.CPoint;
	import com.netease.core.geom.CPolygon;
	import com.netease.core.geom.CRectangle;
	import com.netease.core.geom.CTriangle;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import mx.messaging.errors.NoChannelAvailableError;
	
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
				
				vertexLen = poly.vertexList.length;
				//放入所有的顶点
				for(j=0; j<vertexLen; j++){
					if(isInVertexList(poly.vertexList[j],vertexList)==-1){
						vertexList.push(poly.vertexList[j]);
					}
				}
				
				//放入所有边
				p1= poly.vertexList[0];
				for (j=1; j<vertexLen; j++) {
					p2 = poly.vertexList[j];
					edge = new CLine(p1.x,p1.y, p2.x, p2.y);
					edgeList.push(edge);
					p1 = p2;
				}
				p2 = poly.vertexList[0];
				edge = new CLine(p1.x,p1.y, p2.x,p2.y);
				edgeList.push(edge);
			}
			var edgeListLen:int = edgeList.length;
			for(i=0; i<edgeListLen; i++){
				noVisitEdgeList[i] = true;
			}
			var initEdge:CLine;
			initEdge = getInitOutEdge(edgeList,noVisitEdgeList,vertexList);
			var timeArr:Array = [0,0,0,0,0,0,0,0,0,0];
			while(initEdge){
				timeArr[0] -= getTimer();
				edgeStack.push(initEdge);
				do{
					edge = edgeStack.pop();
					timeArr[1] -= getTimer();
					vertex = findDT(vertexList,edgeList,edge);
					timeArr[1] += getTimer();
					if(vertex == null){
						continue;
					}
					var line13:CLine = new CLine(edge.x1, edge.y1, vertex.x, vertex.y);
					var line32:CLine = new CLine(vertex.x, vertex.y, edge.x2, edge.y2);
					
					var triangle:CTriangle = new CTriangle(edge.x1,edge.y1,edge.x2, edge.y2,vertex.x, vertex.y);
					triangleList.push(triangle);
					timeArr[2] -= getTimer();
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
						setEdgeVisited(edgeList,noVisitEdgeList,line13);
						
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
						setEdgeVisited(edgeList,noVisitEdgeList,line32);
					}
					timeArr[2] += getTimer();
				}
				while(edgeStack.length > 0);
				timeArr[3] -= getTimer();
				initEdge = getInitOutEdge(edgeList,noVisitEdgeList,vertexList);
				timeArr[3] += getTimer();
				timeArr[0] += getTimer();
				trace(timeArr[0],timeArr[1],timeArr[2],timeArr[3],timeArr[4],timeArr[5]);
				
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
		private static function setEdgeVisited(edgeList:Vector.<CLine>,noVisitList:Dictionary,line:CLine):void{
			var line2:CLine;
			var i:int;
			var len:int = edgeList.length;
			for(i=0; i<len; i++){
				line2 = edgeList[i];
				if(line.equals(line2)){
					noVisitList[i] = null;
					delete noVisitList[i];
				}
			}
		}
		private static function isInVertexList(point:CPoint,vertexList:Vector.<CPoint>):int{
			var point2:CPoint;
			var i:int;
			var len:int = vertexList.length;
			for(i=0; i<len; i++){
				point2 = vertexList[i];
				if(point.x == point2.x && point.y == point2.y){
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
				line23.x1 = line12.x2;
				line23.y1 = line12.y2;
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
					noVisitEdgeList[k] = null;
					delete noVisitEdgeList[k];
					return line12;
				}
			}
			return null;
		}
		
		private static function findDT(vertexList:Vector.<CPoint>, edgeList:Vector.<CLine>, edge:CLine):CPoint{
			var timeArr:Array = [0,0];
			var allVisibleVertex:Vector.<CPoint> = new Vector.<CPoint>();
			
			var line12:CLine = edge;
			var line13:CLine = new CLine();
			var line23:CLine = new CLine();
			
			line13.x1 = edge.x1;
			line13.y1 = edge.y1;
			line23.x1 = edge.x2;
			line23.y1 = edge.y2;
			timeArr[0] -= getTimer();
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
			timeArr[0] += getTimer();
			timeArr[1] -= getTimer();
			var p3:CPoint = allVisibleVertex[0];
			var isMaxAngle:Boolean;
			do{
				isMaxAngle = true;
				var circle:CCircle = new CCircle(edge.x1,edge.y1,edge.x2,edge.y2,p3.x,p3.y);
				var bounds:CRectangle = circleBounds(circle);
				var angle132:Number = Math.abs(CTriangle.lineAngle(edge.x1, edge.y1, p3.x, p3.y, edge.x2, edge.y2));
				for each(var p4:CPoint in allVisibleVertex){
					//p3，p4是同一个点
					if((p4.x == edge.x1 && p4.y == edge.y1)
						|| (p4.x == edge.x2 && p4.y == edge.y2)
						|| (p4.x == p3.x && p4.y == p3.y)){
						continue;
					}
					//不在包围盒内
					if(bounds.contains(p4.x,p4.y) == false){
						continue;
					}
					//在包围盒内，且角度不是最大的
					var angle142:Number = Math.abs(CTriangle.lineAngle(edge.x1, edge.y1, p4.x, p4.y, edge.x2, edge.y2));
					if(angle142 > angle132){
						p3 = p4;
						isMaxAngle = false;
						break;
					}
					
				}
			}
			while(isMaxAngle==false);
			timeArr[1] += getTimer();
			trace(timeArr[0],timeArr[1]);
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
		
		public static function unionAllPolygons(polygonList:Vector.<CPolygon>):Vector.<CPolygon>{
			var i:int,j:int;
			for (i=0; i<polygonList.length; i++) {
				var p0:CPolygon = polygonList[i];
				for (var j:int=i+1; j<polygonList.length; j++) {
					var p1:CPolygon = polygonList[j];
					if(p0.isClockwise() && p1.isClockwise()){
						var v:Vector.<CPolygon> = union(p0,p1);	//合并
						if (v != null && v.length > 0) {
							trace("delete");
							polygonList.splice(polygonList.indexOf(p0), 1);
							polygonList.splice(polygonList.indexOf(p1), 1);
							
							for each (var pv:CPolygon in v) {
								polygonList.push(pv);
							}
							i--;	//重新开始
							break;
						}
					}
				}
			}
			return polygonList;
		}
		
		
		/**
		 * 合并两个多边形(Weiler-Athenton算法)
		 * @param polygon
		 * @return 
		 * 			null--两个多边形不相交，合并前后两个多边形不变
		 * 			Polygon--一个新的多边形
		 */		
		public static function union(polygon0:CPolygon,polygon1:CPolygon):Vector.<CPolygon> {
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
				node = new Node(polygon0.vertexList[i], false, true);
				if (i > 0) {
					cv0[i-1].next = node;
				}
				cv0.push(node);
			}
			cv0[polygon0.vertexNum-1].next = cv0[0];
			for (i=0; i<polygon1.vertexNum; i++) {
				node = new Node(polygon1.vertexList[i], false, false);
				if (i > 0) {
					cv1[i-1].next = node;
				}
				cv1.push(node);
			}
			cv1[polygon1.vertexNum-1].next = cv1[0];
			
			
			var insCnt:int = 0;		//交点数
			var findEnd:Boolean = false;
			var startNode0:Node;
			var startNode1:Node;
			var endNode0:Node;
			var endNode1:Node;
			var line0:CLine;
			var line1:CLine;
			var ins:CPoint;
			var hasIns:Boolean;
			var result:int;		//进出点判断结果
			var intersectionType:int;
			
			var preNode:Node; 
			var node:Node;
			
			for(i=0; i<polygon0.vertexNum; i++){
				startNode0 = cv0[i];
				startNode1 = cv0[(i+1)%polygon0.vertexNum];
				line0 = new CLine(startNode0.vertex.x,startNode0.vertex.y,startNode1.vertex.x,startNode1.vertex.y);
				for(j=0; j<polygon1.vertexNum; j++){
					endNode0 = cv1[j];
					endNode1 = cv1[(j+1)%polygon1.vertexNum];
					line1 = new CLine(endNode0.vertex.x,endNode0.vertex.y,endNode1.vertex.x,endNode1.vertex.y);
					ins = new CPoint();	//接受返回的交点
					intersectionType = line0.intersection(line1, ins);
					if(intersectionType != CLine.SEGMENTS_INTERSECT){
						continue;
					}
					//忽略交点已在顶点列表中的
					insCnt++;
						
					///////// 插入交点
					var node0:Node = new Node(ins, true, true);
					var node1:Node = new Node(ins, true, false);
					cv0.push(node0);
					cv1.push(node1);
					//双向引用
					node0.other = node1;
					node1.other = node0;
					
					preNode = startNode0;
					node = preNode.next;
					
					while(node!=startNode1){
						if((ins.x-startNode0.vertex.x)*(ins.x-startNode0.vertex.x)+(ins.y-startNode0.vertex.y)*(ins.y-startNode0.vertex.y) <= 
							(node.vertex.x-startNode0.vertex.x)*(node.vertex.x-startNode0.vertex.x)+(node.vertex.y-startNode0.vertex.y)*(node.vertex.y-startNode0.vertex.y)){
							break;
						}
						preNode = node;
						node = node.next;
					}
					preNode.next = node0;
					node0.next = node;
					
					
					preNode = endNode0;
					node = preNode.next;
					while(node!=endNode1){
						if((ins.x-endNode0.vertex.x)*(ins.x-endNode0.vertex.x)+(ins.y-endNode0.vertex.y)*(ins.y-endNode0.vertex.y) <= 
							(node.vertex.x-endNode0.vertex.x)*(node.vertex.x-endNode0.vertex.x)+(node.vertex.y-endNode0.vertex.y)*(node.vertex.y-endNode0.vertex.y)){
							break;
						}
						preNode = node;
						node = node.next;
					}
					preNode.next = node1;
					node1.next = node;
					
					
					//出点
					if (line0.checkPointPos(new CPoint(line1.x2,line1.y2)) == CLine.POINT_ON_LEFT) {
						node0.out = true;
						node1.out = true;
					}
				}
			}
			
		
			if (insCnt == 0) {
				return null;
			}
			//保存合并后的多边形数组
			var rtV:Vector.<CPolygon> = new Vector.<CPolygon>();
			var testNode:Node
			//1. 选取任一没有被跟踪过的交点为始点，将其输出到结果多边形顶点表中．
			for(i=0; i<cv0.length; i++){
				testNode = cv0[i];
				//相交，而且还没有处理
				if (testNode.isIntersection == true && testNode.processed == false) {
					var rcNodes:Vector.<CPoint> = new Vector.<CPoint>();
					while (testNode != null) {
						testNode.processed = true;
						// 如果是交点
						if (testNode.isIntersection == true) {
							testNode.other.processed = true;
							if ((testNode.out == true &&testNode.isMain == true)
							||(testNode.out == false &&testNode.isMain == false)){
								testNode = testNode.other;		//切换到另一个多边形
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
						if (testNode.vertex.x == rcNodes[0].x && testNode.vertex.y == rcNodes[0].y){
							break;
						}
					}
					//提取
					rtV.push(new CPolygon(rcNodes));
				}
			}
			return rtV;
		}
		/**
		 * 取得节点的索引(合并多边形用)
		 * @param cv
		 * @param node
		 * @return 
		 */		
		private static function getNodeIndex(cv:Vector.<Node>, node:CPoint):int {
			var len:int = cv.length;
			for (var i:int=0; i<len; i++) {
				if (cv[i].vertex.x == node.x && cv[i].vertex.y == node.y) {
					return i;
				}
			}
			return -1;
		}
		
		
		/**
		 * 合并两个多边形(Weiler-Athenton算法)
		 * @param polygon
		 * @return 
		 * 			null--两个多边形不相交，合并前后两个多边形不变
		 * 			Polygon--一个新的多边形
		 */		
		public static function union1(polygon0:CPolygon,polygon1:CPolygon):Vector.<CPolygon> {
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
				node = new Node(polygon0.vertexList[i], false, true);
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
			var line0:CLine;
			var line1:CLine;
			var ins:CPoint;
			var hasIns:Boolean;
			var result:int;		//进出点判断结果
			var intersectionType:int;
			while (startNode0 != null) {		//主多边形
				if (startNode0.next == null) {  //最后一个点，跟首点相连
					line0 = new CLine(startNode0.vertex.x,startNode0.vertex.y, cv0[0].vertex.x, cv0[0].vertex.y);
				} else {
					line0 = new CLine(startNode0.vertex.x,startNode0.vertex.y, startNode0.next.vertex.x,startNode0.next.vertex.y);
				}
				
				startNode1 = cv1[0];
				hasIns = false;
				
				while (startNode1 != null) {		//合并多边形
					if (startNode1.next == null) {
						line1 = new CLine(startNode1.vertex.x,startNode1.vertex.y, cv1[0].vertex.x, cv1[0].vertex.y);
					} else {
						line1 = new CLine(startNode1.vertex.x,startNode1.vertex.y, startNode1.next.vertex.x,startNode1.next.vertex.y);
					}
					ins = new CPoint();	//接受返回的交点
					intersectionType = line0.intersection(line1, ins)
					if(intersectionType != CLine.SEGMENTS_INTERSECT){
						startNode1 = startNode1.next;
						continue;
					}
					//忽略交点已在顶点列表中的
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
					if (line0.checkPointPos(new CPoint(line1.x2,line1.y2)) == CLine.POINT_ON_RIGHT) {
						node0.out = true;
						node1.out = true;
					}
					//todo这里似乎可以优化，不用重头再开始找
					//有交点，返回重新处理
					hasIns = true;
					break;
				}
				//如果没有交点继续处理下一个边，否则重新处理该点与插入的交点所形成的线段
				if (hasIns == false) {
					startNode0 = startNode0.next;
				}
			}
			
			if (insCnt == 0) {
				return null;
			}
			//保存合并后的多边形数组
			var rtV:Vector.<CPolygon> = new Vector.<CPolygon>();
			var testNode:Node
			//1. 选取任一没有被跟踪过的交点为始点，将其输出到结果多边形顶点表中．
			for(i=0; i<cv0.length; i++){
				testNode = cv0[i];
				//相交，而且还没有处理
				if (testNode.isIntersection == true && testNode.processed == false) {
					var rcNodes:Vector.<CPoint> = new Vector.<CPoint>();
					while (testNode != null) {
						testNode.processed = true;
						// 如果是交点
						if (testNode.isIntersection == true) {
							testNode.other.processed = true;
							if ((testNode.out == true &&testNode.isMain == true)
								||(testNode.out == false &&testNode.isMain == false)){
								testNode = testNode.other;		//切换到另一个多边形
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
						if (testNode.vertex == testNode.vertex){
							break;
						}
					}
					for(j=rcNodes.length-1; j>=1; j--){
						if(rcNodes[j].x == rcNodes[j-1].x && rcNodes[j].y == rcNodes[j-1].y){
							rcNodes.splice(j,1);
						}
					}
					//提取
					rtV.push(new CPolygon(rcNodes));
				}
			}
			return rtV;
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