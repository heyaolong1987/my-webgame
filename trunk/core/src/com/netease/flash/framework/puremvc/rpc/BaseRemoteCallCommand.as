/**
 * Base RPC command
 * Author: Wang Xing
 * Created At: 13 Aug, 2009
 * Sub Classes: HttpCommand, RemoteObjectCommand.
 * DESCRIPTION:
 * Sub Classes should override the execute() method to invoke the individual RPC call(RemoteObject OR HttpService).
 * Error Handling will be called on fault() and result() methods.
 */ 
package com.netease.flash.framework.puremvc.rpc {
	import com.netease.flash.framework.ROService.Responder;
	import com.netease.flash.framework.puremvc.AbstractCommand;
	import com.netease.flash.framework.puremvc.manager.LoadingManager;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	

	public class BaseRemoteCallCommand extends AbstractCommand implements Responder {
		protected var _showLoadingPopup:Boolean = true;
		public function BaseRemoteCallCommand() {
			super();
		}
		
		override public function execute(notification:INotification):void {
			parseArguments(notification.getBody());
			if (notification.getType() == LoadingManager.HIDE_LOADING) {
				_showLoadingPopup = false;
			} else { // default show the loading
				_showLoadingPopup = true;
				LoadingManager.getInstance().show(this);
			}
		}
		
		// 如果需要处理参数，覆盖此方法
		public function parseArguments(arg:Object):void {
			_arguments = arg;
		}
		
		// 覆盖此方法, 设置RemoteObject的name
		protected function get serviceName():String {
			return "";
		}
		
		// 覆盖此方法, 设置远程方法名
		protected function get methodName():String {
			return "";
		}
		
		protected var _arguments:Object;
		public function get arguments():Object {
			return _arguments;
		}
		
		public function set arguments(value:Object):void {
			_arguments = value;
		}
		
		public function result(event:ResultEvent):void {
			response();
		}
		
		public function fault(event:FaultEvent):void {
			response();
		}
		
		protected function response():void {
			if (_showLoadingPopup) {
				LoadingManager.getInstance().hide(this);
			}
		}
		
	}
}