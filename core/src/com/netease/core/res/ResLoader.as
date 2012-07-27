package com.netease.core.res{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import mx.messaging.AbstractConsumer;
	
	/**
	 * @author heyaolong
	 * 
	 * 2011-11-2
	 */ 
	public class ResLoader {
		public const MAX_FRESS_LOADER_NUM:int = 10;
		private var _freeLoaderList:Array = new Array(MAX_FRESS_LOADER_NUM);
		private var _loadingLoaderList:Dictionary = new Dictionary();
		private var _loadingFuncList:Dictionary = new Dictionary();
		private var _waitingFuncList:Array = [];
		private var _resCacher:ResCacher = ResCacher.getInstance();
		protected var _loaderContext:LoaderContext;
		private var _loadingBytesLoaderList:Dictionary = new Dictionary();
		private static var _instance:ResLoader;
		public var map:Dictionary = new Dictionary();
		
		public function ResLoader()
		{
			createLoaderContent();
			createLoaders();
		}
		private function createLoaderContent():void{
			_loaderContext = new LoaderContext(false);
			_loaderContext.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
		}
		public function get applicationDomain():ApplicationDomain{
			return _loaderContext.applicationDomain;
		}
		public static function getInstance():ResLoader{
			if(_instance==null){
				_instance = new ResLoader();
			}
			return _instance;
		}
		/**
		 *创建loader池 
		 * 
		 */
		protected function createLoaders():void{
			var num:int = MAX_FRESS_LOADER_NUM;
			var loader:Loader;
			for(var i:int=0; i< num; i++){
				loader = new Loader();
				var loaderInfo:LoaderInfo = loader.contentLoaderInfo;
				loaderInfo.addEventListener(Event.COMPLETE, onComplete);
				loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
				loaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				_freeLoaderList[i] = loader;
			}
		}
		
		/**
		 *载入资源 
		 * @param url
		 * @param client
		 * @param loadedFunc 
		 * 
		 */
		/**
		 * 
		 * @param url
		 * @param loadedFunc
		 * @param args
		 * @param needCache 回调参数 data,args
		 * 
		 */
		public function load(url:String,loadedFunc:Function, args:Array=null, needCache:Boolean=false):void{
			var res:Object = _resCacher.getRes(url);
			if(res){
				loadedFunc(res,args);
				return;
			}
			if(_loadingFuncList[url]!=null){
				_loadingFuncList[url].push([loadedFunc, args, needCache]);
				return;
			}
			if(_freeLoaderList.length>0){
				var loader:Loader = _freeLoaderList.shift() as Loader;
				_loadingFuncList[url] = [[loadedFunc, args]];
				_loadingLoaderList[loader] = [loader,url,needCache];
				loader.load(new URLRequest(url),_loaderContext);
				var app:ApplicationDomain = _loaderContext.applicationDomain;
				var currentDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			}
			else{
				_waitingFuncList.push([url, loadedFunc, args, needCache]);
			}
			
			
		}
		/**
		 * 加载完成
		 */ 
		private function onComplete(e:Event):void {
			var info:LoaderInfo = e.currentTarget as LoaderInfo;
			var loader:Loader = info.loader;
			var url:String = _loadingLoaderList[loader][1];
			var needCache:Boolean = _loadingLoaderList[loader][2];
			var funcList:Array = _loadingFuncList[url];
			_loadingFuncList[url] = null;
			_loadingLoaderList[loader] = null;
			map[url] = info.applicationDomain;
			if(funcList){
				var len:int = funcList.length;
				var func:Array;
				for(var i:int=0; i<len; i++){
					func = funcList[i];
					func[0](info.content,func[1]);
				}
				if(needCache){
					ResCacher.getInstance().addRes(url,info.content);
				}
			}
			addLoaderToFreeList(loader);
		}
		protected function addLoaderToFreeList(loader:Loader):void{
			
			try{
				loader.close();
			}
			catch(e:Error){
			}
			loader.unloadAndStop();
			_freeLoaderList.push(loader);
			if(_freeLoaderList.length==1&&_waitingFuncList.length>0){
				var func:Array = _waitingFuncList.shift();
				load(func[0],func[1],func[2]);
			}
		}
		/**
		 * 出错事件
		 */ 
		private function onError(e:Event):void {
			var info:LoaderInfo = e.currentTarget as LoaderInfo;
			var loader:Loader = info.loader;
			addLoaderToFreeList(loader);
			if(e is IOErrorEvent){
				//Console.warn("未处理的IOErrorEvent：", e.toString());
			}
			else if(e is SecurityErrorEvent){
				//Console.warn("未处理的SecurityErrorEvent：", e.toString());
			}
			
		}
		
		public function loadBytes(bytes:ByteArray,callBack:Function=null, args:Array=null):void{
			var loader:Loader = new Loader();
			var loaderInfo:LoaderInfo = loader.contentLoaderInfo;
			loaderInfo.addEventListener(Event.COMPLETE, onLoadBytesComplete);
			_loadingBytesLoaderList[loader] = [callBack,args];
			loader.loadBytes(bytes,_loaderContext);
		}
		private function onLoadBytesComplete(e:Event):void{
			var info:LoaderInfo = e.currentTarget as LoaderInfo;
			var loader:Loader = info.loader;
			var loadInfo:Array = _loadingBytesLoaderList[loader];
			_loadingBytesLoaderList[loader] = null;
			if(loadInfo){
				loadInfo[0](info.content,loadInfo[1]);
			}
		}
	}
}