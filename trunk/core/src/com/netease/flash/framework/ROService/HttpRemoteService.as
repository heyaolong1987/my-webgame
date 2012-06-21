package com.netease.flash.framework.ROService {
	import mx.rpc.http.HTTPService;
	
	public class HttpRemoteService extends AbstractRemoteService {
		public function HttpRemoteService() {
		}
      	
      	/**
      	 * Register all RemoteObjects in serviceLocator.
      	 */ 
      	override public function register(serviceLocator:IServiceLocator):void {
         	var accessors : XMLList = getAccessors(serviceLocator);
         
	        for (var i:uint = 0; i < accessors.length(); i++ ) {
	            var name : String = accessors[ i ];
	            var obj : Object = serviceLocator[ name ];
	            
	            if (obj is HTTPService) {
					services[ name ] = obj;
				}
			}
      	}
	}
}