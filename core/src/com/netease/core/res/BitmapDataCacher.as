package com.netease.core.res{
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	/**
	 * @author heyaolong
	 * 位图缓存
	 * 2012-7-25
	 */ 
	public class BitmapDataCacher{
		private static var _instance:BitmapDataCacher;
		private var _cacheDic:Dictionary = new Dictionary();
		public function BitmapDataCacher()
		{
		}
		public static function getInstantce():BitmapDataCacher{
			if(_instance == null){
				_instance = new BitmapDataCacher();
			}
			return _instance;
		}
		public function addBitmapData(key:String,value:BitmapData):void{
			_cacheDic[key] = value;	
		}
		/**
		 *获取位图数据 
		 * @param key
		 * @return 
		 * 
		 */
		public function getBitmapData(url:String,key:String):BitmapData{
			var bitmapData:BitmapData = _cacheDic[url+"_"+key];
			if(bitmapData){
				return bitmapData;
			}
			else{
				var applicationDomain:ApplicationDomain = (ResLoader.getInstance().map[url] as ApplicationDomain);
				if(applicationDomain && applicationDomain.hasDefinition(key)){
					var cls:Class = applicationDomain.getDefinition(key) as Class;
					var bmd:BitmapData = new cls(0,0) as BitmapData;
					_cacheDic[url+"_"+key] = bmd;
				}
			}
			return null;
		}
	}
}