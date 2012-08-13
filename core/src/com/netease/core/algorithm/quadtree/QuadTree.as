package com.netease.core.algorithm.quadtree{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * @author heyaolong
	 * 四叉树
	 * 2012-4-23
	 */ 
	public class QuadTree{
		
		/**
		 *树深度 
		 */
		private var _treeDeep:int = 0;
		/**
		 *最小格子大小 
		 */
		private var _minGrid:int = 0;
		/**
		 *最大宽度 
		 */
		private var _maxWidth:int = 0;
		/**
		 *最大高度 
		 */
		private var _maxHeight:int = 0;
		/**
		 *所有节点的列表 
		 */
		private var _nodeList:Vector.<QuadTreeNode> = new Vector.<QuadTreeNode>;
		/**
		 *根节点 
		 */
		private var _root:QuadTreeNode;
		/**
		 *对象列表
		 */
		private var _objMap:Dictionary = new Dictionary();
		
		public function QuadTree(treeDeep:int=9,minGrid:int=20){
			this._treeDeep = treeDeep;
			this._minGrid = minGrid;
			_maxWidth = _maxHeight = _minGrid*Math.pow(2,_treeDeep);
			createTree();
			
		}
		/**
		 *构建整个树 
		 * 
		 */
		private function createTree():void{
			_root = new QuadTreeNode();
			_root.childList = new Vector.<QuadTreeNode>(4);
			_root.deep = 0;
			_root.rect = new Rectangle(0,0,_maxWidth,_maxHeight);
			var cNode:QuadTreeNode;
			var nNode:QuadTreeNode;
			var nodeStack:Vector.<QuadTreeNode> = new Vector.<QuadTreeNode>;
			_nodeList.push(_root);
			nodeStack.push(_root);
			var i:int;
			var j:int;
			var rect:Rectangle;
			while(nodeStack.length>0){
				cNode = nodeStack.pop();
				if(cNode.deep<_treeDeep){
					cNode.hasChild = true;
					for(i=3; i>=0; i--){
						nNode = new QuadTreeNode();
						_nodeList.push(nNode);
						nodeStack.push(nNode);
						nNode.deep = cNode.deep+1;
						nNode.parent = cNode;
						rect = cNode.rect;
						nNode.rect = new Rectangle(rect.x+i%2*rect.width/2,rect.y+Math.floor(i/2)*rect.height/2,rect.width*0.5,rect.height*0.5);
						cNode.childList[i] = nNode;
					}
				}
				else{
					nodeStack.pop();
				}
			}
		}
		/**
		 * 添加对象到树中
		 * @param data
		 * 
		 */
		public function addOrUpdateObj(rect:Rectangle,data:Object):void{
			deleteData(data);
			var nodeList:Array;
			var len:int;
			var i:int;
			var node:QuadTreeNode;
			var quadTreeData:QuadTreeData;
			
			quadTreeData = new QuadTreeData(rect,data);
			_objMap[data] = quadTreeData;
			nodeList = findNodeListByRect(rect,_root);
			quadTreeData.nodeList = nodeList;
			len = nodeList.length;
			for(i=0;i<len;i++){
				node = nodeList[i] as QuadTreeNode;
				node.objList.push(quadTreeData);
			}
		}
		/**
		 * 从树中删除对象
		 * @param data
		 * 
		 */
		public function deleteData(data:Object):void{
			var quadTreeData:QuadTreeData = _objMap[data];
			if(quadTreeData){
				var nodeList:Array;
				var len:int;
				var i:int;
				var node:QuadTreeNode;
				
				_objMap[data] = null;
				nodeList = quadTreeData.nodeList;
				nodeList = quadTreeData.nodeList;
				len = nodeList.length;
				for(i=0; i<len; i++){
					node = nodeList[i] as QuadTreeNode;
					var len:int = node.objList.length;
					for(var i:int=0; i< len; i++){
						if(node.objList[i].data == data){
							node.objList.splice(i,1);
							break;
						}
					}
				}
			}
		}
		/**
		 * 通过坐标来找节点 
		 * @param x
		 * @param y
		 * @param node
		 * @return
		 * 
		 */
		private function findNodeListByRect(rect:Rectangle, node:QuadTreeNode):Array{
			var nodeList:Array = [];
			if(rect.intersects(node.rect)){
				if(rect.containsRect(node.rect)){
					nodeList.push(node);
				}
				else{
					if(node.hasChild){
						for each(var child:QuadTreeNode in node.childList){
							nodeList = nodeList.concat(findNodeListByRect(rect,child));
						}
					}
					else{
						nodeList.push(node);
					}
				}
			}
			return nodeList;
		}
		/**
		 * 
		 * @param rect
		 * @return 
		 * 
		 */
		public function findOjectsInRect(rect:Rectangle):Array{
			var objList:Array = dfsFindObjectInRect(_root,rect);
			var len:int = objList.length;
			var i:int,j:int;
			for(i=len-1; i>=1; i--){
				for(j=i-1; j>=0; j--){
					if(objList[i] == objList[j]){
						objList.splice(j,1);
						i--;
					}
				}
			}
			return objList;
		}
		/**
		 *递归调用查找在当前节点下所有在目标查找区域内的对象 
		 * @param node
		 * @param rect
		 * @return 
		 * 
		 */
		private function dfsFindObjectInRect(node:QuadTreeNode,rect:Rectangle):Array{
			var objList:Array = [];
			if(node.rect.equals(new Rectangle(80,80,40,40))){
				objList = [];
			}
			if(rect.intersects(node.rect)){
				for each(var obj:QuadTreeData in node.objList){
					objList.push(obj.data);
				}
				if(node.hasChild){
					for each(var child:QuadTreeNode in node.childList){
						if(rect.intersects(child.rect)){
							objList = objList.concat(dfsFindObjectInRect(child,rect));
						}
					}
				}
				else{
					for each(var obj:QuadTreeData in node.objList){
						//精确查找
						if(rect.intersection(obj.rect)){
							objList.push(obj.data);
						}
					}
				}
			}
			return objList;
		}
		/**
		 *是否包含对象 
		 * @param obj
		 * @return 
		 * 
		 */
		private function isContainObj(obj:Object):Boolean{
			if(_objMap[obj]){
				return true;
			}
			return false;
		}
		/**
		 *移除所有数据
		 * 
		 */
		public function removeAll():void{
			//采用了非递归方式
			for each( var node:QuadTreeNode in _nodeList){
				node.distroy();
			}
		}
	}
}