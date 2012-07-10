package com.netease.core.algorithm.astar{
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
		public static function find(nodeList:Vector.<NavmeshAstarNode>, sx:int, sy:int, ex:int, ey:int):Array{
			sessionId++;
			var startPoint:CPoint = new CPoint(sx,sy);
			var endPoint:CPoint = new CPoint(ex,ey);
			var startNode:NavmeshAstarNode = findClosestNode(nodeList,startPoint);
			var endNode:NavmeshAstarNode = findClosestNode(nodeList,endPoint);
			if(startNode == null || endNode == null){
				return null;
			}
			if(startNode == endNode){
				return [[sx,sy],[ex,ey]];
			}
			var minNode:NavmeshAstarNode;
			var dir:int;
			var openList:BinaryHeap = new BinaryHeap();
			var infoList:Array = [];
			var node:NavmeshAstarNode;
			var currentNode:NavmeshAstarNode;
			var temp:BinaryHeapNode;
			var nextNode:NavmeshAstarNode;
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
				currentNode = NavmeshAstarNode(temp.data);
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
						nextNode = NavmeshAstarNode(temp.data);
						if (g < nextNode.g){
							nextNode.g = g;
							nextNode.f = nextNode.g + nextNode.h;
							nextNode.preNode = currentNode;
							temp.value = nextNode.f;
							openList.up(temp.index);
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
					}
				}
			}
			var route:Array = new Array();
			var routeNode:NavmeshAstarNode = currentNode;
			while (routeNode){
				route.unshift([routeNode.centerX, routeNode.centerY]);
				routeNode = routeNode.preNode;
			}
			route.push([ex,ey]);
			route.unshift([sx,sy]);
			//var path:Array = floydSmoothPath(arcs,route);
			return route;
		}
		public static function findClosestNode(nodeList:Vector.<NavmeshAstarNode>, p:CPoint):NavmeshAstarNode{
			for each(var node:NavmeshAstarNode in nodeList){
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