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
		public function union(polygon:CPolygon):void{
			var i:int,j:int;
			var node:Node;
			
			var cv0:Vector.<Node> = new Vector.<Node>();
			var vertexNum0:int = vertexNum;
			
			var cv1:Vector.<Node> = new Vector.<Node>();
			var vertexNum1:int= polygon.vertexNum;
			
			for(i=0; i<vertexNum0; i++){
				node = new Node(vertexList[i],false,true);
				if(i>0){
					cv0[i-1].next = node;
				}
				cv0.push(node);
			}
			cv0[vertexNum0-1].next = cv0[0];
			
			for(i=0; i<vertexNum1; i++){
				node = new Node(polygon.vertexList[i],false,true);
				if(i>0){
					cv1[i-1].next = node;
				}
				cv1.push(node);
			}
			cv1[vertexNum1-1].next = cv1[0];
			
			
			/*var findEnd:Boolean = false;
			var startNode0:Node = cv0[0];
			var startNode1:Node;
			var line0:CLine;
			var line1:CLine;
			var ins:Vector2f;
			var hasIns:Boolean;
			var result:int;		//进出点判断结果
			for(i=0; i<vertexNum0; i++){
				startNode0 = cv0[i];
				line0 = new CLine(startNode0.p, startNode0.next.p);
				hasIns = false;
				for(j=0;j<vertexNum1; j++){
					startNode1 = cv1[j];
					line1 = new CLine(startNode1.p, startNode1.next.p);
					ins = new CPoint();
					//有交点
					if (line0.intersection(line1, ins) == CLine.SEGMENTS_INTERSECT) {
						//忽略交点已在顶点列表中的
						if (this.getNodeIndex(cv0, ins) == -1) {
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
				}
			}
		
			
			var rtV:Vector.<Polygon> = new Vector.<Polygon>();
			
			//1. 选取任一没有被跟踪过的交点为始点，将其输出到结果多边形顶点表中．
			for each (var testNode:Node in cv0) {
				if (testNode.i == true && testNode.p == false) {
					//					trace("测试点0", testNode);
					var rcNodes:Vector.<Vector2f> = new Vector.<Vector2f>();
					while (testNode != null) {
						//						trace("测试点1", testNode);
						
						testNode.p = true;
						
						// 如果是交点
						if (testNode.i == true) {
							testNode.other.p = true;
							
							if (testNode.o == false) {		//该交点为进点（跟踪裁剪多边形边界）
								if (testNode.isMain == true) {		//当前点在主多边形中
									testNode = testNode.other;		//切换到裁剪多边形中
								}
							} else {					//该交点为出点（跟踪主多边形边界）
								if (testNode.isMain == false) {		//当前点在裁剪多边形中
									testNode = testNode.other;		//切换到主多边形中
								}
							}
						}
						
						rcNodes.push(testNode.v);  		////// 如果是多边形顶点，将其输出到结果多边形顶点表中
						
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
						if (testNode.v.equals(rcNodes[0])) break;
					}
					//提取
					rtV.push(new Polygon(rcNodes.length, rcNodes));
				}
			}
			
			trace("rtV", rtV);*/
			
			//return rtV;
		
		}
		
	}
}
import com.netease.core.geom.CPoint;

/**
 * 顶点(合并多边形用)
 * @author blc
 */
class Node {
	//	/** 原数组中的索引 */
	//	public var index:int;
	/** 坐标点 */
	public var p:CPoint;		//点
	/** 是否是交点 */
	public var i:Boolean;
	/** 是否已处理过 */
	public var processed:Boolean = false;	
	/** 进点--false； 出点--true */
	public var o:Boolean = false;
	/** 交点的双向引用 */
	public var other:Node;	
	/** 点是否在主多边形中*/
	public var isMain:Boolean;
	
	/** 多边形的下一个点 */
	public var next:Node;
	
	public function Node(pt:CPoint, isInters:Boolean, main:Boolean) {
		this.p = pt;
		this.i = isInters;
		this.isMain = main;
	}
}
