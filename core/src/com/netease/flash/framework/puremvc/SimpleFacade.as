package com.netease.flash.framework.puremvc {
	import com.netease.flash.common.log.Console;
	
	import flash.utils.getQualifiedClassName;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.facade.Facade;
	
	/**
	 * simple facade 
	 * @author bezy
	 * 
	 */
	public class SimpleFacade extends Facade {
		internal static const FACADE_ERROR:String = "must call SimpleFacade getInstance() before others!";
		 
		public static function getInstance():SimpleFacade {
			if (instance == null){
				instance = new SimpleFacade();
			}
			return instance as SimpleFacade;
		}
		
		public function registerMediatorByName(mediatorName:String, mediator:AbstractMediator):void {
			mediator.setMediatorName(mediatorName);
			if(hasMediator(mediatorName)) {
				Console.warn("register duplicate mediator by name: " + mediatorName);
			} else {
				//Console.debug("register mediator By name: " + mediatorName);
			}
			super.registerMediator(mediator);
		}
		
		public function registerMediatorByType(mediator:AbstractMediator):void {
			mediator.setMediatorName(getQualifiedClassName(mediator));
			if(hasMediator(mediator.getMediatorName())) {
				Console.warn("register duplicate mediator by type: " + mediator.getMediatorName());
			} else {
				//Console.debug("register mediator By type: " + mediator.getMediatorName());
			}
			super.registerMediator(mediator);
		}
		
		override public function registerMediator(mediator:IMediator):void {
			if(mediator is AbstractMediator) {
				AbstractMediator(mediator).setMediatorName(getQualifiedClassName(mediator));
			}
			if(hasMediator(mediator.getMediatorName())) {
				Console.warn("register duplicate mediator: " + mediator.getMediatorName());
			} else {
				//Console.debug("register mediator: " + mediator.getMediatorName());
			}
			super.registerMediator(mediator);
		}
		
		public function retrieveMediatorByName(mediatorName:String):AbstractMediator {
			return retrieveMediator(mediatorName) as AbstractMediator;
		}
		
		public function retrieveMediatorByType(clazz:Class):AbstractMediator {
			var name:String = getQualifiedClassName(clazz);
			return retrieveMediator(name) as AbstractMediator;
		}
		
		public function hasMediatorByType(clazz:Class):Boolean {
			var name:String = getQualifiedClassName(clazz);
			return hasMediator(name);
		}
		
		public function hasServiceByType(clazz:Class):Boolean {
			var name:String = getQualifiedClassName(clazz);
			return hasProxy(name);
		}
		
		public function registerServiceByName(serviceName:String,service:AbstractService):void {
			service.setServiceName(serviceName);
			if(hasProxy(serviceName)) {
				Console.warn("register duplicate service by name: " + serviceName);
			} else {
				//Console.debug("register service by name: " + serviceName);
			}
			super.registerProxy(service);
		}
		
		public function registerServiceByType(service:AbstractService):void {
			service.setServiceName(getQualifiedClassName(service));
			if(hasProxy(service.getProxyName())) {
				Console.warn("register duplicate service by name: " + service.getProxyName());
			} else {
				//Console.debug("register service by type: " + service.getProxyName());
			}
			super.registerProxy(service);
		}
		
		override public function registerProxy(proxy:IProxy):void {
			if(proxy is AbstractService) {
				AbstractService(proxy).setServiceName(getQualifiedClassName(proxy));
			}
			if(hasProxy(proxy.getProxyName())) {
				Console.warn("register duplicate proxy: " + proxy.getProxyName());
			} else {
				//Console.debug("register proxy: " + proxy.getProxyName());
			}
			super.registerProxy(proxy);
		}

		public function retrieveServiceByName(serviceName:String):AbstractService {
			return retrieveProxy(serviceName) as AbstractService;
		}
		
		public function retrieveServiceByType(clazz:Class):AbstractService {
			var name:String = getQualifiedClassName(clazz);
			return retrieveProxy(name) as AbstractService;
		}
		
		public function removeServiceByType(clazz:Class):IProxy {
			var name:String = getQualifiedClassName(clazz);
			//Console.debug("remove service by type: " + name);
			return removeProxy(name);
		}
		
		public function removeMediatorByType(clazz:Class):IMediator {
			var name:String = getQualifiedClassName(clazz);
			//Console.debug("remove mediator by type: " + name);
			return super.removeMediator(name);
		}
		
		override public function removeMediator(mediatorName:String):IMediator {
			//Console.debug("remove mediator by name: " + mediatorName);
			return super.removeMediator(mediatorName);
		}

	}
}