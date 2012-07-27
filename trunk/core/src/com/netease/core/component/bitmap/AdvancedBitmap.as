package com.netease.core.componentitmap {
	import com.netease.core.res.ResLoader;
	
	import flash.display.*;
	
	/**
	 * 
	 * @author heyaolong
	 * 
	 * 2012-5-30
	 */
	public class AdvancedBitmap {
		
		public var _rx:int;
		public var _ry:int;
		public var _bitmapData:BitmapData;
		public var _url:String;
		public function dispose():void{
			_bitmapData = null;
		}
		public function AdvancedBitmap(bitmapData:BitmapData,url:String=null,rx:int=0, ry:int=0){
			_bitmapData = bitmapData;
			_url = url;
			_rx = rx;
			_ry = ry;
			if(bitmapData == null){
				if(_url != null){
					ResLoader.getInstance().load(url,this,loadFinishFunc);
				}
			}
		}
		private function loadFinishFunc(client:AdvancedBitmap, data:Object):void{
			if(data is Bitmap){
				client.bitmapData = Bitmap(data).bitmapData;
			}
		}
	}
}
