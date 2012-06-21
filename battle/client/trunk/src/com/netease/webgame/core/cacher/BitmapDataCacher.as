package com.netease.webgame.core.cacher
{
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	public class BitmapDataCacher extends Cacher
	{
		private static var _instance:BitmapDataCacher;
		public static function getInstance():BitmapDataCacher{
			if(_instance){
				_instance = new BitmapDataCacher();
			}
			return _instance;
		}
		/*
		* 根据资源地址和帧数获得BitmapData
		* 只保存关键帧，后续仍可优化，部分关键帧可以通过镜像获得 
		*/
		public function getBitmapData(key:String):BitmapData
		{
			return getObject(key) as BitmapData
		}
		public function cacheBitmapData(key:String,bitmapData:BitmapData):Boolean{
			return cacheObject(key,bitmapData);
		}	
		
	}
}