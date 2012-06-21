package com.netease.flash.common.rpc.meta {
	
	import com.netease.flash.common.socket.AbstractMessage;
	
	import flash.utils.ByteArray;
	
	/**
	 * amf op code
	 * @author bezy
	 * 
	 */
	public class AmfOpCode extends AbstractMessage {
		public static const HEADER:uint = 0x0001;
		
		private var _opCode:int;
		private var _attachment:Object;
		
		public function AmfOpCode() {
			super(HEADER);
		}
		
		public function get opCode():int {
			return this._opCode;
		}
		
		public function get attachment():Object {
			return this._attachment;
		}
		
		protected override function marshalBody(bytes:ByteArray):void {
			bytes.writeShort(this._opCode);
			bytes.writeObject(this._attachment);
		}

		protected override function unmarshalBody(bytes:ByteArray):void {
			this._opCode = bytes.readShort();
			this._attachment = bytes.readObject();	
		}
	}
}