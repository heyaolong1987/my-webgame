package com.netease.view.map.avatar{
	import com.netease.core.res.BitmapDataCacher;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * @author heyaolong
	 * 
	 * 2012-7-24
	 */ 
	public class AvatarPart{
		private var _id:String;
		private var _url:String;
		private var _currentFrame:int;
		private var _totalFrames:int;
		private var _bmpData:BitmapData;
		private var _map:Array = [0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11];
		public function AvatarPart(url:String=null,id:String=null)
		{
			setUrl(url);
			setId(id);
		}
		public function setUrl(url:String):void{
			if(_url != url){
				_url = url;
				_bmpData = null;
				_currentFrame = 0;
				_totalFrames = _map.length;
			}
		}
		public function setId(id:String,startFrame:int=0):void{
			if(_id != id){
				_id = id;
				_bmpData = null;
				_currentFrame = startFrame;
				_totalFrames = _map.length;
			}
		}
		public function set currentFrame(value:int):void{
			_currentFrame = value;
		}
		public function get currentFrame():int{
			return _currentFrame;
		}
		public function run(){
			if(_url&&_id){
				_bmpData = BitmapDataCacher.getInstantce().getBitmapData(_url,_id+"_"+_map[_currentFrame].toString());
				_currentFrame  = (_currentFrame+1)%_totalFrames;
			}
		}
		public function get bitmapData():BitmapData{
			return _bmpData;
		}
	}
}