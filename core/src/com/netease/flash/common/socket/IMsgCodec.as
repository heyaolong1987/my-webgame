package com.netease.flash.common.socket {
	
	import flash.utils.ByteArray;
	
	
	/**
	 * message codecs interface
	 * 
	 * @author bezy
	 * 
	 */
	public interface IMsgCodec {
		function encryptMsg(bytes:ByteArray):void;
		
		function decryptMsg(bytes:ByteArray):void;
	}
}