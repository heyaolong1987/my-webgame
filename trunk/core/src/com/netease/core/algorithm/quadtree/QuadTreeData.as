package com.netease.core.algorithm.quadtree{
	import flash.geom.Point;

	/**
	 * @author heyaolong
	 * 
	 * 2012-5-10
	 */ 
	public class QuadTreeData{
		public var node:QuadTreeNode;
		public var x:int;
		public var y:int;
		public var data:Object;
		public function QuadTreeData(x:int,y:int,data:Object,node:QuadTreeNode)
		{
			this.x = x;
			this.y = y;
			this.data = data;
			this.node = node;
		}
	}
}