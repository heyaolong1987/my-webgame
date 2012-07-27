package com.netease.core.view.map.scene{
	
	import com.netease.core.algorithm.astar.NavMeshAstarNode;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;

	/**
	 * @author heyaolong
	 * 
	 * 2012-7-26
	 */ 
	public class NavMeshWall{
		public var mapId : int;
		public var mapWidth : int;
		public var mapHeight : int;
		public var nodeList:Vector.<NavMeshAstarNode>;
		public function NavMeshWall()
		{
		}
		public function setData(byte:ByteArray) : void {
			//解压
			byte.uncompress();
			//mapId = byte.readInt();
			//mapWidth = byte.readInt();
			//mapHeight = byte.readInt();
			var objArr:Vector.<Object> = byte.readObject();
			nodeList = new Vector.<NavMeshAstarNode>();
			var len:int = objArr.length;
			var data:Object;
			var node:NavMeshAstarNode;
			for(var i:int=0; i<len; i++){
				data = objArr[i];
				node = new NavMeshAstarNode(data.x1, data.y1, data.x2, data.y2, data.x3, data.y3);
				node.id = data.id;
				node.linkArr = data.linkArr;
				nodeList.push(node);
			}
		}
		
		public function clear() : void {
			mapId = -1;
			mapWidth = 0;
			mapHeight = 0;
			nodeList = null;
		}
		
		public function isWall( pixX:uint , pixY:uint ):Boolean {
			return true;
		}
		public function getNearestWalkPoint( pixX:Number , pixY:Number ):Point{
			return null;
		}
	}
}