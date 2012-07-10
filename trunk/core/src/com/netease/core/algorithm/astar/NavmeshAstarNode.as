package com.netease.core.algorithm.astar{
	import com.netease.core.geom.CLine;
	import com.netease.core.geom.CPoint;
	import com.netease.core.geom.CTriangle;
	
	import flash.display.LineScaleMode;
	import flash.geom.Point;

	/**
	 * @author heyaolong
	 * 
	 * 2012-7-9
	 */ 
	public class NavmeshAstarNode extends CTriangle{
		public var g:int;
		public var h:int;
		public var f:int;
		public var preNode:NavmeshAstarNode;
		public var isOpen:Boolean;
		public var sessionId:int;
		public var arrivalIndex:int;
		public var midPointArr:Vector.<CPoint>;
		public var distanceArr:Vector.<Number>;
		public var linkArr:Vector.<int>;
		public var centerX:Number;
		public var centerY:Number;
		public var id:int;
		public var edgeArr:Vector.<CLine>;
		
		public function NavmeshAstarNode(x1:int,y1:int,x2:int,y2:int,x3:int,y3:int)
		{
			super(x1,y1,x2,y2,x3,y3);
			linkArr = new Vector.<int>();
			linkArr.push(-1);
			linkArr.push(-1);
			linkArr.push(-1);
			centerX = (x1+x2+x3)/3;
			centerY = (y1+y2+y3)/3;
			midPointArr = new Vector.<CPoint>();
			distanceArr = new Vector.<Number>();
			midPointArr[0] = new CPoint((x1+x2)/2,(y1+y2)/2);
			midPointArr[1] = new CPoint((x2+x3)/2,(y2+y3)/2);
			midPointArr[2] = new CPoint((x3+x1)/2,(y3+y1)/2);
			
			distanceArr[0] = CPoint.distance(midPointArr[0],midPointArr[1]);
			distanceArr[1] = CPoint.distance(midPointArr[1],midPointArr[2]);
			distanceArr[2] = CPoint.distance(midPointArr[2],midPointArr[0]);
			
			edgeArr = new Vector.<CLine>();
			edgeArr[0] = new CLine(x1,y1,x2,y2);
			edgeArr[1] = new CLine(x2,y2,x3,y3);
			edgeArr[2] = new CLine(x3,y3,x1,y1);
			
		}
		
		/**
		 * 测试给定点是否在三角型中
		 * @param TestPoint
		 * @return 
		 */		
		public function isPointIn(p:CPoint):Boolean {
			// 点在所有边的右面
			var count:int = 0;
			var i:int;
			for (i=0; i < 3; i++) {
				if (edgeArr[i].checkPointPos(p) != CLine.POINT_ON_LEFT) {
					count++;
				}
			}
			return count == 3;
		}
	}
}