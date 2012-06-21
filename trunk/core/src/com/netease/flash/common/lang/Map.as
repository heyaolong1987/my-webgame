package com.netease.flash.common.lang {
	import flash.utils.Dictionary;
	
	
	/**
	 * map like java map
	 *  
	 * @author bezy
	 * 
	 */
	public class Map {
		private var _keys:Array;
		private var _cache:Dictionary;
		
		public function Map() {
			clear();
		}
		
		public function clear():void {
			this._keys = [];
			this._cache = new Dictionary();
		}
		
		public function containsKey(key:*):Boolean {
            return !(this._cache[key] === undefined);
        }
        
       	public function containsValue(value:*):Boolean {
           var r:Boolean = false;
           var len:uint = this.size();
           if(len > 0) {
               for(var i:uint = 0; i < len; ++i) {
               		if(this._cache[this._keys[i]] == value){
               			return true;
               		}
               }
           }
           return false;
       }
		
		public function getValue(key:*):* {
            return this._cache[key];
        }        

        public function putValue(key:*, value:*):* {
            var r:* = null;
            if(this.containsKey(key)) {
               r = this._cache[key];
               this._cache[key] = value;
            }else {
               this._cache[key] = value;
               this._keys.push(key);
            }
            return r;  
        }
        
        public function putAll(map:Map):void {
        	var keys:Array = map.keys();
        	for each(var key:* in keys){
        		this.putValue(key,map.getValue(key));
        	}
        }
        
        public function size():uint {
        	return this._keys.length;
        }
        
        public function remove(key:*):* {
        	 var r:* = null;
        	 if(this.containsKey(key)) {
               	r = this._cache[key];
        	 	delete this._cache[key];
        	 	var index:int = this._keys.indexOf(key);
        	 	if(index > -1){
        	 		this._keys.splice(index,1);
        	 	}
        	 }
        	 return r;
        }
        
        public function isEmpty():Boolean {
        	return this.size() < 1;
        }
        
        public function keys():Array {
        	return this._keys;
        }
        
        public function values():Array {
			var r:Array = [];
			var len:uint = this.size();
			if(len > 0){
				for(var i:uint = 0; i < len; ++i) {
					r.push(this._cache[this._keys[i]]);
				}
			}
			return r;
        }
        
        public function entries():Array {
			var r:Array = [];
			var len:uint = this.size();
			if(len > 0){
				for(var i:uint = 0; i < len; ++i) {
					r.push(new Pair(this._keys[i],this._cache[this._keys[i]]));
				}
			}
			return r;        	
        }
        
        public function toString():String {
        	var r:String = "";
        	var len:uint = this.size();
        	for(var i:uint = 0; i < len; ++i){
        		r += this._keys[i] + ":" + this._cache[this._keys[i]] + "\n";
        	}
        	return r;
        }
        
	}
}