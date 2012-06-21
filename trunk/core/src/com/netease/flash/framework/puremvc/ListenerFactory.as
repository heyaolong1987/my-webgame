package com.netease.flash.framework.puremvc {
	import com.netease.flash.common.lang.Map;
	
	/**
	 * listener map factory 
	 * @author bezy
	 * 
	 */
	public class ListenerFactory {
		private var listeners:Map;
		
		public function ListenerFactory() {
			listeners = new Map();
		}
		
		public function addListener(name:String, listener:Function):void {
			listeners.putValue(name, listener);
		}
		
		internal function keys():Array {
			return listeners.keys();
		}
		
		internal function getListener(name:String):Function {
			return listeners.getValue(name) as Function;
		}
		
		internal function clear():void {
			listeners.clear();
		}
	}
	
}