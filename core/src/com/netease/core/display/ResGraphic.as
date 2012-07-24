package com.netease.core.display{
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
	public class ResGraphic{
		private var _mc:MovieClip;
		private var _currentFrame:int;
		private var _totalFrames:int;
		private var _container:IBitmapDrawable;
		private var _bmpData:BitmapData;
		
		public function ResGraphic(mc:MovieClip)
		{
			_mc = mc;
			_totalFrames = _mc.totalFrames;
		}
		public function run(){
			_bmpData = new BitmapData(_mc.width,_mc.height);
			_bmpData.draw( IBitmapDrawable);
			_currentFrame = (_currentFrame+1)%_totalFrames;
		}
		public function get bitmapData():BitmapData{
			(_mc[currentFrame] as Bitmap).bitmapData;
		}
	}
}