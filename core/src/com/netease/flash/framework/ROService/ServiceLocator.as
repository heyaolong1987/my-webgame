package com.netease.flash.framework.ROService {
	import mx.rpc.AbstractOperation;
	import mx.rpc.AsyncToken;
	import mx.rpc.http.HTTPService;
	import mx.rpc.remoting.RemoteObject;
	
	
	public class ServiceLocator implements IServiceLocator {
		private static var instance:ServiceLocator;
		
		private static var _remoteObjectSer:RORemoteService;
		public function get remoteObjectSer():RORemoteService {
			if (_remoteObjectSer == null) {
				_remoteObjectSer = new RORemoteService();
				_remoteObjectSer.register(this);
			}
			return _remoteObjectSer;
		}
		public function set remoteObjectSer(value:RORemoteService):void
		{
			_remoteObjectSer = value;
		}
		private static var _httpSer:HttpRemoteService;
		public function get httpSer():HttpRemoteService {
			if (_httpSer == null) {
				_httpSer = new HttpRemoteService();
				_httpSer.register(this);
			}
			return _httpSer;
		}
		
		public static function getInstance():ServiceLocator {
	        if (instance == null) {
				instance = new ServiceLocator();
			}
            
			return instance;
		}
		
		public function ServiceLocator() {
			if (instance != null) {
				throw new Error("Only one ServiceLocator instance can be instantiated");
			}
            
			instance = this;
		}

		public function getRemoteObjectService(name:String):RemoteObject {
			if (remoteObjectSer.hasService(name)) {
				return remoteObjectSer.getService(name) as RemoteObject;
			}
			return null;
		}
		
		public function getHttpService(name:String):HTTPService {
			if (httpSer.hasService(name)) {
				return httpSer.getService(name) as HTTPService;
			}
			return null;
		}
		
		public function remoteObjectCall(name:String, method:String, responder:Responder):void {
			if (getRemoteObjectService(name) == null) {
				trace("Can not find any Remote Object with name: " + name);
				return;
			}
			
			var operation:AbstractOperation = getRemoteObjectService(name).getOperation(method);
			operation.arguments = responder.arguments;
			
			var token:AsyncToken = operation.send();
			
			token.resultHandler = responder.result;
            token.faultHandler = responder.fault;
		}
		
		public function HTTPCall(name:String, method:String, responder:Responder):void {
			if (getHttpService(name) == null) {
				trace("Can not find any Http Service with name: " + name);
				return;
			}
			
			var token:AsyncToken = getHttpService(name).send(responder.arguments);
			token.resultHandler = responder.result;
            token.faultHandler = responder.fault;
		}
		
	}
}