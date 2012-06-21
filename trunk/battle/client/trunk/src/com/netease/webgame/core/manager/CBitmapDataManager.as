package com.netease.webgame.core.manager {
	import com.netease.flash.common.lang.LRUResPool;
	import com.netease.flash.common.net.PoolResLoader;
	import com.netease.flash.common.net.ResLoaderEvent;
	import com.netease.webgame.bitchwar.component.core.RecycableFactory;
	import com.netease.webgame.bitchwar.interfaces..IBitmapDataManagerClient;
	import com.netease.webgame.bitchwar.config.constants.AssetConstants;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.Dictionary;
	
	public class CBitmapDataManager {
		
		private static var instance:CBitmapDataManager = new CBitmapDataManager();
		
		public static function getInstance():CBitmapDataManager {
			return instance;
		}
		
		private var resCache:Dictionary;
		
		private var loaderCache:Dictionary;
		
		private var poolCache:Dictionary;
		
		public function CBitmapDataManager() {
			if (instance) {
				throw new Error("Please use getInstance() method to get the instance.");
			}
			loaderCache = new Dictionary();
			poolCache = new Dictionary();
			resCache = new Dictionary();
		}
		
		public function registerBitmap(key:Object, bitmapData:BitmapData):void {
			resCache[key] = bitmapData;
		}
		/**
		 *注册资源 
		 * @param res 包括mc
		 * 
		 */		
		public function registerRes(key:Object, res:Object):void {
			resCache[key] = res;
		}
		
		public function getRemoteAsset(url:String, assetType:int=0, autoLoad:Boolean=true, callBack:IBitmapDataManagerClient=null):Object {
			var lru:LRUResPool = poolCache[assetType];
			var result:Object;
			var loader:PoolResLoader;
			var loaderInfo:ResLoaderInfo;
			if(lru) {
				result = lru.getObject(url);
			}
			if(result==null && autoLoad && callBack!=null) {
				loaderInfo = loaderCache[url];
				if(loaderInfo==null) {
					loader = new PoolResLoader(url, false);
					loader.addEventListener(ResLoaderEvent.RES_LOADED, resLoadedHandler);
					loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
					loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
					loaderInfo = new ResLoaderInfo();
					loaderInfo.url = url;
					loaderInfo.resType = assetType;
					loaderInfo.callBacks = [callBack];
					loaderInfo.loader = loader;
					loaderCache[url] = loaderInfo;
					loader.load();
				} else {
					if(loaderInfo.callBacks.indexOf(callBack)==-1) {
						loaderInfo.callBacks.push(callBack);
					}
				}
			}
			if(result&&callBack) {
				callBack.bitmapDataLoadResult(true, url, result);
			}
			return result;
		}
		
		public function getBitmap(key:Object):BitmapData {
			return resCache[key] as BitmapData;
		}
		
		public function getMovieClip(key:Object):MovieClip {
			return resCache[key] as MovieClip;
		}
		
		public function getMc(clazz:Class, cache:Boolean=true):Sprite {
			if(clazz == null) {
				return null;
			}
			var mc:Sprite;
			if(cache) {
				mc = RecycableFactory.getInstanceByDefinition(clazz).newInstance();
			} else {
				mc = new clazz();
			}
			return mc;
		}
		
		private function resLoadedHandler(event:ResLoaderEvent):void {
			var loader:ResLoaderInfo = loaderCache[event.url];
			delete loaderCache[event.url];
			var pool:LRUResPool = poolCache[loader.resType];
			var i:int;
			var content:Object;
			if(pool==null) {
				switch(loader.resType) {
					case AssetConstants.IMAGE_TYPE_COMMON:
						pool = new LRUResPool(AssetConstants.CACHE_SIZE_COMMON);
						break;
					case AssetConstants.IMAGE_TYPE_VILLAGE:
						pool = new LRUResPool(AssetConstants.CACHE_SIZE_VILLAGE);
						break;
					case AssetConstants.IMAGE_TYPE_CLAN:
						pool = new LRUResPool(AssetConstants.CACHE_SIZE_CLAN);
						break;
					case AssetConstants.IMAGE_TYPE_SKILL:
						pool = new LRUResPool(AssetConstants.CACHE_SIZE_SKILL);
						break;
					case AssetConstants.IMAGE_TYPE_SCENE:
						pool = new LRUResPool(AssetConstants.CACHE_SIZE_SCENE);
						break;
					case AssetConstants.IMAGE_TYPE_ITEM:
						pool = new LRUResPool(AssetConstants.CACHE_SIZE_ITEM);
						break;
					default:
						pool = new LRUResPool(AssetConstants.CACHE_SIZE_COMMON);
						break;
				}
				poolCache[loader.resType] = pool;
			}
			if(event.loaderinfo.content is Bitmap) {
				content = Bitmap(event.loaderinfo.content).bitmapData;
			} else {
				content = event.loaderinfo.content;
			}
			pool.putObject(loader.url, content);
			for(i=0; i<loader.callBacks.length; i++) {
				IBitmapDataManagerClient(loader.callBacks[i]).bitmapDataLoadResult(true, loader.url, content);
			}
		}
		
		private function errorHandler(event:Event):void {
			var loader:PoolResLoader = PoolResLoader(event.target);
			var loaderInfo:ResLoaderInfo = loaderCache[loader.sourceUrl];
			var i:int;
			for(i=0; i<loaderInfo.callBacks.length; i++) {
				IBitmapDataManagerClient(loaderInfo.callBacks[i]).bitmapDataLoadResult(false, loader.sourceUrl, null);
			}
			delete loaderCache[loader.sourceUrl];
		}
	}
}
import com.netease.flash.common.net.PoolResLoader;

class ResLoaderInfo {
	
	public var url:String;
	public var callBacks:Array;
	public var resType:int;
	public var loader:PoolResLoader;
	
}