package com.netease.flash.common.rpc {
	
	import flash.events.Event;

	/**
	 * op code event
	 * @author bezy
	 * 
	 */
	public class OpCodeEvent extends Event {
		
		public static const OP_CODE:String = "OP_CODE";
		
		public static const RESULT_OP_SERVER_CLOSED:int = -1;
		public static const RESULT_OP_SERVER_BUSY:int = -2;
		public static const RESULT_OP_NOT_LOGIN:int = -3;
		public static const RESULT_OP_MAX_LOGIN_TRY:int = -4;
		public static const RESULT_OP_KICK_OUT_BY_SERVER:int = -5;
		public static const RESULT_OP_KICK_OUT_BY_RELOGIN:int = -6;
		public static const RESULT_OP_KICK_OUT_BY_CLOSED:int = -7;
		
		private var _opCode:int;
		private var _attachment:Object;
		
		public function OpCodeEvent(opCode:int, attachment:Object=null) {
			super(OP_CODE);
			this._opCode = opCode;
			this._attachment = attachment;
		}
		
		public function get opCode():int {
			return this._opCode;
		}
		
		public function get attachment():Object {
			return this._attachment;
		}
	}
}