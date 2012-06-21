package com.netease.flash.common.socket {
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * abstract message
	 * 
	 * @author bezy
	 * 
	 */
	public class AbstractMessage implements IMessage {
				
		private var _header:uint;
		private var _headerLen:int;
		
		public function AbstractMessage(header:uint, len:int = 2) {
			this._header = header;
			this._headerLen = len;
			if(this._headerLen != 1 && this._headerLen != 2 && this._headerLen != 4) {
				throw new Error("head length must be 1 or 2 or 4");
			}
		}
		
		public function get header():uint {
			return this._header;
		}
		
		public function getHeaderSize():int {
			return this._headerLen;
		}
		
		public function marshal(bytes:ByteArray):void {
			switch(this._headerLen) {
				case 1:
					bytes.writeByte(this._header);
					break;
				case 2:
					bytes.writeShort(this._header);
					break;
				case 4:
					bytes.writeInt(this._header);
					break;
				default:
					throw new Error("head length must be 1 or 2 or 4");
			}
			
			marshalBody(bytes);		
		}
		
		public function unmarshal(bytes:ByteArray):void {
			if(bytes.bytesAvailable == 0){
				return;
			}
			
			var h:uint;
			switch(this._headerLen) {
				case 1:
					h = bytes.readUnsignedByte();
					break;	
				case 2:
					h = bytes.readUnsignedShort();
					break;
				case 4:
					h = bytes.readInt();
					break;
				default:
					throw new Error("head length must be 1 or 2 or 4");					
			}
			if(h != this._header){
				throw new Error("head type error! need: " + this._header + " but: " + h);
			}
			
			unmarshalBody(bytes);
		}
		
		/**
		 * 具体处理消息的内容，子类需要重写该方法
		 * 
		 * @param bytes
		 * 
		 */
		protected function marshalBody(bytes:ByteArray):void {
			
		}
		
		/**
		 * 从消息的内容中解析数据
		 * 
		 * @param bytes
		 * 
		 */
		protected function unmarshalBody(bytes:ByteArray):void {
			
		}
		
		protected function defaultString(v:String,d:String=""):String {
			return v!=null?v:d;
		}
	}
}