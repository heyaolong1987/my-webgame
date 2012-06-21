package com.netease.flash.common.task {
	
	import com.netease.flash.common.utils.clearSimpleTimeout;
	import com.netease.flash.common.utils.setSimpleTimeout;
	
	
	/**
	 * 任务执行队列
	 *  
	 * @author bezy
	 * 
	 */
	public class TaskEventQueue {
				
		private var taskList:Array = [];
		private var running:Boolean = false;
		private var runningTask:ITask = null;
		private var timeoutId:uint = 0;
		
		public function TaskEventQueue() {
		}
		
		/**
		 * push a task to execute 
		 * @param task
		 * 
		 */
		public function pushTask(task:ITask):void {
			trace("push task: " + task);
			taskList.push(task);
			execute();						
		}
		
		public function clear():void {
			if(timeoutId > 0){
				clearSimpleTimeout(timeoutId);
				timeoutId = 0;
			}
			taskList = [];
			running = false;
			runningTask = null;
		}
		
		/**
		 * commit to task execute complete
		 *  
		 */
		public function commitComplete():void {
			if(timeoutId > 0){
				clearSimpleTimeout(timeoutId);
				timeoutId = 0;
			}
			if(runningTask != null) {
				trace("commit task: " + runningTask);
				runningTask = null;
			}
			running = false;
			execute();
		}
		
		/**
		 * wait some tome to commit task execute complete  
		 * @param delay
		 * @param target
		 * 
		 */
		public function commitCompleteFuture(delay:Number):void {
			trace("commit future for: " + delay);
			if(timeoutId == 0){
				timeoutId = setSimpleTimeout(commitComplete, delay);
			}
		}
		
		private function execute():void {
			if(!running && taskList.length > 0){
				running = true;
				runningTask = taskList.shift() as ITask;
				try{
					runningTask.execute();
				}catch(e:Error) {
					trace("execute task error!", e);
					commitComplete();
				}
			}
		}
	}
}