package com.netease.webgame.core.manager{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	
	/**
	 *
	 *@author heyaolong
	 *帧处理管理器，保证按帧率处理
	 *2012-2-13
	 */
	public class CFrameProcessManager{
		private static var _instance:CFrameProcessManager;
		private var _stage:Stage;
		private var _processArr:Array;
		private var _frameRate:int;
		private var _lastTime:int;
		private var _totalProcessedFrames:int = 0;
		private var _totalUnprocessedFrames:int = 0;
		public function CFrameProcessManager()
		{
		}
		public function init(stage:Stage,frameRate:int=24):void{
			_stage = stage;
			_processArr = [];
			_frameRate = frameRate;
			_lastTime = getTimer();
			_stage.addEventListener(Event.ENTER_FRAME,onEnterFrame, false, 0, true);
		}
		public static function getInstance():CFrameProcessManager{
			if(_instance == null){
				_instance = new CFrameProcessManager();
			}
			return _instance;
		}
		/**
		 *移除处理函数 
		 * @param func
		 * 
		 */
		public function removeProcessFunc(func:Function):void{
			if(func == null){
				return;
			}
			var len:int = this._processArr.length;
			for(var i:int=0; i<len; i++){
				if(this._processArr[i] == func){
					this._processArr.splice(i,1);
				}
				i++;
			}
		}
		public function registerProcessFunc(func:Function):void{
			if(func == null){
				return;
			}
			this._processArr.push(func);
		}
		/**
		 *处理函数 
		 * 
		 */
		private function progressAllFunc():void{
			_totalProcessedFrames++;
			var len:int = _processArr.length;
			for(var i:int=0; i<len; i++){
				(this._processArr[i] as Function)();
			}
		}
		private function onEnterFrame(event:Event):void{
			var nowTime:int = getTimer();
			var dTime:int = nowTime - _lastTime;
			var totalFrame:int = Math.floor(dTime*_frameRate*0.001);
			var dFrames:int = totalFrame - _totalProcessedFrames-_totalUnprocessedFrames;
			//当帧延迟比较少时，只执行一次
			if(dFrames <= 2){
				progressAllFunc();
				return;
			}
			if(dFrames>=_frameRate/2){
				dFrames = _frameRate/2;
			}
			for(var i:int=0; i<dFrames; i++){
				progressAllFunc();
			}
			if(getTimer()-nowTime>500){
				trace("CFrameProcessManager 处理慢了");
			}
			return;
		}
		
	}
}