package com.netease.flash.common.socket {
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	/**
	 * message data socket(socket message wrap)
	 * 
	 * @author bezy
	 * 
	 */
	public class MessageDataSocket extends DataSocket {
		
		public function MessageDataSocket(host:String=null, port:int=0, prefixLen:int=2) {
			super(host, port, prefixLen);
			addEventListener(DataSocket.DATA_RECEIVE, dataHandler);
		}
		
		public function sendMessage(msg:IMessage):void {
			if(!connected){
				trace('[sendMessage] socket hasn\'t open!');
				return;	
			}
			var bytes:ByteArray = new ByteArray();
			bytes.endian = endian;
			msg.marshal(bytes);
			sendBytes(bytes);
		}
		
		/**
		 * heart
		 */
		public function heart():void {
			var request:HeartMessage = new HeartMessage();
			request.type = HeartMessage.REQUEST;
			sendMessage(request);
		}
		
		public function curRevMsg(msg:IMessage):void {
			var bytes:ByteArray = curRevData;
			msg.unmarshal(bytes);
		}
		
		public function shiftRevMsg(msg:IMessage):void {
			var bytes:ByteArray = shiftRevData();
			msg.unmarshal(bytes);
		}
		
		private function dataHandler(e:Event):void {
			var bytes:ByteArray = shiftRevData();
			var header:uint = getDataHeader(bytes);
			var message:IMessage;
			if(header == HeartMessage.HEADER) {
				message = new HeartMessage();
				message.unmarshal(bytes);
				if(HeartMessage(message).type == HeartMessage.REQUEST) {
					var response:HeartMessage = new HeartMessage();
					response.type = HeartMessage.RESPONSE;
					sendMessage(response);
				}
			}else {
				decodeMessage(header, bytes);
			}
		}
		
		protected function decodeMessage(header:uint, bytes:ByteArray):void {
			
		}
		
	}
	
}