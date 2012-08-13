package com.netease.core.geom{
	/**
	 * @author heyaolong
	 * 
	 * 2012-6-26
	 */ 
	public class CTriangle{
		public var x1:int;
		public var y1:int;
		public var x2:int;
		public var y2:int;
		public var x3:int;
		public var y3:int;
		public function CTriangle(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number)
		{
			this.x1 = x1;
			this.y1 = y1;
			this.x2 = x2;
			this.y2 = y2;
			this.x3 = x3;
			this.y3 = y3;
		}
		/**
		 * 返回顶角在o点，起始边为os，终止边为oe的夹角, 即∠soe (单位：弧度) 
		 * 角度小于pi，返回正值;   角度大于pi，返回负值 
		 */		
		public static function lineAngle(sx:Number,sy:Number, ox:Number, oy:Number, ex:Number, ey:Number):Number 
		{ 
			var cosfi:Number, fi:Number, norm:Number; 
			var dsx:Number = sx - ox; 
			var dsy:Number = sy - oy; 
			var dex:Number = ex - ox; 
			var dey:Number = ey - oy; 
			
			cosfi = dsx*dex + dsy*dey; 
			norm = (dsx*dsx + dsy*dsy) * (dex*dex + dey*dey); 
			cosfi /= Math.sqrt( norm ); 
			
			if(cosfi >=  1.0){
				return 0; 
			}
			if(cosfi <= -1.0){
				return -Math.PI; 
			}
			fi = Math.acos(cosfi); 
			if (dsx*dey - dsy*dex > 0) 
				return fi;      // 说明矢量os 在矢量 oe的顺时针方向 
			else{
				return -fi;
			}
		} 
	}
}