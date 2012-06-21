package com.netease.flash.common.rpc.meta {
	
	import com.netease.flash.common.socket.AbstractMessage;
	
	import flash.utils.ByteArray;

	/**
	 * amf login message
	 *  
	 * @author bezy
	 * 
	 */
	public class AmfLogin extends AbstractMessage {
		public static const HEADER:uint = 0x0002;
	
		private var _uid:String;
		private var _sid:String;
		private var _version:String;
		private var _attachment:Object;
		
		public function AmfLogin() {
			super(HEADER);
		}
		
		public function set uid(v:String):void {
			this._uid = v;
		}
		
		public function get uid():String {
			return this._uid;
		}
		
		public function set sid(v:String):void {
			this._sid = v;
		}
		
		public function get sid():String {
			return this._sid;
		}
		
		public function set version(v:String):void {
			this._version = v;
		}
		
		public function get version():String {
			return this._version;
		}
		
		public function set attachment(v:Object):void {
			this._attachment = v;
		}
		
		public function get attachment():Object {
			return this._attachment;
		}
		
		protected override function marshalBody(bytes:ByteArray):void {
			bytes.writeUTF(defaultString(this._uid));
			bytes.writeUTF(defaultString(this._sid));
			bytes.writeUTF(defaultString(this._version));
			bytes.writeObject(this._attachment);
		}

		protected override function unmarshalBody(bytes:ByteArray):void {
			this._uid = bytes.readUTF();
			this._sid = bytes.readUTF();
			this._version = bytes.readUTF();
			this._attachment = bytes.readObject();
		}
	}
}