package com.netease.flash.common.socket {
	import flash.utils.ByteArray;
	
	/**
	 * heart message
	 * 
	 * @author bezy
	 * 
	 */
	public class HeartMessage extends AbstractMessage {
		public static const HEADER:uint = 0x0000;
		public static const REQUEST:uint = 0x0000;
		public static const RESPONSE:uint = 0x0001;
		
		private var _type:uint;

		public function HeartMessage() {
			super(HEADER);
		}
		
		public function get type():uint {
			return this._type;
		}
		
		public function set type(v:uint):void {
			this._type = v;
		}
		
		protected override function marshalBody(bytes:ByteArray):void {
			bytes.writeShort(_type);
		}
		
		protected override function unmarshalBody(bytes:ByteArray):void {
			_type = bytes.readShort();
		}
		
	}
}