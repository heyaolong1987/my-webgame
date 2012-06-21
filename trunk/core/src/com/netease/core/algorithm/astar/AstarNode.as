package com.netease.core.algorithm.astar{
	/**
	 * @author heyaolong
	 * 
	 * 2012-6-15
	 */ 
	public class AstarNode{
		public var x:int;
		public var y:int;
		public var g:int;
		public var h:int;
		public var f:int;
		public var preNode:AstarNode;
		public function AstarNode()
		{
		}
	}
}