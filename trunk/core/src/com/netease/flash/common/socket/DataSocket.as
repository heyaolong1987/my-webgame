package com.netease.flash.common.socket {
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	/**
	 * data socket(socket wrap)
	 * 
	 * @author bezy
	 * 
	 */
	public class DataSocket extends Socket {
		public static const DATA_RECEIVE:String = "DATA_RECEIVE";
		
		private var _prefixLen:int;
		private var _curHeadLen:uint = 0;
		private var _isReadHead:Boolean = true;
		
		private var _revDataList:Array;
		
		private var _msgCodec:IMsgCodec;		
		
		public function DataSocket(host:String=null, port:int=0, prefixLen:int=2) {
			super(host, port);
			this._prefixLen = prefixLen;
			if(this._prefixLen != 1 && this._prefixLen != 2 && this._prefixLen != 4) {
				throw new Error("prefix length must be 1 or 2 or 4");
			}
			this._revDataList = [];
	        addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		public function set mgCodec(codec:IMsgCodec):void {
			this._msgCodec = codec;
		}
		
		public function sendBytes(bytes:ByteArray):void {
			if(!connected){
				trace('[sendBytes] socket hasn\'t open!');	
				return;
			}
			encryptMsg(bytes);
			switch(this._prefixLen){
				case 1:
					writeByte(bytes.length);
					break;
				case 2:
					writeShort(bytes.length);
					break;
				case 4:
					writeInt(bytes.length);
					break;
			}
			writeBytes(bytes);
			flush();
		}
		
		public function get revDataList():Array {
			return _revDataList;
		}
		
		public function get curRevData():ByteArray {
			return _revDataList[0];
		}
		
		public function shiftRevData():ByteArray {
			return _revDataList.shift() as ByteArray;
		}
		
		public static function getDataHeader(bytes:ByteArray, headerLen:int = 2):uint {
			var h:uint;
			switch(headerLen) {
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
					throw new Error("header length must be 1 or 2 or 4");
					break;
			}
			bytes.position = bytes.position - headerLen;
			return h;
		}
		
		private function encryptMsg(bytes:ByteArray):void {
			if(_msgCodec) {
				_msgCodec.encryptMsg(bytes);
			}
		}
		
		private function decryptMsg(bytes:ByteArray):void {			
			if(_msgCodec) {
				_msgCodec.decryptMsg(bytes);
			}
		}
		
	    private function socketDataHandler(event:ProgressEvent):void {
        	parseData();
	    }
	    
	    private function parseData():void {
        	if(!connected) {
				trace('[parseData] socket has closed!');
				return;	        	
        	}
        	
        	if(this._isReadHead) {
	        	if(bytesAvailable < this._prefixLen) {
	        		return;
	        	}
	        	//读取头
	        	switch(this._prefixLen) {
	        		case 1:
	        			this._curHeadLen = readUnsignedByte();
	        			break;
	        		case 2:
	        			this._curHeadLen = readUnsignedShort();
	        			break;
	        		case 4:
	        			this._curHeadLen = readInt();
	        			break;
	        	}
	        	if(this._curHeadLen > 0){
		        	this._isReadHead = false;
	        	}
        	}
        	
        	if(!this._isReadHead && bytesAvailable >= this._curHeadLen) {
        		//读取内容
        		var bytes:ByteArray = new ByteArray();
        		readBytes(bytes, 0, this._curHeadLen);
        		decryptMsg(bytes);
        		this._revDataList.push(bytes);
        		
        		this._isReadHead = true;
        		        		
        		//读出数据发送事件
				dispatchEvent(new Event(DATA_RECEIVE));
        	}
        	
        	if(connected && this._isReadHead && bytesAvailable >= this._prefixLen) {
        		//还有数据，则继续解析
        		parseData();
        	}
	    }
		
	}
}