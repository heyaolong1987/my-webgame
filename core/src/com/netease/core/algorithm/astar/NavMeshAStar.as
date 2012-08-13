package com.netease.core.algorithm.astar{
	import com.netease.core.geom.CLine;
	import com.netease.core.geom.CPoint;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	
	/**
	 * @author heyaolong
	 * 
	 * 2012-7-9
	 */ 
	public class NavMeshAStar{
		private static var dirArr:Array = [[-1, -1],[0, -1],[1, -1],[1, 0],[1, 1],[0, 1],[-1, 1],[-1, 0]];
		private static const NODE_OPEN:int=0;
		private static const NODE_CLOSE:int=1;
		private static var sessionId:int=0;
		public function NavMeshAStar()
		{
		}
		/**
		 *A*寻路 
		 * @param arcs 地图信息
		 * @param sx 
		 * @param sy
		 * @param tx
		 * @param ty
		 * @return 
		 * 
		 */
		public static function find(nodeList:Vector.<NavMeshAstarNode>, sx:int, sy:int, ex:int, ey:int):Array{
			sessionId++;
			var startPoint:CPoint = new CPoint(sx,sy);
			var endPoint:CPoint = new CPoint(ex,ey);
			var startNode:NavMeshAstarNode = findClosestNode(nodeList,startPoint);
			var endNode:NavMeshAstarNode = findClosestNode(nodeList,endPoint);
			if(startNode == null || endNode == null){
				return null;
			}
			if(startNode == endNode){
				return [[[sx,sy],[ex,ey]],[[sx,sy],[ex,ey]]];
			}
			var minNode:NavMeshAstarNode;
			var dir:int;
			var openList:BinaryHeap = new BinaryHeap();
			var infoList:Array = [];
			var node:NavMeshAstarNode;
			var currentNode:NavMeshAstarNode;
			var temp:BinaryHeapNode;
			var nextNode:NavMeshAstarNode;
			var dx:int,dy:int;
			var currentX:int,currentY:int;
			var nextX:int,nextY:int;
			var g:int;
			var i:int;
			
			node = startNode;
			node.sessionId = sessionId;
			node.g = 0;
			node.isOpen = true;
			node.h = Math.sqrt((startNode.centerX-endNode.centerX)*(startNode.centerX-endNode.centerX) + (startNode.centerY-endNode.centerY)*(startNode.centerY-endNode.centerY));
			node.f = node.g + node.h;
			node.preNode = null;
			openList.insert(new BinaryHeapNode(node.f,node));
			infoList[node.id] = [NODE_OPEN,new BinaryHeapNode(node.f,node)];
			while(true){
				if(openList.length == 0){
					return null;
				}
				temp = openList.removeMin();
				currentNode = NavMeshAstarNode(temp.data);
				//已经寻到目标点了，返回路径
				if (currentNode == endNode){
					break;
				}
				infoList[currentNode.id] = [NODE_CLOSE,temp];
				var nextId:int;
				for(i = 0; i<3; i++){
					nextId = currentNode.linkArr[i];
					if(nextId<0){
						continue;
					}
					if(infoList[nextId]&&infoList[nextId][0] == NODE_CLOSE){
						continue;
					}
					nextNode = nodeList[nextId];
					g = currentNode.g + Math.sqrt((nextNode.centerX-currentNode.centerX)*(nextNode.centerX-currentNode.centerX)+(nextNode.centerY-currentNode.centerY)*(nextNode.centerY-currentNode.centerY));
					if(infoList[nextId]){
						temp = infoList[nextId][1];
						nextNode = NavMeshAstarNode(temp.data);
						if (g < nextNode.g){
							nextNode.g = g;
							nextNode.f = nextNode.g + nextNode.h;
							nextNode.preNode = currentNode;
							temp.value = nextNode.f;
							openList.up(temp.index);
							nextNode.setArrivalEdgeIndex(currentNode.id);
						}
					}
					else{
						nextNode.g = g;
						nextNode.h = Math.sqrt((ex-nextNode.centerX)*(ex-nextNode.centerX)+(ey-nextNode.centerY)*(ey-nextNode.centerY));
						nextNode.f = nextNode.g + nextNode.h;
						nextNode.preNode = currentNode;
						temp = new BinaryHeapNode(nextNode.f,nextNode);
						infoList[nextId] = [NODE_OPEN,temp];
						openList.insert(temp);
						nextNode.setArrivalEdgeIndex(currentNode.id);
					}
				}
			}
			var route:Array = new Array();
			var nodeRoute:Vector.<NavMeshAstarNode> = new Vector.<NavMeshAstarNode>();
			node = currentNode;
			while (node){
				nodeRoute.unshift(node);
				route.unshift([node.centerX, node.centerY]);
				node = node.preNode;
				
			}
			route.push([ex,ey]);
			route.unshift([sx,sy]);
			if(route!=null && route.length>0){
				route = [route,smoothPath(nodeList,nodeRoute,route)];
			}
			return route;
		}
		/**
		 *采用LOS视线算法平滑路径 
		 * @param nodeList
		 * @param nodeRoute
		 * @param route
		 * @return 
		 * 
		 */
		private static function smoothPath(nodeList:Vector.<NavMeshAstarNode>,nodeRoute:Vector.<NavMeshAstarNode>,route:Array):Array{
			var pathArr:Array = new Array();
			var endX:int,endY:int,currentX:int,currentY:int;
			var currentNode:NavMeshAstarNode;
			var node:NavMeshAstarNode,lastNode1:NavMeshAstarNode,lastNode2:NavMeshAstarNode;
			var startIndex:int;	
			var inSideEdge:CLine;	
			var lastX1:int,lastY1:int,lastX2:int,lastY2:int;
			var lastLine1:CLine,lastLine2:CLine;
			var testX1:int,testY1,testX2,testY2;
			var i:int;
			var len:int;
			
			endX = route[0][0];
			endY = route[0][1];
			currentNode = nodeRoute[nodeRoute.length-1];
			currentX = route[route.length-1][0];
			currentY = route[route.length-1][1];
			pathArr.unshift(route[route.length-1]);
			while(currentX!=endX || currentY!=endY) {
				lastNode1 = currentNode;
				lastNode2 = currentNode;
				startIndex = nodeRoute.indexOf(currentNode);	//开始路点所在的网格索引
				inSideEdge = currentNode.edgeArr[currentNode.arrivalEdgeIndex];	//路径线在网格中的穿出边
				lastX1 = inSideEdge.x1;
				lastY1 = inSideEdge.y1;
				lastX2 = inSideEdge.x2;
				lastY2 = inSideEdge.y2;
				lastLine1 = new CLine(currentX,currentY,lastX1,lastY1);
				lastLine2 = new CLine(currentX,currentY,lastX2,lastY2);
				len = nodeRoute.length;
				for (i=startIndex-1; i>=0; i--) {
					node = nodeRoute[i];
					inSideEdge = node.edgeArr[node.arrivalEdgeIndex];
					if (i == 0) {
						testX1 = testX2 = endX;
						testY1 = testY2 = endY;
					} else {
						testX1 = inSideEdge.x1;
						testY1 = inSideEdge.y1;
						testX2 = inSideEdge.x2;
						testY2 = inSideEdge.y2;
					}
					if (lastX1!=testX1 || lastY1!=testY1) {
						if (lastLine2.checkPointPos(new CPoint(testX1,testY1)) == CLine.POINT_ON_RIGHT) {
							currentX = lastX2;
							currentY = lastY2;
							currentNode = lastNode2;
							break;
						} else {
							if (lastLine1.checkPointPos(new CPoint(testX1,testY1)) != CLine.POINT_ON_LEFT) {
								lastX1 = testX1;
								lastY1 = testY1;
								lastNode1 = node;
								lastLine1.x2 = lastX1;
								lastLine1.y2 = lastY1;
							}
						}
					}
					
					if (lastX2!=testX2 || lastY2!=testY2){
						if (lastLine1.checkPointPos(new CPoint(testX2,testY2)) == CLine.POINT_ON_LEFT) {
							currentX = lastX1;
							currentY = lastY1;
							currentNode = lastNode1;
							break;
						} else {
							if (lastLine2.checkPointPos(new CPoint(testX2,testY2)) != CLine.POINT_ON_RIGHT) {
								lastX2 = testX2;
								lastY2 = testY2;
								lastNode2 = node;
								lastLine2.x2 = lastX2;
								lastLine2.y2 = lastY2;
							}
						}
					}
				}
				if(i<0){
					currentX = endX;
					currentY = endY;
					currentNode = nodeRoute[0];
				}
				pathArr.unshift([currentX,currentY]);
			}
			return pathArr;
		}
		
		public static function findClosestNode(nodeList:Vector.<NavMeshAstarNode>, p:CPoint):NavMeshAstarNode{
			for each(var node:NavMeshAstarNode in nodeList){
				if(node.isPointIn(p)){
					return node;
				}
			}
			return null;
		}
		/**
		 * floyd路径平滑
		 * @param path
		 * 
		 */
		public static function floydSmoothPath(arcs:Array,route:Array):Array{
			if (route == null || route.length < 2) {
				return route;
			}
			var path:Array = [];
			for(var k:int=0;k<route.length;k++){
				path.push(route[k]);
			}
			var len:int;
			var i:int, j:int;
			var dx1:int,dx2:int,dy1:int,dy2:int;
			len = path.length;
			dx1 = path[len-2][0] - path[len-1][0];
			dy1 = path[len-2][1] - path[len-1][1];
			for(i=len-3; i>=0; i--){
				dx2 = path[i][0]-path[i+1][0];
				dy2 = path[i][1]-path[i+1][1];
				if(dx1*dy2 == dx2*dy1){
					path.splice(i+1,1);
				}
				else{
					dx1 = dx2;
					dy1 = dy2;
				}
			}
			
			len = path.length;
			for(i=len-1; i>1;) {
				for(j=0; j<=i-2; j++){
					if(isLineWalkAble(arcs,path[i][0], path[i][1], path[j][0], path[j][1])){
						path.splice(j+1,i-j-1);
						break;
					}
				}
				i = j;
			}
			return path;
		}
		public static function BresenhamLine(sx:int,sy:int,tx:int,ty:int):Array{
			var dx:int,dy:int;
			var stepX:int,stepY:int;
			var inc1:int,inc2:int;
			var d:int,iTag:int;
			var x:int,y:int;
			var temp:int;
			var arr:Array = [];
			arr.push([sx,sy]);
			if(sx == tx && sy == ty){
				return arr;
			}
			iTag = 0;
			dx = tx>sx?tx-sx:sx-tx;
			dy = ty>sy?ty-sy:sy-ty;
			if(dx < dy){
				iTag = 1;
				temp = sx;
				sx = sy;
				sy = temp;
				
				temp = tx;
				tx = ty;
				ty = temp;
				
				temp = dx;
				dx = dy;
				dy = temp;
			}
			
			stepX = tx-sx>0?1:-1;
			stepY = ty-sy>0?1:-1;
			x = sx;
			y = sy;
			inc1 = 2*dy;
			inc2 = 2*dx;
			d = - dx;
			while(x != tx){
				x += stepX;
				d += inc1/2;
				if(d >= 0){
					y += stepY;
					d -= inc2;
				}
				if(iTag){
					arr.push([y,x]);
				}
				else{
					arr.push([x,y]);
				}
				
				
				d += inc1/2;
				if(d >= 0){
					y += stepY;
					d -= inc2;
				}
				if(iTag){
					arr.push([y,x]);
				}
				else{
					arr.push([x,y]);
				}
				
				
			}
			return arr;
		}
		public static function isLineWalkAble(arcs:Array,sx:int,sy:int,tx:int,ty:int):Boolean{
			if(sx == tx && sy == ty){
				return null;
			}
			var arr:Array = [];
			var step:int;
			var maxStep:int;
			var i:int;
			var k:Number;
			var x:Number;
			var y:Number;
			var add:int;
			if(Math.abs(tx - sx) > Math.abs(ty - sy)){
				step = tx>sx?1:-1;
				maxStep = tx-sx;
				k = (ty-sy)/(tx-sx);
				if(step>0){
					add = 0;
				}		
				else{
					add = step;
				}
				if(ty>sy){
					for(i=0; i!=maxStep; i+=step){
						if(arcs[sx+i+add][Math.floor(sy+k*i+0.5)] != 0){
							return false;
						}
						if(arcs[sx+i+add][Math.ceil(sy+k*(i+step)-0.5)] != 0){
							return false;
						}
					}
				}
				else if(ty<sy){
					for(i=0; i!=maxStep; i+=step){
						if(arcs[sx+i+add][Math.ceil(sy+k*i-0.5)] != 0){
							return false;
						}
						if(arcs[sx+i+add][Math.floor(sy+k*(i+step)+0.5)] != 0){
							return false;
						}
					}
				}
				else{
					for(i=0; i!=maxStep; i+=step){
						if(arcs[sx+i+add][sy] != 0){
							return false;
						}
					}
				}
			}
			else{
				step = ty>sy?1:-1;
				maxStep = ty-sy;
				k = (tx-sx)/(ty-sy);
				if(step>0){
					add = 0;
				}		
				else{
					add = step;
				}
				if(tx>sx){
					for(i=0; i!=maxStep; i+=step){
						if(arcs[Math.floor(sx+k*i+0.5)][sy+i+add] != 0){
							return false;
						}
						if(arcs[Math.ceil(sx+k*(i+step)-0.5)][sy+i+add] != 0){
							return false;
						}
					}
				}
				else if(tx<sx){
					for(i=0; i!=maxStep; i+=step){
						if(arcs[Math.ceil(sx+k*i-0.5)][sy+i+add] != 0){
							return false;
						}
						if(arcs[Math.floor(sx+k*(i+step)+0.5)][sy+i+add] != 0){
							return false;
						}
					}
				}
				else{
					for(i=0; i!=maxStep; i+=step){
						if(arcs[sx][sy+i+add] != 0){
							return false;
						}
					}
				}
			}
			return true;
		}

	}
}