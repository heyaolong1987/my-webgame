package com.netease.flash.framework.mvc.observer
{
	/**
	 * notification (as event) 
	 * 
	 * @author bezy
	 */
	public class Notification {
		private var _name:String;
		private var _body:*;
		private var _currentTarget:Object;
		
		/**
		 * 构造函数
		 * 
		 * @param name  消息名称
		 * @param body  消息内容
		 * 
		 */
		public function Notification(name: String, body:* = null) {
			this._name = name;
			this._body = body;	
		}
		
		/**
		 * 获取消息名称
		 *  
		 * @return String
		 */
		public function get name():String {
			return this._name;
		}
		
		/**
		 * 获取消息内容 
		 * 
		 * @return *
		 */
		public function get body():* {
			return this._body;
		}
		
		/**
		 * 设置使用某个事件侦听器处理 Notification 对象的对象
		 * 
		 * @param target
		 */
		internal function setCurrentTarget(target:Object):void {
			this._currentTarget = target;
		}
		
		/**
		 * 获取使用某个事件侦听器处理 Notification 对象的对象
		 *  
		 * @return Object
		 */		
		public function get currentTarget():Object {
			return this._currentTarget;
		}
		
	}
}