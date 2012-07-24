package com.netease.core.model.vo.map.moveobj{
	import com.netease.core.utils.MovingTween;
	import com.netease.core.view.map.moveobj.MoveObj;
	import com.netease.manager.WalkStepManager;
	
	import flash.utils.getTimer;

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
		private var _route:Array;
		public var dir:int;
		public var sex:int;
		public var speed:int;
		public var lastUpdateTime:int;
		public function MoveObjVO()
		{
		}
		public function set route(value:Array):void{
			_route = value;
			lastUpdateTime = getTimer();
		}
		public function get route():Array{
			return _route;
		}
		public function run():void{
			
		}
	}
}