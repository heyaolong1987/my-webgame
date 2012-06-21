package com.netease.core.manager{
	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * @author heyaolong
	 * 在下一帧来处理
	 * 2012-6-6
	 */ 
	public class CallLaterManager{
		private var _callLaters:Array;
		private var _stage:Stage;
		private static var _instance:CallLaterManager;
		public static function getInstance():CallLaterManager{
			if(_instance == null){
				_instance = new CallLaterManager();
			}
			return _instance;
		}
		public function init(stage:Stage):void {
			_stage = stage;
			_callLaters = [];
			_stage.addEventListener(Event.RENDER, callLaterResponse);
		}
		
		public function addFunction(func:Function):void {
			if(_stage) {
				if(_callLaters.indexOf(func) == -1) {
					_callLaters.push(func);
					_stage.invalidate();
				}
			}
		}
		
		public function hasFunction(func:Function):Boolean {
			return (_callLaters.indexOf(func) != -1);
		}
		
		private function callLaterResponse(evt:Event):void {
			for each(var func:Function in _callLaters) {
				func.apply();
			}
			_callLaters = [];
		}
	}
}