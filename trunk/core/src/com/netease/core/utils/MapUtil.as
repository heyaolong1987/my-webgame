package com.netease.core.utils{
	/**
	 * @author heyaolong
	 * 
	 * 2012-5-30
	 */ 
	public class MapUtil{
		
		/**
		 *获取方向 
		 * @param sx
		 * @param sy
		 * @param ex
		 * @param ey
		 * @return 
		 * 
		 */
		public static function getDirection(sx:Number, sy:Number, ex:Number, ey:Number):int{
			var direction:int;
			var angle:Number = (-(Math.atan2((ey - sy), (ex - sx))) * (180 / Math.PI));
			if ((((angle > -157.5)) && ((angle < -112.5)))){
				direction = 1;
			} 
			else if ((((angle > -112.5)) && ((angle < -67.5)))){
				direction = 2;
			} 
			else if ((((angle > -67.5)) && ((angle < -22.5)))){
				direction = 3;
			} 
			else if ((((angle > -22.5)) && ((angle < 22.5)))){
				direction = 6;
			} 
			else if ((((angle > 22.5)) && ((angle < 67.5)))){
				direction = 9;
			} 
			else if ((((angle > 67.5)) && ((angle < 112.5)))){
				direction = 8;
			} 
			else if ((((angle > 112.5)) && ((angle < 157.5)))){
				direction = 7;
			} 
			else {
				direction = 4;
			}
			return direction;
		}
	}
}