package com.netease.core.algorithm.astar
{
	import com.netease.flash.common.log.Console;
	
	import flash.utils.getTimer;
	
	
	/**
	 * 最小堆
	 * @author heyaolong
	 * 2012-6-12
	 */
	public class BinaryHeap
	{
		
		private var arr:Vector.<BinaryHeapNode> = new Vector.<BinaryHeapNode>();
		public function BinaryHeap()
		{
		}
		public function insert(node:BinaryHeapNode):void{
			arr.push(node);
			var len:int = arr.length;
			node.index = len-1;
			up(node.index);
		}
		public function get length():int{
			return arr.length;
		}
		public function removeMin():BinaryHeapNode{
			if(arr.length == 0){
				return null;
			}
			if(arr.length==1){
				return arr.pop();
			}
			var min:BinaryHeapNode=arr[0];
			arr[0]=arr.pop();
			arr[0].index = 0;
			down(0);
			return min;
		}
		public function down(index:int):void{
			var parent:int;
			var left:int;
			var num:int;
			var temp:BinaryHeapNode;
			num = arr.length;
			temp = arr[index];
			parent = index;
			left = (parent<<1)+1;
			while(left < num){
				if(left+1<num && arr[left+1].value <= arr[left].value){
					left++;
				}
				if(temp.value <= arr[left].value){
					break;
				}
				arr[parent] = arr[left];
				arr[parent].index = parent;
				parent = left;
				left = (parent<<1)+1;
			}
			arr[parent] = temp;
			arr[parent].index = parent;
		}
		public function up(index:int):void{
			var child:int;
			var parent:int;
			var temp:BinaryHeapNode;
			child = index;
			parent = ((child+1)>>1)-1;
			temp = arr[child];
			while(parent >= 0){
				if(temp.value >= arr[parent].value){
					break;
				}
				arr[child] = arr[parent];
				arr[child].index = child;
				child = parent;
				parent = ((child+1)>>1)-1;
			}
			arr[child] = temp;
			arr[child].index = child;
		}
		public function removeAll():void{
			arr = new Vector.<BinaryHeapNode>();
		}
	}
}