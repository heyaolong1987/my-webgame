package com.netease.flash.common.rpc.meta {
	
	import com.netease.flash.common.socket.AbstractMessage;
	
	import flash.utils.ByteArray;

	/**
	 * amf login result
	 *  
	 * @author bezy
	 * 
	 */
	public class AmfLoginResult extends AbstractMessage {
		public static const HEADER:uint = 0x0002;
	
		private var _uid:String;
		private var _result:int;
		private var _attachment:Object;
		
		public function AmfLoginResult() {
			super(HEADER);
		}
		
		public function get uid():String {
			return this._uid;
		}
		
		public function get result():int {
			return this._result;
		}
		
		public function get attachment():Object {
			return this._attachment;
		}
		
		protected override function marshalBody(bytes:ByteArray):void {
			bytes.writeUTF(defaultString(this._uid));
			bytes.writeShort(this._result);
			bytes.writeObject(this._attachment);
		}

		protected override function unmarshalBody(bytes:ByteArray):void {
			this._uid = bytes.readUTF();
			this._result = bytes.readShort();
			this._attachment = bytes.readObject();
		}
	}
}