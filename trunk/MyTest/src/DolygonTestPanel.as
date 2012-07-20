package{
	import com.netease.core.algorithm.CDelaunay;
	import com.netease.core.algorithm.CNavMesh;
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
		private var mapWidth:int=400;
		private var mapHeight:int=400;
		private var tileWidth:int=10;
		private var tileHeight:int=10;
		private var row:int = mapHeight/tileHeight;
		private var col:int = mapWidth/tileWidth;
		private var sprite:Sprite = new Sprite();
		private var arcs:Array;
		private var startPoint:Point;
		private var endPoint:Point;
		private var routeSprite:Sprite = new Sprite();
		private var polygonSprite:Sprite = new Sprite();
		private var triangleSprite:Sprite = new Sprite();
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
			var i:int,j:int;
			mouseChildren = false;
			arcs = new Array(col);
			for(i=0; i<col; i++){
				arcs[i] = new Array(row);
				for(j=0; j<row; j++){
					if(i==0 || i==col-1 || j ==0 || j==row-1){
						arcs[i][j] = 1;
					}else{
						arcs[i][j] = Math.floor(Math.random()*2) == 0?1:0;
					}
				}
			}
			polygonList = CNavMesh.getAllPolygons(arcs,row,col,tileWidth,tileHeight);
			triangleList = CDelaunay.createDelaunay(polygonList);
			astarNodeList = CNavMesh.generalAstarNode(triangleList);
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