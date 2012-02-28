package com.netease.webgame.bitchwar.manager {
	import com.netease.flash.common.task.ITask;
	import com.netease.webgame.bitchwar.model.vo.other.TimeTaskVO;
	import com.netease.webgame.bitchwar.util.ServerTimer;
	
	import flash.events.Event;
	import flash.utils.Dictionary;

	public final class TimeTaskManager {
		
		private static var instance:TimeTaskManager;
		
		private var taskDic:Dictionary = new Dictionary();
		
		private var currentTask:TimeTaskVO = null;
		
		public function TimeTaskManager() {
			if (instance) {
				throw new Error("TimeTaskManager is singleton class, please use getInstance().");
			}
		}
		
		public static function getInstance():TimeTaskManager{
			if(instance == null) {
				instance = new TimeTaskManager();
			}
			return instance;
		}
		
		/**
		 * @param time 单位：s
		 */
		public function addTask(taskVO:TimeTaskVO):void {
			delete taskDic[taskVO.vo.tid];
			taskDic[taskVO.vo.tid] = taskVO;
			checkTaskTime();
		}
		
		/**
		 * @param vo TimeTaskVO中对应的vo
		 */
		public function deleteTask(tid:String):void {
			delete taskDic[tid];
			checkTaskTime();
		}
		
		private function checkTaskTime():void {
			var time:Number = 0;
			var task:TimeTaskVO;
			var currentTask:TimeTaskVO;
			for each(task in taskDic) {
				if(time==0 || task.endTime<time) {
					time = task.endTime;
					currentTask = task;
				} 
			}
			this.currentTask = currentTask;
			ServerTimer.removeEventListener(ServerTimer.TIME_UPDATED, timeUpdatedHandler);
			if(this.currentTask!=null) {
				ServerTimer.addEventListener(ServerTimer.TIME_UPDATED, timeUpdatedHandler);
			} 
		}
		
		/**
		 * 执行计时
		 */
		private function timeUpdatedHandler(event:Event):void {
			var tempCurrentTask:TimeTaskVO = this.currentTask;
			if(tempCurrentTask!=null) {
				if(ServerTimer.getCurrentTime()>tempCurrentTask.endTime) {
					deleteTask(tempCurrentTask.vo.tid);
					tempCurrentTask.callFun(tempCurrentTask.vo);
					checkTaskTime();
				}
			} else {
				checkTaskTime();
			}
		}
		
	}
}