package com.netease.flash.common.lang {
	
	/**
	 * a pair implemention
	 *  
	 * @author bezy
	 * 
	 */
	public class Pair {
		private var _key:*;
		private var _value:*;
		
		public function Pair(k:* = null, v:* = null) {
			this._key = k;
			this._value = v;
		}
		
		public function get key():* {
			return this._key;
		}
		
		public function get value():* {
			return this._value;
		}
		
		public function set key(k:*):void {
			this._key = k;
		}
		
		public function set value(v:*):void {
			this._value = v;
		}
	}
	
}