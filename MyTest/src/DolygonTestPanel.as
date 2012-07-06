package{
	import com.netease.core.algorithm.CDelaunay;
	import com.netease.core.algorithm.astar.AStar;
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
		private var mapWidth:int=300;
		private var mapHeight:int=300;
		private var tileWidth:int=100;
		private var tileHeight:int=100;
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
		public function DolygonTestPanel()
		{
			mouseChildren = false;
			arcs = new Array(col);
			flag = new Array(col);
			for(var i:int=0; i<col; i++){
				arcs[i] = new Array(row);
				flag[i] = new Array(row);
				for(var j:int=0; j<row; j++){
					flag[i][j] = 0;
					if(i==0 || i==col-1 || j ==0 || j==row-1){
						arcs[i][j] = 1;
					}else{
						arcs[i][j] = Math.floor(Math.random()*2) == 0?1:0;
					}
					if((i+j)%2 == 1){
						arcs[i][j] = 0;
					}
					else{
						arcs[i][j] = 1;
					}
					
				}
			}
			getAllPolygons();
			//triangleList = CDelaunay.createDelaunay(polygonList);
			addAllChildren();
		}
		private function addAllChildren():void{
			addChild(sprite);
			addChild(routeSprite);
			addChild(triangleSprite);
			addChild(polygonSprite);
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
					
					//routeSprite.graphics.beginFill(0xff0000);
					//routeSprite.graphics.drawRect(,tileWidth,tileHeight);
					//routeSprite.graphics.endFill();
				}
			}
			
			/*
			for(var i:int=0;i<triangleList.length; i++){
			var triangle:CTriangle = triangleList[i];
			triangleSprite.graphics.lineStyle(2,0x0000ff);
			triangleSprite.graphics.moveTo(triangle.x1,triangle.y1);
			triangleSprite.graphics.lineTo(triangle.x2,triangle.y2);
			triangleSprite.graphics.lineTo(triangle.x3,triangle.y3);
			triangleSprite.graphics.lineTo(triangle.x1,triangle.y1);
			}*/
			for(var i:int=0; i<polygonList.length; i++){
				polygonSprite.graphics.lineStyle(2,0xff0000);
				var vertexList:Vector.<CPoint> = polygonList[i].vertexList;
				var vertexNum:int = vertexList.length;
				polygonSprite.graphics.moveTo(vertexList[vertexNum-1].x,vertexList[vertexNum-1].y);
				for(var j:int=0; j<vertexNum; j++){
					polygonSprite.graphics.lineTo(vertexList[j].x,vertexList[j].y);
				}
			}
			
			
		}
		private function getAllPolygons():void{
			var addArr:Array = [[0,1],[-1,0],[0,-1],[1,0]];
			var tArr:Array = [[0,0],[-1,0],[-1,-1],[0,-1]];
			var i:int,j:int,k:int,x:int,y:int,tx:int,ty:int;
			var px:int;
			var py:int;
			var d:int;
			var next:int;
			var id:int= 0;
			for(j=0; j<row; j++){
				for(i=0; i<col; i++){
					if(flag[i][j] == 0){
						id++;
						dfs(arcs,flag,i,j,id);
					}
				}
			}
			var hasVisit:Array = new Array(id+1);
			for(var i:int=1;i<=id;i++){
				hasVisit[i] = false;
			}
			for(j=0; j<row; j++){
				for(i=0; i<col; i++){
					if(hasVisit[flag[i][j]] == false && arcs[i][j] == 0){
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
						hasVisit[flag[px][py]] = true;
						vertexList.push(new CPoint(px*tileWidth,py*tileHeight));
						
						do{
							tx = px+tArr[d][0];
							ty = py+tArr[d][1];
							if(tx>=0 && tx<col && ty>=0 && ty<row && arcs[x][y] == arcs[tx][ty]){
								px = px+addArr[d][0];
								py = py+addArr[d][1];
								if(px==x && py==y){
									break;
								}
								else{
									hasVisit[flag[tx][ty]] = true;
									vertexList.push(new CPoint(px*tileWidth,py*tileHeight));
									d = (d+next+4)%4;
								}
							}
							else{
								d = (d-next+4)%4;
							}
						}
						while(true);
						polygonList.push(new CPolygon(vertexList));
						
					}
				}
			}
		}
		private function dfs(arcs:Array,flag:Array,x:int,y:int,id:int):void{
			flag[x][y] = id;
			var addArr:Array = [[0,1],[1,0],[0,-1],[-1,0]];
			var i:int;
			var tx:int;
			var ty:int;
			for(i=0;i<4;i++){
				tx = x+addArr[i][0];
				ty = y+addArr[i][1];
				if(tx>=0&&tx<col && ty>=0 && ty<row){
					if(flag[tx][ty] == 0 && arcs[x][y] == arcs[tx][ty]){
						dfs(arcs,flag,tx,ty,id);
					}
				}
			}
		}
		
	}
}