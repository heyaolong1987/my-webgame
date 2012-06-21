package com.netease.webgame.core.net
{
	
	import com.netease.webgame.core.events.NetEvent;
	import com.netease.webgame.core.interfaces.ICPacketProgresser;
	import com.netease.webgame.core.model.vo.net.CallVO;
	import com.netease.webgame.core.model.vo.net.InceptVO;
	
	import flash.events.EventDispatcher;
	import flash.net.ObjectEncoding;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class NetEngine extends EventDispatcher
	{
		public static var URL:String;
		public static var PORT:int;
		
		private var _packetProgresser:ICPacketProgresser;
		public var callCounter:Object = {};
		private var _connecting:Boolean = false;
		// 服务端函数返回后的回调
		private var responderList:Array = new Array();
		
		private var netSocket:NetSocket = null;
		
		private var rpcRecord:Array = new Array();
		
		
		public function NetEngine(packetProgresser:ICPacketProgresser):void
		{
			this._packetProgresser = packetProgresser;
		}
		
		/**
		 *关闭连接 
		 * 
		 */
		public function close():void{
			if( netSocket && netSocket.connected ){
				netSocket.close();
				netSocket.removeEventListener(NetEvent.ON_GET_PACKET, onGetPacket);
				netSocket.removeEventListener(NetEvent.ON_CONNECT,onConnect);
				netSocket.removeEventListener(NetEvent.ON_CONNECT_ERROR,onConnectError);
				netSocket = null;
			}
		}
		/**
		 *连接成功 
		 * @return 
		 * 
		 */
		public function get connected():Boolean{
			return netSocket!=null&&netSocket.connected;
		}
		
		public function get connecting():Boolean{
			return _connecting;
		}
		public function connect(address:String,port:int):void{
			if(_connecting||connected){
				return;
			}
			_connecting = true;
			netSocket = new NetSocket(address, port);
			netSocket.addEventListener(NetEvent.ON_GET_PACKET, onGetPacket);
			netSocket.addEventListener(NetEvent.ON_CONNECT,onConnect);
			netSocket.addEventListener(NetEvent.ON_CONNECT_ERROR,onConnectError);
		}
		
		public function sendRespond( ...argArr ):void
		{
			var funcId:int = 0;
			var arr:Array = new Array();
			arr.push( funcId );
			arr.push( argArr );
			
			var bytes:ByteArray = new ByteArray();
			//bytes.endian = Endian.LITTLE_ENDIAN;
			bytes.objectEncoding = ObjectEncoding.AMF3;
			var obj:Object = new Object();
			//bytes.writeObject( obj );
			bytes.writeObject( arr );
			if( netSocket && netSocket.connected )
				netSocket.send( bytes );		
		}
		
		// call a remote function
		// responder can be set to null if u don't care about the remote function's return value
		public function call(callVO:CallVO):void{
			var bytes:ByteArray = new ByteArray();
			//bytes.endian = Endian.BIG_ENDIAN;
			bytes.objectEncoding = ObjectEncoding.AMF3;
			bytes.writeObject(callVO);
			if( netSocket && netSocket.connected )
				netSocket.send( bytes );
		}
		
		private function onConnect( e:NetEvent ):void {
			_connecting = false;
			dispatchEvent( new  NetEvent(NetEvent.ON_CONNECT));
		}
		
		private function onConnectError( e:NetEvent ):void {
			_connecting = false;
			dispatchEvent( new NetEvent(NetEvent.ON_CONNECT_ERROR) );
		}
		
		//got a complete packet, call the packethandler
		private function onGetPacket( e:NetEvent ):void
		{
			var newBuf:ByteArray = new ByteArray();
			e.packet.objectEncoding = ObjectEncoding.AMF3;
			var inceptVO:InceptVO = e.packet.readObject() as InceptVO;
			processRPC( inceptVO ); 
		}
		
		private function processRPC(inceptVO:InceptVO):void {
			var name:String = inceptVO.funcName;
			if( callCounter[name] ){
				callCounter[name] ++;
			} else {
				callCounter[name] = 1;
			}
			_packetProgresser.progress(inceptVO);
		}
	}
}