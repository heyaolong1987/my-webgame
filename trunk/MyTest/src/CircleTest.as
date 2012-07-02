package{
	import com.netease.core.geom.CTriangle;
	
	import flash.display.Sprite;
	
	import mx.core.UIComponent;
	
	/**
	 *
	 *@author heyaolong
	 *
	 *2012-7-1
	 */
	public class CircleTest extends UIComponent{
		private var x1:int=110;
		private var y1:int=110;
		private var x2:int=250;
		private var y2:int=300;
		private var x3:int=600;
		private var y3:int=500;
		private var x0:Number;
		private var y0:Number;
		private var r:Number;
		public function CircleTest()
		{
			var a:Number,b:Number, c:Number, d:Number, e:Number;
			a = x1*(y2-y3)+x2*(y3-y1)+x3*(y1-y2);
			b = (x1*x1+y1*y1-x2*x2-y2*y2)/2;
			c = (x1*x1+y1*y1-x3*x3-y3*y3)/2;
			d = b*(y1-y3)-c*(y1-y2);
			e = c*(x1-x2)-b*(x1-x3);
			x0 = d/a;
			y0 = e/a;
			r = Math.sqrt((x0-x1)*(x0-x1)+(y0-y1)*(y0-y1));
			graphics.beginFill(0xff0000);
			graphics.drawCircle(x0,y0,r);
			graphics.endFill();
			graphics.beginFill(0x00ff00);
			graphics.moveTo(x1,y1);
			graphics.lineTo(x2,y2);
			graphics.lineTo(x3,y3);
			graphics.lineTo(x1,y1);
			graphics.endFill();
			var t:Number = CTriangle.lineAngle(x1,y1,x2,y2,x3,y3);
		}
		public function draw():void{
			
		}
	}
}