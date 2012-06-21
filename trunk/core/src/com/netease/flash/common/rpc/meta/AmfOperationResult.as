package com.netease.flash.common.rpc.meta {
	
	import com.netease.flash.common.socket.AbstractMessage;
	
	import flash.utils.ByteArray;
	
	/**
	 * amf operation result 
	 * @author bezy
	 * 
	 */
	public class AmfOperationResult extends AbstractMessage {
		public static const HEADER:uint = 0x0003;
		
		private var _op:String;
		private var _callback:Boolean;
		private var _error:Boolean;
		private var _throwable:Object;
		private var _params:Array;
		
		public function AmfOperationResult() {
			super(HEADER);
		}
		
		public function get op():String {
			return this._op;
		}
		
		public function get callback():Boolean {
			return this._callback;
		}
		
		public function get error():Boolean {
			return this._error;
		}
		
		public function get throwable():Object {
			return this._throwable;
		}
		
		public function get params():Array {
			return this._params;
		}
		
		protected override function marshalBody(bytes:ByteArray):void {
			bytes.writeUTF(defaultString(this._op));
			bytes.writeBoolean(this._callback);
			bytes.writeBoolean(this._error);
			if(this._error) {
				bytes.writeObject(this._throwable);
			} else {
				bytes.writeObject(this._params);				
			}
		}

		protected override function unmarshalBody(bytes:ByteArray):void {
			this._op = bytes.readUTF();
			this._callback = bytes.readBoolean();
			this._error = bytes.readBoolean();
			if(this._error) {
				this._throwable = bytes.readObject();
			} else {
				this._params = bytes.readObject();
			}
		}
		
	}
}