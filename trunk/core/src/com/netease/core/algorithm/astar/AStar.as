package com.netease.core.algorithm.astar{
	import com.netease.core.algorithm.binaryheap.BinaryHeap;
	import com.netease.core.algorithm.binaryheap.BinaryHeapNode;
	
	import flash.utils.flash_proxy;
	import flash.utils.getTimer;
	
	/**
	 * @author heyaolong
	 * A*寻路
	 * 2012-6-7
	 */ 
	public class AStar{
		private static var dirArr:Array = [[-1, -1],[0, -1],[1, -1],[1, 0],[1, 1],[0, 1],[-1, 1],[-1, 0]];
		private static const NODE_OPEN:int=0;
		private static const NODE_CLOSE:int=1
		public function AStar()
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
		public static function find(arcs:Array, sx:int, sy:int, tx:int, ty:int):Array{
			var timeArr:Array = new Array(20);
			for(var i:int=0;i<20;i++){
				timeArr[i] = 0;
			}
			//起点等于终点
			if (sx == tx && sy == ty){
				return null;
			}
			//起点不可过或终点不可过
			if (arcs[sx][sy] != 0 || arcs[tx][ty] != 0){
				return null;
			}
			
			var minNode:AstarNode;
			var dir:int;
			var openList:BinaryHeap = new BinaryHeap();
			var infoList:Array = [];
			var node:AstarNode;
			var currentNode:AstarNode;
			var temp:BinaryHeapNode;
			var nextNode:AstarNode;
			var dx:int,dy:int;
			var currentX:int,currentY:int;
			var nextX:int,nextY:int;
			var g:int;
			var count:int = 0;
			
			node = new AstarNode();
			node.x = sx;
			node.y = sy;
			node.g = 0;
			dx= tx > sx ? tx - sx  : sx - tx;
			dy= ty > sy ? ty - sy  : sy - ty;
			node.h = dx>dy?(dy*14+(dx-dy)*10):(dx*14+(dy-dx)*10);
			node.f = node.g + node.h;
			node.preNode = null;
			openList.insert(new BinaryHeapNode(node.f,node));
			infoList[sx] = [];
			infoList[sx][sy] = [NODE_OPEN,new BinaryHeapNode(node.f,node),count];
			timeArr[3] = -getTimer();
			while(true){
				timeArr[0]++;
				count++;
				if(openList.length == 0){
					return null;
				}
				temp = openList.removeMin();
				currentNode = AstarNode(temp.data);
				currentX = currentNode.x;
				currentY = currentNode.y;
				//已经寻到目标点了，返回路径
				if (currentX == tx && currentY == ty){
					break;
				}
				infoList[currentX][currentY] = [NODE_CLOSE,temp,count];
				for(dir = 0; dir<8; dir++){
					nextX = currentX + dirArr[dir][0];
					nextY = currentY + dirArr[dir][1];
					if(arcs[nextX][nextY] != 0){
						continue;
					}
					if(infoList[nextX]&&infoList[nextX][nextY]&&infoList[nextX][nextY][0] == NODE_CLOSE){
						continue;
					}
					g = currentNode.g + (dir%2 == 1 ? 10 : 14);
					if(infoList[nextX]&&infoList[nextX][nextY]){
						temp = infoList[nextX][nextY][1];
						nextNode = AstarNode(temp.data);
						if (g < nextNode.g){
							nextNode.g = g;
							nextNode.f = nextNode.g + nextNode.h;
							nextNode.preNode = currentNode;
							infoList[nextX][nextY][2] = count;
							temp.value = nextNode.f;
							openList.up(temp.index);
							timeArr[2]++;
						}
					}
					else{
						nextNode = new AstarNode();
						nextNode.x = nextX;
						nextNode.y = nextY;
						nextNode.g = g;
						dx = tx > nextX ? tx - nextX : nextX - tx;
						dy = ty > nextY ? ty - nextY : nextY - ty;
						nextNode.h = dx>dy?(dy*14+(dx-dy)*10):(dx*14+(dy-dx)*10);
						nextNode.f = nextNode.g + nextNode.h;
						nextNode.preNode = currentNode;
						temp = new BinaryHeapNode(nextNode.f,nextNode);
						if(infoList[nextX] == null){
							infoList[nextX] = [];
						}
						infoList[nextX][nextY] = [NODE_OPEN,temp,count];
						openList.insert(temp);
						timeArr[1]++;
					}
				}
			}
			timeArr[3] += getTimer();
			trace(timeArr[0],timeArr[1],timeArr[2],timeArr[3]);
			
			var route:Array = new Array();
			var routeNode:AstarNode = currentNode;
			route.push([routeNode.x, routeNode.y]);
			while (routeNode){
				route.push([routeNode.x, routeNode.y]);
				routeNode = routeNode.preNode;
			}
			
			var path:Array = floydSmoothPath(arcs,route);
			return [route,path,infoList];
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
				return [[sx,sy]];
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
			inc2 = 2*(dx-dy);
			d = 2*dy - dx;
			while(x != tx){
				x += stepX;
				if(d < 0){
					d += inc1/2;
				}
				else{
					y += stepY;
					d -= inc2;
				}
				if(iTag){
					arr.push([y,x]);
				}
				else{
					arr.push([x,y]);
				}
				if(d < 0){
					 d += inc1/2;
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