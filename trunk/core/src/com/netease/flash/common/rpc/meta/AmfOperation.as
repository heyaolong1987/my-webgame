package com.netease.flash.common.rpc.meta {
	
	import com.netease.flash.common.socket.AbstractMessage;
	
	import flash.utils.ByteArray;
	
	/**
	 * amf operation wrap 
	 * @author bezy
	 * 
	 */
	public class AmfOperation extends AbstractMessage {
		public static const HEADER:uint = 0x0003;
		
		private var _op:String;
		private var _callbackOp:String
		private var _params:Array;
		
		public function AmfOperation(op:String=null, params:Array=null) {
			super(HEADER);
			this._op = op;
			this._params = params;
		}
		
		public function set op(v:String):void {
			this._op = v;
		}
		
		public function get op():String {
			return this._op;
		}
		
		public function set callbackOp(v:String):void {
			this._callbackOp = v;
		}
		
		public function get callbackOp():String {
			return this._callbackOp;
		}
		
		public function set params(v:Array):void {
			this._params = v;
		}
		
		public function get params():Array {
			return this._params;
		}
		
		protected override function marshalBody(bytes:ByteArray):void {
			bytes.writeUTF(defaultString(this._op));
			bytes.writeUTF(defaultString(this._callbackOp));
			bytes.writeObject(this._params);
		}

		protected override function unmarshalBody(bytes:ByteArray):void {
			this._op = bytes.readUTF();
			this._callbackOp = bytes.readUTF();
			this._params = bytes.readObject();	
		}
	}
}