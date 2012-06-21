package com.netease.flash.common.net
{
	import com.netease.flash.common.lang.LRUResPool;
	import com.netease.flash.common.log.Console;
	import com.netease.webgame.bitchwar.config.ItemCategoryConfig;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;

	/**
	 * poolresloader的管理类，负责管理缓存、加载挂起
	 * 避免在项目中同一时刻发送大量的请求，在这类中专门对这些讲求进行处理：
	 * 1.如果当前有相同的URL在加载，则将当前的请求挂起，等相同的URL加载完成后，抛出事件进行结果处理。
	 * 2.将大量的请求进行序列化加载。以防止某一时刻卡的现象
	 * @author ZHP
	 * @E-mail: zhou-han-peng@163.com
	 * @create: Sep 21, 2011
	 */
	public class PoolResLoaderManager
	{
		public static const LOADER_POOL_SIZE:int = 6;
		private static var _instance:PoolResLoaderManager;
		
		/**
		 * Loader的资源池
		 */		
		private var _loaderPool:Array;
		
		/**
		 * [[PoolResLoader]]
		 * 等待加载的资源，元素类型：相同URL的PoolResLoader 数组 
		 */		
		private var _loadQueue:Array;
		
		/**
		 * 所有资源的缓存 
		 */		
		private var _lruCache:Dictionary = new Dictionary();
		private var _holdCache:Dictionary = new Dictionary();
		
		public static function getInstance():PoolResLoaderManager{
			if (!_instance) {
				_instance = new PoolResLoaderManager();
				_instance.initLoaderManager();
				
			}
			return _instance;
		}
		
		/**
		 * 加载 方法，对Loader.load方法的封装
		 * @param vars
		 * 
		 */		
		public function startLoad(resLoader:PoolResLoader):void {
			//加到等待队列，开始加载
			var suprl:SameUrlPoolResLoaders;
			suprl = getSuprlByUrl(resLoader.sourceUrl);
			if(suprl) {
				suprl.addPoolResLoader(resLoader);
			}else {
				suprl = new SameUrlPoolResLoaders(resLoader.sourceUrl);
				suprl.addPoolResLoader(resLoader);
				_loadQueue.push(suprl);
				innerLoad(suprl);
			}
		}
		
		public function close(resLoader:PoolResLoader):void {
			var suprl:SameUrlPoolResLoaders = getSuprlByUrl(resLoader.sourceUrl);
			if(suprl){
				suprl.delPoolResLoader(resLoader);
//				if(suprl.isEmpty()) {
//					if(suprl.loader) {
//						removeEvent(suprl.loader.contentLoaderInfo);
//						try{
//							suprl.loader.close();
//							suprl.loader.unloadAndStop();
//						}catch(error:Error){
//							Console.debug(error);
//						}
//						_loaderPool.push(suprl.loader);
//					}
//					_loadQueue.splice(_loadQueue.indexOf(suprl), 1);
//					innerLoadNext();
//				}
			}
		}
		
		/**
		 * 从缓存中获取加载结果
		 */		
		public function getResultFromCache(url:String, poolType:int, resType:int):ResLoadResult {
			var loadResult:ResLoadResult;
			if(poolType == PoolResLoaderConstants.POOL_HOLD){
				loadResult = _holdCache[url];
			} 
			else if(poolType == PoolResLoaderConstants.POOL_LRU){
				var lruPool:LRUResPool = _lruCache[resType];
				if(lruPool != null) {
					loadResult = lruPool.getObject(url);
				}
			}
			return loadResult;
		}
		
		/**
		 * 加载完成后，将加载结果加到cache中 
		 */		
		public function addResultToCache(url:String, loadResult:ResLoadResult, poolType:int, resType:int, cacheSize:int):void {
			if(poolType == PoolResLoaderConstants.POOL_HOLD) {
				_holdCache[url] = loadResult;
			} 
			else if(poolType == PoolResLoaderConstants.POOL_LRU) {
				var lruPool:LRUResPool = _lruCache[resType];
				if(lruPool == null) {
					lruPool = new LRUResPool(cacheSize);
					_lruCache[resType] = lruPool;
				}
				lruPool.putObject(url, loadResult);
			}
		}
		
		/**
		 * 初始化加载资源池 
		 * 
		 */		
		private function initLoaderManager():void {
			_loaderPool = [];
			_loadQueue = [];
			for (var i:int = 0; i < LOADER_POOL_SIZE; i++) {
				var loader:Loader = new Loader();
				_loaderPool.push(loader);
			}
		}
		
		private function innerLoad(suprl:SameUrlPoolResLoaders):void {
			if(_loaderPool.length > 0) {
				var loader:Loader = _loaderPool.shift() as Loader;
				suprl.loader = loader;
				var request:URLRequest = new URLRequest(suprl.url);
				var context:LoaderContext = new LoaderContext(true);
				context.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);	
				initEvent(loader.contentLoaderInfo);
				loader.load(request, context);
			}
		}
		
		private function innerLoadNext():void {
			var length:int = _loadQueue.length;
			for (var i:int = 0; i < length; i++) {
				var suprl:SameUrlPoolResLoaders = _loadQueue[i] as SameUrlPoolResLoaders;
				if(!suprl.loader){
					innerLoad(suprl);
					return;
				}
			}
		}
		
		private function initEvent(loaderInfo:LoaderInfo):void {
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
			loaderInfo.addEventListener(Event.COMPLETE, onLoaded);
		}
		
		private function removeEvent(loaderInfo:LoaderInfo):void {
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			loaderInfo.removeEventListener(Event.COMPLETE, onLoaded);
		}
		
		private function getSuprlByUrl(url:String):SameUrlPoolResLoaders {
			var length:int = _loadQueue.length;
			for (var i:int = 0; i < length; i++) {
				var item:SameUrlPoolResLoaders = _loadQueue[i] as SameUrlPoolResLoaders;
				if(item.url == url) {
					return item;
				}
			}
			return null;
		}
		
		private function getSuprlByLoader(loader:Loader):SameUrlPoolResLoaders {
			var length:int = _loadQueue.length;
			for (var i:int = 0; i < length; i++) {
				var item:SameUrlPoolResLoaders = _loadQueue[i] as SameUrlPoolResLoaders;
				if(item.loader == loader) {
					return item;
				}
			}
			return null;
		}
		
		private function onProgress(event:ProgressEvent):void {
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			var suprl:SameUrlPoolResLoaders = getSuprlByLoader(loaderInfo.loader);
			if(suprl) {
				for each(var resLoader:PoolResLoader in suprl.resLoaders) {
					resLoader.onProgress(event);
				}
			}
		}
		
		/**
		 * 当正在加载的loader错误时，通知所有的挂起loader抛错 
		 * @param event
		 * 
		 */		
		private function onError(event:Event):void {
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			removeEvent(loaderInfo);
			var suprl:SameUrlPoolResLoaders = getSuprlByLoader(loaderInfo.loader);
			if(suprl) {
				_loadQueue.splice(_loadQueue.indexOf(suprl), 1);
				for each(var resLoader:PoolResLoader in suprl.resLoaders) {
					resLoader.onError(event);
				}
				_loaderPool.push(loaderInfo.loader);
				innerLoadNext();
			}
		}
		
		/**
		 * 当正在加载的loader完成时，通知所有挂起的loader完成 
		 * @param event
		 * 
		 */		
		private function onLoaded(event:Event):void {
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			removeEvent(loaderInfo);
			var suprl:SameUrlPoolResLoaders = getSuprlByLoader(loaderInfo.loader);
			if(suprl) {
				_loadQueue.splice(_loadQueue.indexOf(suprl), 1);
				for each(var resLoader:PoolResLoader in suprl.resLoaders) {
					resLoader.onComplete(event);
				}
			}else {
				for each(suprl in _loadQueue) {
					if(suprl.loader == loaderInfo.loader) {
						suprl.loader = null;
					}
				}
				Console.debug("============"+loaderInfo.url+"=======================no Found");
			}
			loaderInfo.loader.unload();
			_loaderPool.push(loaderInfo.loader);
			innerLoadNext();
		}
	}
}
import com.netease.flash.common.net.PoolResLoader;

import flash.display.Loader;

class SameUrlPoolResLoaders {
	public var resLoaders:Array;
	public var url:String;
	public var loader:Loader;
	
	public function SameUrlPoolResLoaders(url:String) {
		resLoaders = [];
		this.url = url;
		loader = null;
	}
	
	public function addPoolResLoader(resLoader:PoolResLoader):void {
		if(resLoaders.indexOf(resLoader) < 0){ 
			resLoaders.push(resLoader);
		}
	}
	
	
	public function delPoolResLoader(resLoader:PoolResLoader):void {
		var index:int = resLoaders.indexOf(resLoader);
		if(index >= 0) {
			resLoaders.splice(index, 1);
		}
	}
	
	public function isEmpty():Boolean {
		return resLoaders.length == 0;
	}
} 