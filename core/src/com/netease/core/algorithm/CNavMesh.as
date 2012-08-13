package com.netease.core.algorithm{
	import com.netease.core.algorithm.astar.NavMeshAstarNode;
	import com.netease.core.geom.CLine;
	import com.netease.core.geom.CPoint;
	import com.netease.core.geom.CPolygon;
	import com.netease.core.geom.CTriangle;
	
	
	
	/**
	 * @author heyaolong
	 * 
	 * 2012-7-18
	 */ 
	public class CNavMesh{
		
		public function CNavMesh()
		{
		}
		public static function createAstarNode(arcs:Array,row:int,col:int,tileWidth,tileHeight):Vector.<NavMeshAstarNode>{
			var polygonList:Vector.<CPolygon> = getAllPolygons(arcs,row,col,tileWidth,tileHeight);
			var triangleList:Vector.<CTriangle>= CDelaunay.createDelaunay(polygonList);
			var astarNodeList:Vector.<NavMeshAstarNode> = generalAstarNode(triangleList);
			return astarNodeList;
		}
		public static function getAllPolygons(arcs:Array,row:int,col:int,tileWidth:int,tileHeight:int):Vector.<CPolygon>{
			var polygonList:Vector.<CPolygon> = new Vector.<CPolygon>();
			var flag:Array=[];
			var addArr:Array = [[0,1],[-1,0],[0,-1],[1,0]];
			var i:int,j:int,k:int,x:int,y:int,tx:int,ty:int;
			var px:int;
			var py:int;
			var d:int;
			var next:int;
			
			for(var i:int=0; i<col; i++){
				flag[i] = [];
				for(var j:int=0; j<row; j++){
					flag[i][j] = 0;
				}
			}
			for(i=0; i<col; i++){
				for(j=0; j<row; j++){
					if(flag[i][j]==0){
						if(arcs[i][j] == 0){
							next = 1;
							d = 0;
						}
						else{
							next = -1;
							d = 3;
						}
						x = i;
						y = j;
						px = x;
						py = y;
						var vertexList:Vector.<CPoint> = new Vector.<CPoint>();
						vertexList.push(new CPoint(px*tileWidth,py*tileHeight));
						do{
							tx = x+addArr[d][0];
							ty = y+addArr[d][1];
							if(px+addArr[d][0]>=x && px+addArr[d][0]<=x+1 && py+addArr[d][1]>=y && py+addArr[d][1]<=y+1){
								px += addArr[d][0];
								py += addArr[d][1];
								if(px==i && py==j){
									break;
								}
								else{
									vertexList.push(new CPoint(px*tileWidth,py*tileHeight));
								}
							}
							if(tx>=0&&tx<col && ty>=0 && ty<row && arcs[x][y] == arcs[tx][ty]){
								d = (d+next+4)%4;
								x = tx;
								y = ty;
							}
							else{
								d = (d-next+4)%4;
							}
						}
						while(true);
						
						polygonList.push(new CPolygon(vertexList));
						bfs(arcs,row,col,flag,i,j);
					}
				}
			}
			
			var len:int = polygonList.length;
			var polygon:CPolygon;
			var vertexList:Vector.<CPoint>;
			var vertexNum:int;
			var line:CLine = new CLine();
			var startPoint:CPoint;
			var endPoint:CPoint;
			for(i=0; i<len; i++){
				polygon = polygonList[i];
				vertexNum = polygon.vertexNum;
				vertexList = polygon.vertexList;
				if(vertexNum>3){
					startPoint = vertexList[vertexNum-1];
					endPoint = vertexList[0];
					line.x1 = startPoint.x;
					line.y1 = startPoint.y;
					line.x2 = endPoint.x;
					line.y2 = endPoint.y;
					for(j=vertexNum-2; j>=0; j--){
						if((line.x2-line.x1)*(line.y1-vertexList[j].y) == (line.y2-line.y1)*(line.x1-vertexList[j].x)){
							vertexList.splice(j+1,1);
						}
						else{
							line.x1 = vertexList[j].x;
							line.y1 = vertexList[j].y;
							line.x2 = vertexList[j+1].x;
							line.y2 = vertexList[j+1].y;
						}
					}
				}
				polygon.vertexNum = vertexList.length;
			}
			return polygonList;
		}
		public static function generalAstarNode(triangleList:Vector.<CTriangle>):Vector.<NavMeshAstarNode>{
			//构建寻路数据
			var astarNodeList:Vector.<NavMeshAstarNode> = new Vector.<NavMeshAstarNode>();
			var trg:CTriangle;
			var node:NavMeshAstarNode;
			var i:int,j:int,k:int,p:int;
			var x11:int,y11:int,x12:int,y12:int,x21:int,y21:int,x22:int,y22:int;
			
			for (i=0; i<triangleList.length; i++) {
				trg = triangleList[i];
				node = new NavMeshAstarNode(trg.x1,trg.y1,trg.x2,trg.y2,trg.x3,trg.y3);
				node.id = i;
				astarNodeList.push(node);
			}
			for(i=0; i<astarNodeList.length; i++){
				for(j=i+1; j<astarNodeList.length; j++){
					var node1:NavMeshAstarNode = astarNodeList[i];
					var node2:NavMeshAstarNode = astarNodeList[j];
					for(k=0;k<3;k++){
						x11 = node1["x"+(k+1).toString()];
						y11 = node1["y"+(k+1).toString()];
						x12 = node1["x"+((k+1)%3+1).toString()];
						y12 = node1["y"+((k+1)%3+1).toString()];
						if(node1.linkArr[k] == -1){
							for(p=0; p<3; p++){
								x21 = node2["x"+(p+1).toString()];
								y21 = node2["y"+(p+1).toString()];
								x22 = node2["x"+((p+1)%3+1).toString()];
								y22 = node2["y"+((p+1)%3+1).toString()];
								if((x11 == x21 && y11 == y21&&x12 == x22 && y12 == y22) || (x12 == x21 && y12 == y21&&x11 == x22 && y11 == y22)){
									node1.linkArr[k] = node2.id;
									node2.linkArr[p] = node1.id;
									break;
								}
							}
						}
					}
				}
			}
			return astarNodeList;
		}
		private static function bfs(arcs:Array,row:int,col:int,flag:Array,x:int,y:int):void{
			var queue:Array = [];
			var addArr:Array = [[0,1],[1,0],[0,-1],[-1,0]];
			var i:int;
			var tx:int;
			var ty:int;
			var pos:Array;
			queue.push([x,y]);
			flag[x][y] = 1;
			while(queue.length>0){
				pos = queue.shift() as Array;
				x = pos[0];
				y = pos[1];
				for(i=0;i<4;i++){
					tx = x+addArr[i][0];
					ty = y+addArr[i][1];
					if(tx>=0&&tx<col && ty>=0 && ty<row){
						if(flag[tx][ty] == 0 && arcs[x][y] == arcs[tx][ty]){
							queue.push([tx,ty]);
							flag[tx][ty] = 1;
						}
					}
				}
			}
			
		}
	}
}