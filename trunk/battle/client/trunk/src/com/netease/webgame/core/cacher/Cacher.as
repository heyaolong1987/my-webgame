package com.netease.webgame.core.cacher{
	import com.netease.webgame.core.constants.CacheMode;
	import com.netease.webgame.core.interfaces.ICCacher;
	
	import flash.system.System;
	import flash.utils.Dictionary;
	
	/**
	 *
	 *@author heyaolong
	 *
	 *2011-10-14
	 */
	public class Cacher implements ICCacher{
		private var _maxCacheNum:int=0;
		private var _nowCacheNum:int=0;
		private var _cacheMode:int=CacheMode.NOT_CACHE_ON_FULL;
		private var _dic:Dictionary = new Dictionary();
		private static var _instance:Cacher
		public function Cacher()
		{
		}
		public static function getInstance():Cacher{
			if(_instance==null){
				_instance = new Cacher();
			}
			return _instance;
		}
		/**
		 *设置最大缓存数 
		 * @param value
		 * 
		 */
		public function set maxCacheNum(value:int):void{
			_maxCacheNum = value;
		}
		/**
		 * 获取最大缓存数
		 * @return 
		 * 
		 */
		public function get maxCacheNum():int{
			return _maxCacheNum;
		}
		/**
		 *设置最大缓存数 
		 * @param value
		 * 
		 */
		public function set nowCacheNum(value:int):void{
			_nowCacheNum = value;
		}
		/**
		 * 获取最大缓存数
		 * @return 
		 * 
		 */
		public function get nowCacheNum():int{
			return _nowCacheNum;
		}
		/**
		 * 获取缓存的方式，0：缓存满，不再缓存，1:缓存满，删除获取频率最低得那个，2：缓存满，删除最早缓存的那个,3:缓存满，不缓存获取次数最少的那个,
		 * @param value
		 * 
		 */
		public function set cacheMode(value:int):void{
			_cacheMode = value;
		}
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get cacheMode():int{
			return _cacheMode;
		}
		
		/**
		 *缓存一个对象
		 * @param key
		 * @param obj
		 * 
		 */
		public function cacheObject(key:Object,obj:Object):Boolean{
			_dic[key] = {obj:obj,time:new Date().getMilliseconds(),times:0};
			return true;
		}
		/**
		 *获取一个缓存对象 
		 * @param key
		 * @return 
		 * 
		 */
		public function getObject(key:Object):Object{
			var t:Object = _dic[key]; 
			if(t){
				return t.obj;
			}
			return null;
		}
		public function getRandomObject():Object{
			for each(var item:Object in _dic){
				return item;
			}
			return null;
		}
		public function getObjectByType(cls:Class):Object{
			for each(var item:Object in _dic){
				if(item instanceof cls){
					return item;
				}
			}
			return null;
		}
		public function deleteObject(key:Object):Object{
			var cache:Object = _dic[key];
			if(cache){
				_dic[key] = null;
				delete _dic[key];
				return cache.obj;
			}
			return null;
		}
		public function clear():void{
			_dic = new Dictionary();
		}
	}
}