package com.netease.flash.common.rpc {
	
	public class MethodRpcListener implements RpcListener {
				
		private var _operation:String;
		private var _method:Function;
		
		public function MethodRpcListener(operation:String, method:Function) {
			this._operation = operation;
			this._method = method;
		}
		
		public function get operation():String {
			return this._operation;
		}
		
		public function get method():Function {
			return this._method;
		}
		
		public function onRpcEvent(params:Array):void {
			this._method.apply(null, params);
		}
		
	}
}