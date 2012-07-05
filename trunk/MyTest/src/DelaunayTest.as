package{
	import com.netease.core.algorithm.CDelaunay;
	import com.netease.core.geom.CPoint;
	import com.netease.core.geom.CPolygon;
	import com.netease.core.geom.CTriangle;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	/**
	 *
	 *@author heyaolong
	 *
	 *2012-7-1
	 */
	public class DelaunayTest extends UIComponent{
		private var mapWidth:int=50;
		private var mapHeight:int=100;
		private var tileWidth:int=50;
		private var tileHeight:int=50;
		private var row:int = mapHeight/tileHeight;
		private var col:int = mapWidth/tileWidth;
		private var arcs:Array;
		private var startPoint:Point;
		private var endPoint:Point;
		private var arcsSprite:Sprite = new Sprite();
		private var polygonSprite:Sprite = new Sprite();
		private var triangleSprite:Sprite = new Sprite();
		private var routeSprite:Sprite = new Sprite();
		public function DelaunayTest()
		{
			
			
			var polygonList:Vector.<CPolygon> = new Vector.<CPolygon>();
			/*	//边框多边形
			var v0:Vector.<CPoint>;
			var poly0:CPolygon;
			
			v0 = new Vector.<CPoint>();
			v0.push(new CPoint(20, 20));			
			v0.push(new CPoint(20, 500));
			v0.push(new CPoint(800, 500));
			v0.push(new CPoint(800, 20));
			poly0 = new CPolygon(v0);
			polygonList.push(poly0);
			
			
			v0 = new Vector.<CPoint>();
			v0.push(new CPoint(30, 40));			
			v0.push(new CPoint(100, 60));
			v0.push(new CPoint(70, 90));
			poly0 = new CPolygon(v0);
			polygonList.push(poly0);
			
			
			v0 = new Vector.<CPoint>();
			v0.push(new CPoint(200, 80));			
			v0.push(new CPoint(500, 50));
			v0.push(new CPoint(450, 300));
			v0.push(new CPoint(400, 400));
			v0.push(new CPoint(210, 300));
			poly0 = new CPolygon(v0);
			polygonList.push(poly0);
			
			v0 = new Vector.<CPoint>();
			v0.push(new CPoint(450, 100));
			v0.push(new CPoint(600, 300));
			v0.push(new CPoint(500, 300));
			poly0 = new CPolygon(v0);
			polygonList.push(poly0);
			
			
			v0 = new Vector.<CPoint>();
			v0.push(new CPoint(250, 100));
			v0.push(new CPoint(250, 200));
			v0.push(new CPoint(300, 300));
			v0.push(new CPoint(350, 250));
			v0.push(new CPoint(400, 100));
			poly0 = new CPolygon(v0);
			polygonList.push(poly0);
			
			
			v0 = new Vector.<CPoint>();
			v0.push(new CPoint(320, 300));
			v0.push(new CPoint(370, 350));
			v0.push(new CPoint(400, 300));
			v0.push(new CPoint(420, 250));
			poly0 = new CPolygon(v0);
			polygonList.push(poly0);
			*/
			mouseChildren = false;
			arcs = new Array(col);
			for(var i:int=0; i<col; i++){
				arcs[i] = new Array(row);
				for(var j:int=0; j<row; j++){
					
					if(i==0 || i==col-1 || j ==0 || j==row-1){
						arcs[i][j] = 1;
					}else{
						arcs[i][j] = Math.floor(Math.random()*2) == 0?1:0;
					}
					arcs[i][j] = 0;
					
				}
			}
			
			for(var i:int=0; i<col; i++){
				for(var j:int=0; j<row; j++){
					if(arcs[i][j] == 0){
						var vertexList:Vector.<CPoint> = new Vector.<CPoint>();
						vertexList.push(new CPoint(i*tileWidth,j*tileHeight));
						vertexList.push(new CPoint(i*tileWidth,(j+1)*tileHeight));
						vertexList.push(new CPoint((i+1)*tileWidth,(j+1)*tileHeight));
						vertexList.push(new CPoint((i+1)*tileWidth,j*tileHeight));
						var polygon:CPolygon = new CPolygon(vertexList);
						polygonList.push(polygon);
					}
				}
			}
			
			var triangleList:Vector.<CTriangle> = CDelaunay.createDelaunay(CDelaunay.unionAllPolygons(polygonList));
						
			
			addChild(arcsSprite);
			addChild(polygonSprite);
			//addChild(triangleSprite);
			//addChild(routeSprite);
			for(var i:int=0; i<col; i++){
				for(var j:int=0; j<row; j++){
					if(arcs[i][j] == 1){
						arcsSprite.graphics.beginFill(0xff0000);
						arcsSprite.graphics.drawRect(i*tileWidth,j*tileHeight,tileWidth,tileHeight);
						arcsSprite.graphics.endFill();
					}
					else{
						arcsSprite.graphics.beginFill(0x000000);
						arcsSprite.graphics.drawRect(i*tileWidth,j*tileHeight,tileWidth,tileHeight);
						arcsSprite.graphics.endFill();
					}
				}
			}
			
			for(var i:int=1;i<polygonList.length; i++){
				polygonSprite.graphics.lineStyle(2,0xffff00);
				var polygon:CPolygon = polygonList[i];
				var point:CPoint = polygon.vertexList[polygon.vertexList.length-1];
				polygonSprite.graphics.moveTo(point.x,point.y);
				for(var j:int=0;j<polygon.vertexList.length;j++){
					polygonSprite.graphics.lineTo(polygon.vertexList[j].x,polygon.vertexList[j].y);
				}
			}
			/*for(var i:int=0;i<triangleList.length; i++){
				var triangle:CTriangle = triangleList[i];
				triangleSprite.graphics.lineStyle(2,0x0000ff);
				triangleSprite.graphics.moveTo(triangle.x1,triangle.y1);
				triangleSprite.graphics.lineTo(triangle.x2,triangle.y2);
				triangleSprite.graphics.lineTo(triangle.x3,triangle.y3);
				triangleSprite.graphics.lineTo(triangle.x1,triangle.y1);
			}*/
		}
	}
}