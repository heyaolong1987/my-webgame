package com.netease.flash.common.socket {
	import flash.utils.ByteArray;
	
	/**
	 * message interface
	 * 
	 * @author bezy
	 * 
	 */
	public interface IMessage {
		
		/**
		 * 将消息打包成字节
		 * 
		 * @param bytes
		 * 
		 */
		function marshal(bytes:ByteArray):void;
				
		/**
		 * 将字节解包成消息
		 * 
		 * @param bytes
		 * 
		 */
		function unmarshal(bytes:ByteArray):void;

	}
}