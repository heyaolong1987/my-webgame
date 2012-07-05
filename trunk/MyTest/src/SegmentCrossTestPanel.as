package{
	import com.netease.core.geom.CLine;
	import com.netease.core.geom.CPoint;
	
	import flash.geom.Point;
	
	import mx.core.UIComponent;

	/**
	 * @author heyaolong
	 * 
	 * 2012-7-5
	 */ 
	public class SegmentCrossTestPanel extends UIComponent{
		
		public function SegmentCrossTestPanel()
		{
			var line1:CLine = new CLine(0,0,100,50);
			var line2:CLine = new CLine(200,100,100,50);
			var point:CPoint = new CPoint();
			graphics.lineStyle(1,0xff0000);
			graphics.moveTo(line1.x1,line1.y1);
			graphics.lineTo(line1.x2,line1.y2);
			graphics.lineStyle(1,0x0000ff);
			graphics.moveTo(line2.x1,line2.y1);
			graphics.lineTo(line2.x2,line2.y2);
			
			if(line1.intersection(line2,point) == CLine.SEGMENTS_INTERSECT){
				graphics.beginFill(0x000000);
				graphics.drawRect(point.x-1,point.y-1,3,3);
				graphics.endFill();
			}
		}
		
	}
}