package com.netease.core.res{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	public class ByteLoader extends EventDispatcher{
		
		public var url:String;
		public var data:ByteArray;
		private var stream:URLLoader;
		private var _needDispatchEvent:Boolean;
		private var _loadCompleteFunc:Function;
		private var _args:Array;
		public function ByteLoader(){
		}
		public function load(url:String,loadCompleteFunc:Function,args:Array=null,needDispatchEvent:Boolean = false):void{
			_loadCompleteFunc = loadCompleteFunc;
			_needDispatchEvent = needDispatchEvent;
			_args = args;
			url = url;
			data = new ByteArray();
			stream = new URLLoader();
			stream.dataFormat = URLLoaderDataFormat.BINARY;
			stream.load(new URLRequest(url));
			if(_needDispatchEvent){
				stream.addEventListener(ProgressEvent.PROGRESS,progressHandler);
				stream.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			}
			stream.addEventListener(Event.COMPLETE,completeHandler);
			
		}
		
		public function errorHandler(e:Event):void {
			if(_needDispatchEvent){
				stream.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
				stream.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				dispatchEvent(e);
			}
			stream.removeEventListener(Event.COMPLETE,completeHandler);
			
			
		}
		
		//加载中
		private function progressHandler(e:ProgressEvent):void{
			dispatchEvent(e);
		}
		
		//加载完成
		private function completeHandler(e:Event):void{
			// update();
			data = stream.data as ByteArray;
			if(_loadCompleteFunc){
				_loadCompleteFunc.apply(null,[data,_args]);
			}
			stream.removeEventListener(Event.COMPLETE,completeHandler);
			if(_needDispatchEvent){
				stream.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
				stream.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				dispatchEvent(e);
			}
		}
		//清除数据
		public function close():void{
			stream = null;
			data = null;
		}
		
	}
}