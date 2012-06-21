/**
 * RemoteObject Command
 * Author: Wang Xing 
 * Created At: Aug 13, 2009
 * All Remote Object Commands extend this.
 */ 
package com.netease.flash.framework.puremvc.rpc {
	import com.netease.flash.common.log.Console;
	import com.netease.flash.framework.ROService.Responder;
	import com.netease.flash.framework.ROService.ServiceLocator;
	
	import org.puremvc.as3.interfaces.INotification;
	

	public class RemoteObjectCommand extends BaseRemoteCallCommand implements Responder {
		public function RemoteObjectCommand() {
			super();
		}
		
		override public function execute(notification:INotification):void {
			super.execute(notification);
			ServiceLocator.getInstance().remoteObjectCall(serviceName, methodName, this);
			Console.debug("方法名: " + methodName, "参数: " + _arguments);
		}
	}
}