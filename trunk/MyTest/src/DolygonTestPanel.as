package{
	import com.netease.core.algorithm.CDelaunay;
	import com.netease.core.algorithm.astar.AStar;
	import com.netease.core.algorithm.astar.NavMeshAStar;
	import com.netease.core.algorithm.astar.NavmeshAstarNode;
	import com.netease.core.geom.CLine;
	import com.netease.core.geom.CPoint;
	import com.netease.core.geom.CPolygon;
	import com.netease.core.geom.CTriangle;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.core.UIComponent;
	
	/**
	 * @author heyaolong
	 * 
	 * 2012-7-4
	 */ 
	public class DolygonTestPanel extends UIComponent{
		private var mapWidth:int=1000;
		private var mapHeight:int=600;
		private var tileWidth:int=40;
		private var tileHeight:int=40;
		private var row:int = mapHeight/tileHeight;
		private var col:int = mapWidth/tileWidth;
		private var sprite:Sprite = new Sprite();
		private var arcs:Array;
		private var startPoint:Point;
		private var endPoint:Point;
		private var routeSprite:Sprite = new Sprite();
		private var polygonSprite:Sprite = new Sprite();
		private var triangleSprite:Sprite = new Sprite();
		private var flag:Array;
		private var polygonList:Vector.<CPolygon> = new Vector.<CPolygon>();
		private var triangleList:Vector.<CTriangle>;
		private var astarNodeList:Vector.<NavmeshAstarNode>;
		private var sx:int;
		private var sy:int;
		private var ex:int;
		private var ey:int;
		private var path:Array;
		private var step:int=0;
		public function DolygonTestPanel()
		{
			addEventListener(MouseEvent.CLICK,onMouseClick);
			var i:int,j:int,k:int,p:int;
			mouseChildren = false;
			arcs = new Array(col);
			flag = new Array(col);
			for(i=0; i<col; i++){
				arcs[i] = new Array(row);
				flag[i] = new Array(row);
				for(j=0; j<row; j++){
					flag[i][j] = 0;
					if(i==0 || i==col-1 || j ==0 || j==row-1){
						arcs[i][j] = 1;
					}else{
						arcs[i][j] = Math.floor(Math.random()*2) == 0?1:0;
					}
					
					
				}
			}
			getAllPolygons();
			triangleList = CDelaunay.createDelaunay(polygonList);
			
			//构建寻路数据
			astarNodeList = new Vector.<NavmeshAstarNode>();
			var trg:CTriangle;
			var node:NavmeshAstarNode;
			for (i=0; i<triangleList.length; i++) {
				trg = triangleList[i];
				node = new NavmeshAstarNode(trg.x1,trg.y1,trg.x2,trg.y2,trg.x3,trg.y3);
				node.id = i;
				astarNodeList.push(node);
			}
			var x11:int,y11:int,x12:int,y12:int,x21:int,y21:int,x22:int,y22:int;
			for(i=0; i<astarNodeList.length; i++){
				for(j=i+1; j<astarNodeList.length; j++){
					var node1:NavmeshAstarNode = astarNodeList[i];
					var node2:NavmeshAstarNode = astarNodeList[j];
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
			
			
			addAllChildren();
		}
		private function addAllChildren():void{
			addChild(sprite);
			addChild(triangleSprite);
			addChild(polygonSprite);
			addChild(routeSprite);
			
			for(var i:int=0; i<col; i++){
				for(var j:int=0; j<row; j++){
					if(arcs[i][j] == 1){
						sprite.graphics.beginFill(0x000000);
						sprite.graphics.drawRect(i*tileWidth,j*tileHeight,tileWidth,tileHeight);
						sprite.graphics.endFill();
					}
					else{
						sprite.graphics.beginFill(0xffffff);
						sprite.graphics.drawRect(i*tileWidth,j*tileHeight,tileWidth,tileHeight);
						sprite.graphics.endFill();
					}
				}
			}
			
			while(triangleSprite.numChildren>0){
				triangleSprite.removeChildAt(0);
			}
			for(var i:int=0;i<astarNodeList.length; i++){
				var triangle:NavmeshAstarNode = astarNodeList[i];
				triangleSprite.graphics.lineStyle(2,0x0000ff);
				triangleSprite.graphics.moveTo(triangle.x1,triangle.y1);
				triangleSprite.graphics.lineTo(triangle.x2,triangle.y2);
				triangleSprite.graphics.lineTo(triangle.x3,triangle.y3);
				triangleSprite.graphics.lineTo(triangle.x1,triangle.y1);
				var label:TextField = new TextField();
				label.text = triangle.id.toString();
				label.x = triangle.centerX;
				label.y = triangle.centerY;
				label.textColor = 0xff0000;
				triangleSprite.addChild(label);
			}
			/*for(var i:int=0; i<polygonList.length; i++){
			polygonSprite.graphics.lineStyle(2,0xff0000);
			var vertexList:Vector.<CPoint> = polygonList[i].vertexList;
			var vertexNum:int = vertexList.length;
			polygonSprite.graphics.moveTo(vertexList[vertexNum-1].x,vertexList[vertexNum-1].y);
			for(var j:int=0; j<vertexNum; j++){
			polygonSprite.graphics.lineTo(vertexList[j].x,vertexList[j].y);
			}
			}*/
			
			
			
		}
		private function drawPath():void{
			routeSprite.graphics.clear();
			if(step == 0){
				routeSprite.graphics.beginFill(0xff0000);
				routeSprite.graphics.drawCircle(sx,sy,2);
				routeSprite.graphics.endFill();
			}
			if(step==1){
				routeSprite.graphics.beginFill(0xff0000);
				routeSprite.graphics.drawCircle(sx,sy,2);
				routeSprite.graphics.endFill();
				routeSprite.graphics.beginFill(0xff0000);
				routeSprite.graphics.drawCircle(ex,ey,2);
				routeSprite.graphics.endFill();
				if(path!=null){
					if(path[0]!=null&&path[0].length>0){
						routeSprite.graphics.lineStyle(3,0x00ff00);
						routeSprite.graphics.moveTo(path[0][0][0],path[0][0][1]);
						for(var i:int=1;i<path[0].length;i++){
							routeSprite.graphics.lineTo(path[0][i][0],path[0][i][1]);
						}
					}
					
					if(path[1]!=null&&path[1].length>0){
						routeSprite.graphics.lineStyle(3,0xff0000);
						routeSprite.graphics.moveTo(path[1][0][0],path[1][0][1]);
						for(var i:int=1;i<path[1].length;i++){
							routeSprite.graphics.lineTo(path[1][i][0],path[1][i][1]);
						}
					}
				}
				
				
			}
		}
		private function getAllPolygons():void{
			var addArr:Array = [[0,1],[-1,0],[0,-1],[1,0]];
			var i:int,j:int,k:int,x:int,y:int,tx:int,ty:int;
			var px:int;
			var py:int;
			var d:int;
			var next:int;
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
						dfs(arcs,flag,i,j,0);
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
		}
		private function dfs(arcs:Array,flag:Array,x:int,y:int,d:int):void{
			flag[x][y] = 1;
			var addArr:Array = [[0,1],[1,0],[0,-1],[-1,0]];
			var i:int;
			var tx:int;
			var ty:int;
			for(i=0;i<4;i++){
				tx = x+addArr[(i+d)%4][0];
				ty = y+addArr[(i+d)%4][1];
				if(tx>=0&&tx<col && ty>=0 && ty<row){
					if(flag[tx][ty] == 0 && arcs[x][y] == arcs[tx][ty]){
						dfs(arcs,flag,tx,ty,(i+d+3)%4);
					}
				}
			}
		}
		private function onMouseClick(event:MouseEvent):void{
			if(step == 0){
				sx = event.localX;
				sy = event.localY;
			}
			else if(step == 1){
				ex = event.localX;
				ey = event.localY;
				path = NavMeshAStar.find(astarNodeList,sx,sy,ex,ey);
			}
			
			drawPath();
			step = (step+1)%2;
		}
		
	}
}