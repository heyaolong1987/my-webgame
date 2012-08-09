package com.netease.core.algorithm.quadtree{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author heyaolong
	 * 
	 * 2012-5-10
	 */ 
	public class QuadTreeData{
		public var nodeList:Array = [];
		public var rect:Rectangle;
		public var data:Object;
		public function QuadTreeData(rect:Rectangle,data:Object)
		{
			this.rect = rect;
			this.data = data;
		}
	}
}