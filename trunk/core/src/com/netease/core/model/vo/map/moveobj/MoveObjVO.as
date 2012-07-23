package com.netease.core.model.vo.map.moveobj{
	import com.netease.core.utils.MovingTween;
	import com.netease.core.view.map.moveobj.MoveObj;

	/**
	 * @author heyaolong
	 * 
	 * 2012-5-23
	 */ 
	public class MoveObjVO{
		public var id:int;
		public var type:int;
		public var name:String;
		public var action:int;
		public var x:Number;
		public var y:Number;
		public var movingTween:MovingTween;
		public var dir:int;
		public var sex:int;
		public function MoveObjVO()
		{
		}
	}
}