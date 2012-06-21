package com.netease.flash.common.rpc {
	
	import com.adobe.utils.StringUtil;
	import com.netease.flash.common.rpc.meta.AmfLogin;
	import com.netease.flash.common.rpc.meta.AmfLoginResult;
	import com.netease.flash.common.rpc.meta.AmfOpCode;
	import com.netease.flash.common.rpc.meta.AmfOperation;
	import com.netease.flash.common.rpc.meta.AmfOperationResult;
	import com.netease.flash.common.socket.MessageDataSocket;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * amf rpc client
	 *  
	 * @author bezy
	 * 
	 */
	public class AmfRpcClient extends MessageDataSocket {
		
		private const CALLBACK_PREFIX:String = "_$$_cb_";
		private const callbackDictionary:Dictionary = new Dictionary();
		private const listenerDictionary:Dictionary = new Dictionary();
		private var callbackIdx:Number = 0;
		
		private var host:String;
		private var port:int;
		private var _isLogin:Boolean = false;
		private var amfLogin:AmfLogin = null;
		
		public function AmfRpcClient(host:String=null, port:int=0) {
			super();
			
			this.host = host;
			this.port = port;			
			addEventListener(Event.CONNECT, connectHandler);
			addEventListener(Event.CLOSE, closeHandler);
		}
		
		public function setServer(host:String, port:int):void {
			this.host = host;
			this.port = port;
		}
		
		/**
		 * invoke server rpc
		 *  
		 * @param op
		 * @param params
		 * @param callback
		 * 
		 */
		public function invokeRpc(op:String, params:Array, callback:Function=null):void {
			if(!isLogin) {
				trace("[AmfRpc] need login first!");
				return;
			}
			
			var amfRequest:AmfOperation = new AmfOperation(op, params);
			invoke1(amfRequest, callback);
		}
		
		/**
		 * invoke server rpc
		 *  
		 * @param op
		 * @param params
		 * @param callback
		 * 
		 */
		public function invokeRpcCall(op:String, params:Array, callback:RpcListener = null):void {
			if(!isLogin) {
				trace("[AmfRpc] need login first!");
				return;
			}
			
			var amfRequest:AmfOperation = new AmfOperation(op, params);
			invoke2(amfRequest, callback);
		}
		
		/**
		 * invoke server rpc
		 *  
		 * @param rpcCommand
		 * 
		 */
		public function invokeRpcCommand(rpcCommand:AbstractRpcCommand):void {
			if(!isLogin) {
				trace("[AmfRpc] need login first!");
				return;
			}
			
			var amfRequest:AmfOperation = new AmfOperation(rpcCommand.requestOp, rpcCommand.requestParams);
			invoke2(amfRequest, rpcCommand);
		}
		
		private function invoke1(amfRequest:AmfOperation, callback:Function):void {
			if(callback != null) {
				amfRequest.callbackOp = CALLBACK_PREFIX + (++callbackIdx);
			}
			sendMessage(amfRequest);
			if(callback != null) {
				callbackDictionary[amfRequest.callbackOp] = new MethodRpcListener(amfRequest.callbackOp, callback); 
			}
		}
		
		private function invoke2(amfRequest:AmfOperation, callback:RpcListener):void {
			if(callback != null) {
				amfRequest.callbackOp = CALLBACK_PREFIX + (++callbackIdx);
			}
			sendMessage(amfRequest);
			if(callback != null) {
				callbackDictionary[amfRequest.callbackOp] = callback;
			}
		}		
		
		/**
		 * add client rpc listener
		 *  
		 * @param op
		 * @param listener
		 * 
		 */
		public function addRpcListener(op:String, listener:Function):void {
			if(listener != null) {
				var rpcListener:RpcListener = new MethodRpcListener(op, listener);
				listenerDictionary[op] = rpcListener;
			}
		}
		
		public function removeRpcListener(op:String, listener:Function):void {
			var rpcListener:MethodRpcListener = listenerDictionary[op] as MethodRpcListener;
			if(rpcListener != null && rpcListener.method == listener) {
				delete listenerDictionary[op];
			}
		}
		
		/**
		 * add client rpc listener
		 *  
		 * @param op
		 * @param listener
		 * 
		 */		
		 public function addRpcCallListener(op:String, listener:RpcListener): void {
			if(listener != null) {
				listenerDictionary[op] = listener;
			}
		}
		
		public function removeRpcCallListener(op:String, listener:RpcListener):void {
			var rpcListener:RpcListener = listenerDictionary[op] as RpcListener;
			if(rpcListener != null && rpcListener == listener) {
				delete listenerDictionary[op];
			}
		}
		
		/**
		 * login the rpc server
		 *  
		 * @param uid
		 * @param sid
		 * @param version
		 * @param attachment
		 * 
		 */
		public function login(uid:String, sid:String, version:String="", attachment:Object=null):void {
			_isLogin = false;
			
			amfLogin = new AmfLogin();
			amfLogin.uid = uid;
			amfLogin.sid = sid;
			amfLogin.version = version;
			amfLogin.attachment = attachment;
			connect(host, port);
		}
		
		public function logout():void {
			if(connected) {
				close();
			}
			blur();
		}
		
		public function get isLogin():Boolean {
			return connected && this._isLogin;
		}
		
		private function connectHandler(e:Event):void {
			if(amfLogin != null) {
				sendMessage(amfLogin);
			}
		}
		
		private function closeHandler(e:Event):void {
			blur();
		}
		
		private function blur():void {
			_isLogin = false;
			amfLogin = null;
			
			for(var op:* in callbackDictionary) {
				delete callbackDictionary[op];
			}
			callbackIdx = 0;			
		}
		
		protected override function decodeMessage(header:uint, bytes:ByteArray):void {			
			if(header == AmfOpCode.HEADER) {
				var amfOpCode:AmfOpCode = new AmfOpCode();
				amfOpCode.unmarshal(bytes);
				
				dispatchEvent(new OpCodeEvent(amfOpCode.opCode, amfOpCode.attachment));					
			} else if(header == AmfLoginResult.HEADER) {
				var loginResult:AmfLoginResult = new AmfLoginResult();
				loginResult.unmarshal(bytes);
				
				dispatchEvent(new LoginEvent(loginResult.result, loginResult.attachment));
				_isLogin = (loginResult.result == LoginEvent.RESULT_OK);
				if(!_isLogin) {
					logout();
				}
			} else if(header == AmfOperationResult.HEADER) {
				if(!isLogin) {
					trace("[AmfRpc] need login first!");
					return;
				}				
				var amfResult:AmfOperationResult = new AmfOperationResult();
				amfResult.unmarshal(bytes);
				
				if(amfResult.error) {
					if(amfResult.callback) {
						delete callbackDictionary[amfResult.op];
					}
					trace("[AmfRpc] amf rpc listener " + amfResult.op + " exception for server error!" + amfResult.throwable);					
					return;
				}
				var rpcListener:RpcListener;
				if(amfResult.callback) {
					rpcListener = callbackDictionary[amfResult.op] as RpcListener;
					delete callbackDictionary[amfResult.op];
				} else {
					rpcListener = listenerDictionary[amfResult.op] as RpcListener;
				}
				if(rpcListener == null) {
					trace("[AmfRpc] unknown amf listener: " + amfResult.op);
					return;
				}
				rpcListener.onRpcEvent(amfResult.params);
			}			
		}
		
	}
	
}