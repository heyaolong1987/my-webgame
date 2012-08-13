package com.netease.core.geom{
	/**
	 * @author heyaolong
	 * 
	 * 2012-6-26
	 */ 
	public class CRectangle{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public function CRectangle(x:Number,y:Number,width:Number,height:Number)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		public function contains(px:int,py:int):Boolean{
			return px>=x&&px<=x+width&&py>=y&&py<=y+height;
		}
		public function intersection(rect:CRectangle):Boolean{
			return contains(rect.x,rect.y) || contains(rect.x+rect.width,rect.y) || contains(rect.x,rect.y+rect.height) || contains(rect.x+width,rect.y+height);
		}
	}
}