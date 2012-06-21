/**
 * HttpService Command
 * Author: Wang Xing 
 * Created At: Aug 13, 2009
 * All HttpService Commands extend this.
 */ 
package com.netease.flash.framework.puremvc.rpc {
	import com.netease.flash.framework.ROService.Responder;
	import com.netease.flash.framework.ROService.ServiceLocator;
	
	import org.puremvc.as3.interfaces.INotification;
	

	public class HttpCommand extends BaseRemoteCallCommand implements Responder {
		public function HttpCommand() {
			super();
		}
		
		override public function execute(notification:INotification):void {
			super.execute(notification);
			
			ServiceLocator.getInstance().HTTPCall(serviceName, methodName, this);
		}
	}
}