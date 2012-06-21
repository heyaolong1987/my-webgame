package com.netease.flash.common.lang {
	
	import flash.utils.Dictionary;
	
	/**
	 * a pool use lru method
	 *  
	 * @author bezy
	 */
	public class LRUResPool {
		
		private var cacheSize:int;
		private var keyQueue:Array = [];
		private var cache:Dictionary = new Dictionary();
				
		public function LRUResPool(size:int = 1000) {
			this.cacheSize = size;
		}
		
		public function putObject(key:*,value:*):Boolean {
			if(key == null || value == null){
				return false;
			}
			if(cache[key] != null){
				removeKey(key);
			}
			addKey(key);
			cache[key] = value;
			if(keyQueue.length > cacheSize) {
				delete cache[keyQueue.shift()];
			}
			return true;
		}
		
		public function getObject(key:*):* {
			if(key == null){
				return null;
			}
			var o:* = cache[key];
			if(o != null){
				removeKey(key);				
				addKey(key);
			}
			return o;
		}
		
		public function deleteObject(key:*):void {
			if(key == null){
				return;
			}
			if(cache[key] != null){
				removeKey(key);
				delete cache[key];
			}
		}
		
		public function clear():void {
			var key:*;
			for(key in cache){
				delete cache[key];
			}
			keyQueue = [];
		}
		
		public function getSize():int {
			return keyQueue.length;
		}
		
		private function removeKey(key:*):void {
			var index:int = keyQueue.indexOf(key);
    	 	if(index > -1){
    	 		keyQueue.splice(index,1);
    	 	}
		}
		
		private function addKey(key:*):void {
			keyQueue.push(key);
		}
				
	}
}