package com.netease.webgame.core.net
{
	import com.netease.webgame.core.events.NetEvent;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.ObjectEncoding;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class NetSocket extends Socket
	{
		private static const STATE_HEADER:int = 0
		private static const STATE_CONTENT:int = 1;
		
		// 流量统计相关
		public static var sizeOut:Number = 0;
		public static var sizeIn:Number = 0;
		public static var sizeTotal:Number = 0;
		
		// recv state
		// 1. 4 bytes length - represents the content length
		// 2. n bytes content
		private var recv_state:int = STATE_HEADER;
		
		// 4 bytes length header
		private var header_length:int = 4;
		
		// 当前正在等待的内容总长度
		private var content_length:int = 0; 
		
		public function NetSocket( host:String, port:int )
		{
			//采用LITTLE_ENDIAN
			//endian = Endian.BIG_ENDIAN;
			addEventListener(Event.CONNECT, onConnected);
			addEventListener(IOErrorEvent.IO_ERROR, onSocketIOError);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketSecurityError);
			addEventListener(ProgressEvent.SOCKET_DATA, onRecvData);
			connect( host, port );
		}
		
		// send 4 bytes firstly which respresent content length
		// send content
		// flush immediately
		public function send( bytes:ByteArray ):void
		{
			sizeOut += bytes.length;
			sizeTotal += bytes.length;
			//write length
			var len:int =bytes.length;	
			writeInt(len);
			//write content
			writeBytes( bytes );
			// flush every send request immediately
			flush();
		}
		
		// 收到一个完整的协议包
		private function onGetPacket( bytes:ByteArray ):void
		{
			sizeIn += bytes.length;
			sizeTotal += bytes.length;
			var event:NetEvent = new NetEvent(NetEvent.ON_GET_PACKET, this, bytes);
			dispatchEvent( event );
		}
		
		private function onRecvData( e:ProgressEvent ):void{
			//trace("onRecvData");
			do{
				//报文头
				if( recv_state == STATE_HEADER ){
					//无效socket
					if( !bytesAvailable){
						return;
					}
					//如果长度不够
					if(  bytesAvailable < header_length ){
						return;
					}
					content_length = readInt();
					recv_state = STATE_CONTENT;
					continue;
				}
				else{ //报文内容
					// we use the first bit of the len to idendity if the packet is 
					// compressed. 
					var body_len:int = content_length & 0x7FFFFFFF;
					//trace(body_len, content_length);
					if( bytesAvailable < body_len )
					{
						return;
					}
					var bytes:ByteArray = new ByteArray();
					bytes.objectEncoding = 3;
					readBytes( bytes, 0, body_len );
					if ( content_length & 0x80000000 ){
						//trace("do uncompress.");
						bytes.uncompress();
					}
					
					onGetPacket( bytes );
					recv_state = STATE_HEADER;
					continue;
				}
			}while( true );
			
		}
		
		private function onConnected( e:Event ):void{
			dispatchEvent(new NetEvent(NetEvent.ON_CONNECT));
		} 
		
		private function onSocketIOError( e:ErrorEvent ):void{
			dispatchEvent(new NetEvent(NetEvent.ON_CONNECT_ERROR));
		}
		private function onSocketSecurityError( e:ErrorEvent ):void{
			dispatchEvent(new NetEvent(NetEvent.ON_CONNECT_ERROR));
		}
		
	}
}