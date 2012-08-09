package com.netease.core.algorithm.quadtree{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author heyaolong
	 * 
	 * 2012-4-23
	 */ 
	public class QuadTreeNode{
		/**
		 *子节点 
		 */
		public var childList:Vector.<QuadTreeNode> = new Vector.<QuadTreeNode>(4);
		/**
		 *父亲节点 
		 */
		public var parent:QuadTreeNode;
		/**
		 *是否有孩子 
		 */
		public var hasChild:Boolean;
		
		/**
		 *节点深度 
		 */
		public var deep:int;
		
		/**
		 *对象列表 
		 */
		public var objList:Vector.<QuadTreeData> = new Vector.<QuadTreeData>();
		
		/**
		 *包含的区域 
		 */
		public var rect:Rectangle;
		public function QuadTreeNode()
		{
		}
		/**
		 *释放对象引用 
		 * 
		 */
		public function distroy():void{
			childList  = new Vector.<QuadTreeNode>(4);
			objList = new Vector.<QuadTreeData>();
		}
	}
}