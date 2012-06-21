package com.netease.flash.common.rpc {
	
	import flash.events.Event;

	/**
	 * login event 
	 * @author bezy
	 * 
	 */
	public class LoginEvent extends Event {
		
		public static const LOGIN:String = "LOGIN";
		
		public static const RESULT_OK:int = 1;
		public static const RESULT_FAIL:int = 0;
		public static const RESULT_VERSION_FAIL:int = -1;
		public static const RESULT_AUTH_FAIL:int = -2;		

		private var _result:int;
		private var _attachment:Object;
		
		public function LoginEvent(result:int, attachment:Object=null) {
			super(LOGIN);
			this._result = result;
			this._attachment = attachment;
		}
		
		public function get result():int {
			return this._result;
		}
		
		public function get attachment():Object {
			return this._attachment;
		}
	}
}