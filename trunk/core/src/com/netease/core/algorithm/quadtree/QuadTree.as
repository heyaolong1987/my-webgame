
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
						nNode.rect = new Rectangle(rect.x+i%2*rect.width/2,rect.y+Math.floor(i/2)*rect.height,rect.width*0.5,rect.height*0.5);
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
		public function addOrUpdateObj(x:int,y:int,data:Object):void{
			var quadTreeData:QuadTreeData = _objMap[data];
			var needAddData:Boolean;
			var node:QuadTreeNode;
			if(quadTreeData){
				node = quadTreeData.node;
				if(node.isContainPos(x,y)){
					quadTreeData.x = x;
					quadTreeData.y = y;
				}
				else{
					var len:int = node.objList.length;
					for(var i:int=0; i< len; i++){
						if(node.objList[i].data == data){
							node.objList.splice(i,1);
							needAddData = true;
							break;
						}
					}
				}
			}
			else{
				needAddData = true;
			}
			if(needAddData){
				node = findNodeByPoint(x,y,_root);
				node.objList.push(new QuadTreeData(x,y,data,node));
			}
		}
		/**
		 * 从树中删除对象 
		 * @param x
		 * @param y
		 * @param data
		 * 
		 */
		public function deleteData(x:int,y:int,data:Object):void{
			var node:QuadTreeNode = findNodeByPoint(x,y,_root);
			var length:int = node.objList.length;
			for(var i:int=0; i< length; i++){
				if(node.objList[i].data == data){
					node.objList.splice(i,1);
					break;
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
		private function findNodeByPoint(x:int,y:int, node:QuadTreeNode):QuadTreeNode{
			var result:QuadTreeNode;
			if(node.isContainPos(x,y)){
				result = node;
				if(node.hasChild){
					for each(var child:QuadTreeNode in node.childList){
						if(child.isContainPos(x,y)){
							result =  findNodeByPoint(x,y,child);
							break;
						}
					}
				}
			}
			return result;
		}
		/**
		 * 
		 * @param leftTopx
		 * @param leftTopY
		 * @param rightBottomX
		 * @param rightBottomY
		 * @param exact true 表示精确到像素查找，否则精确到格子
		 * @return 
		 * 
		 */
		public function findOjectsInRect(rect:Rectangle,exact:Boolean=true):Array{
			return dfsFindObjectInRect(_root,rect,exact);
		}
		/**
		 *递归调用查找在当前节点下所有在目标查找区域内的对象 
		 * @param node
		 * @param rect
		 * @param exact
		 * @return 
		 * 
		 */
		private function dfsFindObjectInRect(node:QuadTreeNode,rect:Rectangle,exact:Boolean):Array{
			var objList:Array = [];
			if(rect.intersects(node.rect)){
				if(node.hasChild){
					for each(var child:QuadTreeNode in node.childList){
						if(rect.intersects(child.rect)){
							objList.concat(dfsFindObjectInRect(child,rect,exact));
						}
					}
				}
				else{
					for each(var obj:QuadTreeData in node.objList){
						//精确查找
						if(exact == false || rect.contains(obj.x,obj.y)){
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