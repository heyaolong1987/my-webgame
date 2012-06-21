package com.netease.flash.framework.ROService {
	import mx.rpc.remoting.RemoteObject;
	public interface IServiceLocator {
		function getRemoteObjectService(name:String):RemoteObject;
		
	}
	
}