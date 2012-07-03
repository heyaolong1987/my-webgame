package{
	import com.netease.core.algorithm.CDelaunay;
	import com.netease.core.geom.CPoint;
	import com.netease.core.geom.CPolygon;
	import com.netease.core.geom.CTriangle;
	
	import mx.core.UIComponent;
	
	/**
	 *
	 *@author heyaolong
	 *
	 *2012-7-1
	 */
	public class DelaunayTest extends UIComponent{
		
		public function DelaunayTest()
		{
			var polygonList:Vector.<CPolygon> = new Vector.<CPolygon>();
			//边框多边形
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
			
			var triangleList:Vector.<CTriangle> = CDelaunay.createDelaunay(polygonList);
			
			for(var i:int=1;i<polygonList.length; i++){
				graphics.beginFill(0xff0000);
				var polygon:CPolygon = polygonList[i];
				var point:CPoint = polygon.vertexList[polygon.vertexList.length-1];
				graphics.moveTo(point.x,point.y);
				for(var j:int=0;j<polygon.vertexList.length;j++){
					graphics.lineTo(polygon.vertexList[j].x,polygon.vertexList[j].y);
				}
				graphics.endFill();
			}
			for(var i:int=0;i<triangleList.length; i++){
				var triangle:CTriangle = triangleList[i];
				graphics.lineStyle(2,0x0000ff);
				graphics.moveTo(triangle.x1,triangle.y1);
				graphics.lineTo(triangle.x2,triangle.y2);
				graphics.lineTo(triangle.x3,triangle.y3);
				graphics.lineTo(triangle.x1,triangle.y1);
			}
		}
	}
}