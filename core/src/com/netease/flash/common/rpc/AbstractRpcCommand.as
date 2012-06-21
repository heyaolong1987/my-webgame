package com.netease.flash.common.rpc {
	
	/**
	 * 
	 * @author bezy
	 * 
	 */
	public class AbstractRpcCommand implements RpcListener{
		protected var _requestOp:String;
		protected var _requestParams:Array;
		
		public function AbstractRpcCommand(requestOp:String=null, requestParams:Array=null) {
			this._requestOp = requestOp;
			this._requestParams = requestParams;
		}
		
		public function set requestOp(v:String):void {
			this._requestOp = v;
		}
		
		public function get requestOp():String {
			return this._requestOp;
		}
		
		public function set requestParams(v:Array):void {
			this._requestParams = v;
		}
		
		public function get requestParams():Array {
			return this._requestParams;
		}
		
		public function resultHandler(data:Array):void {
			trace("[AmfRpc] RpcCommand resultHandler " + _requestOp + " need to be overried!");
		}
		
		public function onRpcEvent(params:Array):void {
			resultHandler(params);
		}
		
	}
	
}