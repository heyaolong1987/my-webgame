package com.netease.flash.common.net {
	
	import com.netease.flash.common.log.Console;
	
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.ApplicationDomain;
	
	[Event(name="resLoaded", type="ResLoaderEvent")]
	[Event(name="resLoadClosed", type="ResLoaderEvent")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	/**
	 * 对loader的简单封装类，支持缓存，加载挂起，自动释放内存等
	 */
	public class PoolResLoader extends EventDispatcher{
		
		private var _loadResult:ResLoadResult;
		
		private var _complete:Boolean;
		
		private var url:String;
		private var cache:Boolean;
		private var id:String;
		private var poolType:int = PoolResLoaderConstants.POOL_LRU;
		private var poolSize:int = 100;
		private var resType:int = PoolResLoaderConstants.RES_COMMON;
				
		/**
		 * @param url，资源地址
		 * @param cache 是否缓存
		 * @param poolType，资源缓存类型，默认按LRU方式缓存
		 * @param poolSize，当poolType为POOL_LRU时，指示cache大小
		 * @param resType，LRU缓存时的资源分类，当poolType不为LRU缓存时无效，默认为Common
		 * @param pendingIfExist, 当有相同的URL在加载时，此加载挂起，等待相同加载的完成
		 */ 
		public function PoolResLoader(url:String, cache:Boolean=true, poolType:int=1, 
									  poolSize:int=100, resType:int=0) {
			this.url = url;
			this.cache = cache;
			this.id = id;
			this.poolType = poolType;
			this.poolSize = poolSize;
			this.resType = resType;
			_loadResult = new ResLoadResult();
		}
		
		public function get loadResult():ResLoadResult {
			return _loadResult;
		}
		
		public function get domain():ApplicationDomain {
			return _loadResult.domain;
		}
		
		/**
		 * @return SWF(MovieClip)，Bitmap
		 */ 
		public function get content():DisplayObject {
			return _loadResult.content;
		}
		
		public function get complete():Boolean {
			return _complete;
		}
		
		public function get sourceUrl():String {
			return url;
		}
		
		public function load():void {
			close();
			if(cache) {
				var loadResult:ResLoadResult = PoolResLoaderManager.getInstance().getResultFromCache(url, poolType, resType);
				if(loadResult != null){
					handleComplete(loadResult);
					return;
				}
			}
			PoolResLoaderManager.getInstance().startLoad(this);
		}
		
		/**
		 * 获取当前ApplicationDomain内的类定义
		 * @param name，类定义名称，必须包含完整的命名空间，如 Grave.Function.SWFLoader
		 * @param info，加载swf的LoadInfo，不指定则从当前域获取
		 * @return 获取的类定义，如果不存在返回null
		 */
		public function getClass(name:String, domain:ApplicationDomain=null):Class {
			try {
				if (domain == null) {
					domain = this.domain;
				}
				if(domain != null) {
					return domain.getDefinition(name) as Class;
				}
			} catch (e:ReferenceError) {
				Console.warn("类定义 " + name + " 错误");
			}
			return null;
		}
		
		/**
		 * @param name，在导出的swf中设置的导出名称（类定义名称）
		 * @return，指定资源实例，可能是Sprite，MovieClip，BitmapData等
		 */ 
		public function getInstance(name:String):* {
			try {
				var tempClass:Class = getClass(name);
				if(tempClass != null) {
					return new tempClass();
				}
			} catch(e:Error) {
				trace(e);
			}
			return null;
		}
		
		/**
		 * 主动停止加载 
		 */		
		public function close():void{
			PoolResLoaderManager.getInstance().close(this);
		}
		
		/**
		 * 加载完成
		 */ 
		public function onComplete(e:Event):void {
			var info:LoaderInfo = e.currentTarget as LoaderInfo;
			_loadResult.domain = info.applicationDomain;
			_loadResult.content = info.content;
			if(cache) {
				PoolResLoaderManager.getInstance().addResultToCache(url, _loadResult, poolType, resType, poolSize);
			}
			handleComplete(_loadResult);
		}
		
		/**
		 * 加载进度
		 */ 
		public function onProgress(e:ProgressEvent):void {
			this.dispatchEvent(e);
		}
		
		/**
		 * 出错事件
		 */ 
		public function onError(e:Event):void {
			if(hasEventListener(e.type)){
				this.dispatchEvent(e);
			} else{
				if(e is IOErrorEvent){
					Console.warn("未处理的IOErrorEvent：", e.toString());
				}
				else if(e is SecurityErrorEvent){
					Console.warn("未处理的SecurityErrorEvent：", e.toString());
				}
			}
		}
		
		/**
		 * 加载完成
		 */ 
		public function handleComplete(loadResult:ResLoadResult):void {
			this._loadResult = loadResult;
			var resEvent:ResLoaderEvent = new ResLoaderEvent(ResLoaderEvent.RES_LOADED);
			_complete = true;
			this.dispatchEvent(resEvent);
		}
	}
}


