package com.netease.webgame.core.view.vc.component {
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	public class RecycableFactory {
		
		private static var factoryMap:Dictionary = new Dictionary();
		
		private var cache:Array = new Array();
		private var cacheMap:Dictionary = new Dictionary();
		
		private var clazz:Class;
		
		private var newCount:int = 0;
		
		public function RecycableFactory(clazz:Class){
			this.clazz = clazz;
		}
		
		public static function getInstanceByDefinition(clazz:Class):RecycableFactory {
			var classname:String = getQualifiedClassName(clazz);
			var instance:RecycableFactory = factoryMap[classname];
			if(instance==null){
				instance = new RecycableFactory(clazz);
				factoryMap[classname] = instance;
			}
			instance.clazz = clazz;
			return instance;
		}
		
		public static function recycleDirectly(item:Object):void {
			var classname:String = getQualifiedClassName(item);
			var instance:RecycableFactory = factoryMap[classname];
			if(instance==null) {
				instance = new RecycableFactory(null);
				factoryMap[classname] = instance;
			}
			instance.recycle(item);
		}
		
		public static function newInstanceDirectly(clazz:Class):* {
			return getInstanceByDefinition(clazz).newInstance();
		}
		
		public static function getCacheSizeDirectly(item:Object):int {
			var classname:String = getQualifiedClassName(item);
			var instance:RecycableFactory = factoryMap[classname];
			if(instance!=null) {
				return instance.cache.length;
			}
			return 0;
		}
		
		public function newInstance():* {
			var cell:Object;
			if(cache.length>0){
				cell = cache.shift();
				delete cacheMap[cell];
			} else {
				cell = new clazz();
				newCount++;
//				Console.debug("缓存对象实例化次数，" + clazz + "，" + newCount);
			}
			return cell;
		}
		
		public function recycle(cell:*):void {
			if(cacheMap[cell]==null){
				cache.push(cell);
				cacheMap[cell] = cell;
			} else{
//				Console.warn(getQualifiedClassName(clazz) + "::recycle，重复回复的实例");
			}
		}
		
		public function clear():void {
			var i:int;
			for(i=cache.length-1; i>=0; i--){
				delete cacheMap[cache.pop()];
			}
		}
		
		/**
		 * 当前的cache个数
		 */
		public function cacheNum():int {
			return cache.length;
		}
		
		/**
		 * 是否已经cache了某item
		 */
		public function hasRecycled(cell:*):Boolean {
			return (cacheMap[cell]!=null);
		}
		
		/**
		 * 从cache中删除某item
		 */
		public function delCache(cell:*):void {
			if(cacheMap[cell]!=null) {
				var index:int = cache.indexOf(cell);
				if(index != -1) {
					cache.splice(index, 1);
				}
				delete cacheMap[cell];
			}
		}
	}
}