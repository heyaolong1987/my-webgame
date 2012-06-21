package com.netease.flash.framework.puremvc {
	import com.netease.flash.common.utils.setSimpleTimeout;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * abstract service
	 *  
	 * @author bezy
	 * 
	 */
	public class AbstractService extends Proxy {
						
		public function AbstractService(data:Object=null) {
			super(null, data);
		}
		
		internal function setServiceName(serviceName:String):void {
			this.proxyName = serviceName;
		}
		
		protected function get simpleFacade():SimpleFacade {
			var r:SimpleFacade = facade as SimpleFacade;
			if(r == null){
				throw Error(SimpleFacade.FACADE_ERROR);
			}
			return r;
		}
		
		protected function getServiceByName(serviceName:String):AbstractService {
			return simpleFacade.retrieveServiceByName(serviceName);
		}
		
		protected function getServiceByType(clazz:Class):AbstractService {
			return simpleFacade.retrieveServiceByType(clazz);
		}
		
		public function sendRawNotification(notification:INotification):void {
			facade.notifyObservers(notification);
		}
		
		public function sendTimeoutNotification(delay:Number, notificationName:String, body:Object=null, type:String=null):void {
			setSimpleTimeout(sendNotification, delay, notificationName, body, type);
		}

	}
}