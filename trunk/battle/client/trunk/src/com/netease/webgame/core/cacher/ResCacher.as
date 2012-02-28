package com.netease.webgame.core.cacher
{
	import com.netease.webgame.core.events.ResEvent;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	public class ResCacher extends EventDispatcher
	{
		private static var _instance:ResCacher;
		private static var resMap:Dictionary = new Dictionary();
		private static var loadingList:Dictionary = new Dictionary();
		private static var loadingTypeList:Dictionary = new Dictionary();
		private static var callBackList:Dictionary = new Dictionary();
		private static var currentCompleteLoader:Loader;
		public function ResCacher()
		{
			
		}
		public static function getInstance():ResCacher{
			if(_instance==null){
				_instance = new ResCacher();
			}
			return _instance;
		}
		public function loadRes(url:String,loadCompleteHandler:Function=null):void{
			if(url==null){
				trace("url is null");
				return;
			}
			if(loadCompleteHandler){
				if( resMap[url] != null) {
					loadCompleteHandler(new ResEvent(url,resMap[url]));
					return;
				}
				if(!callBackList[url]){
					callBackList[url] = new Dictionary();
				}
				callBackList[url][loadCompleteHandler]=loadCompleteHandler;
			}
			if( loadingList[url] ) {
				return;
			}
			var loader:Loader = new Loader();
			loadingList[url] = loader;
			loadingTypeList[loader] = url;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,errHandler);
			var lc:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
			loader.load( new URLRequest(url) , lc);		
		}
		
		
		private function errHandler(event:IOErrorEvent):void{
			// 出错的处理相对复杂。
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR,errHandler);
			event.currentTarget.removeEventListener(Event.COMPLETE,onLoadComplete);
			trace( event );
		}
		
		
		private function onLoadComplete( e:Event ) :void {
			var loaderInfo:LoaderInfo = e.target as LoaderInfo;
			var loader:Loader = loaderInfo.loader;
			currentCompleteLoader = loader;
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,errHandler);
			loaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			var url:String = loadingTypeList[loader];
			resMap[url] = loader.content;
			loadingList[url] = null;
			var callBackDic:Dictionary = callBackList[url];
			var event:ResEvent = new ResEvent(url,resMap[url]);
			if(callBackDic!=null){
				for each(var func:Function in callBackDic){
					(func as Function).apply(null,[event]);
				}
				callBackList[url] = null;
				delete callBackList[url];
			}
			
			dispatchEvent( event );
		}
		
	}
}