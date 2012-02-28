package com.netease.webgame.core.events{
	import com.netease.webgame.core.net.NetSocket;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class NetEvent extends Event{
		public static const ON_GET_PACKET:String = "onGetPacket";
		public static const ON_CONNECT:String = "onConnect";
		public static const ON_CONNECT_ERROR:String = "onConnectERROR";
		public var socket:NetSocket;
		public var packet:ByteArray;
		public function NetEvent(name:String, socket:NetSocket = null, packet:ByteArray = null, 
								 bubbles:Boolean = false, cancelable:Boolean = false):void{
			super(name, bubbles, cancelable );
			this.packet = packet;
			this.socket = socket;
		}
		
		override public function clone() : Event{
			return new NetEvent(this.type, socket, packet, this.bubbles, this.cancelable);
		}
	}
}