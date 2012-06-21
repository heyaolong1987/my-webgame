package com.netease.flash.framework.ROService {
	import flash.utils.Dictionary;
	
	import mx.rpc.remoting.RemoteObject;
	
	public class RORemoteService extends AbstractRemoteService {
		public function RORemoteService() {
			
		}
		
      	/**
      	 * Register all RemoteObjects in serviceLocator.
      	 */ 
      	override public function register(serviceLocator:IServiceLocator):void {
      		var accessors : XMLList = getAccessors(serviceLocator);
         	
         	for (var i:uint = 0; i < accessors.length(); i++) {
            	var name:String = accessors[i];
            	var obj:Object = serviceLocator[name];
            
	            if (obj is RemoteObject) {
	            	services[name] = obj;
	            }
			}
      	}
	}
}