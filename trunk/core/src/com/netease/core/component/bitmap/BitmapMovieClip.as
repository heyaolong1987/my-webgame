package com.netease.core.componentitmap{
	import com.netease.core.manager.FrameManager;
	
	import flash.display.*;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import webgame.utils.timer.*;
	
	/**
	 * @author heyaolong
	 * 
	 * 2012-5-30
	 */ 
	public class BitmapMovieClip extends Sprite{
		
		public function BitmapMovieClip(){
		}
		public static var END:String = "end";
		private var _bitmap:Bitmap;
		protected var _endFunction:Function;
		public var _totalFrames:int;
		public var _currentFrame:int = 1;
		protected var _isLoop:Boolean;
		private var _isSmooth:Boolean = false;
		private var _bmpFrames:Array;
		public function BitmapMovieClip(){
			_bitmap = new Bitmap(null, "auto", true);
			addChild(_bitmap);
			mouseChildren = false;
			mouseEnabled = false;
		}
		/**
		 *当前帧 
		 * @return 
		 * 
		 */
		public function get currentFrame():int{
			return _currentFrame;
		}
		/**
		 *总帧数
		 * @return
		 * 
		 */
		public function get totalFrames():int{
			return _totalFrames;
		}
		/**
		 * 设置位图数据
		 * @param bmpFrames
		 * 
		 */
		public function set bitmapFrames(bmpFrame:Array):void{
			if (_bmpFrames != null){
				var len:int = _bmpFrames.length;
				for(var i:int=0; i<len; i++){
					AdvancedBitmap(_bmpFrames[i]).dispose();
				}
				_bmpFrames = null;
			}
			_bmpFrames = bmpFrames;
			if(_bmpFrames){
				_totalFrames = _bmpFrames.length;
			}
			else{
				_totalFrames = 1;
			}
			_currentFrame = 1;
		}
		public function get bitmapFrames():BitmapFrames{
			return (_bmpFrames);
		}
		public function get bitmap():Bitmap{
			return (_bitmap);
		}
		public function get bitmapData():BitmapData{
			return (_bitmap.bitmapData);
		}
		public function set bitmapData(bmp:BitmapData):void{
			_bitmap.bitmapData = bmp;
		}
		protected function toNextFrame():void{
			if (_currentFrame+1 < _totalFrames){
				_currentFrame++;
			} else {
				if (_isLoop == false){
					stop();
					if (_endFunction != null){
						_endFunction();
					}
					dispatchEvent(new Event(END));
					return;
				}
				_currentFrame = _startFrame;
			}
			setCurrentFrame(_currentFrame);
		}
		protected function setCurrentFrame(frame:int):void{
			if (frame > _totalFrames){
				frame = _totalFrames
			}
			_currentFrame = frame;
			var bmp:AdvancedBitmap = (_bmpFrames.getbitmapFrame(_currentFrame) as AdvancedBitmap);
			if (bmp == null){
				return;
			}
			_bitmap.bitmapData = null;
			_bitmap.bitmapData = bmp.bitmapData;
			_bitmap.smoothing = _isSmooth;
			_bitmap.x = bmp.rx;
			_bitmap.y = bmp.ry;
		}
		public function gotoAndPlay(frame:int):void{
			setCurrentFrame(frame);
			play();
		}
		public function gotoAndStop(frame:int):void{
			if (_bmpFrames == null){
				return;
			}
			setCurrentFrame(frame);
			stop();
		}
		public function prevFrame():void{
			gotoAndStop(_currentFrame - 1);
		}
		public function nextFrame():void{
			gotoAndStop(_currentFrame + 1);
		}
		public function stop():void{
			FrameManager.getInstance().removeProcessFunction(toNextFrame);
		}
		public function play():void{
			FrameManager.getInstance().registProcessFunction(toNextFrame);
		}
		public function getMaxY():Number{
			var rect:Rectangle = _bitmap.getBounds(this);
			return Math.abs(rect.y);
		}
		public function set isSmooth(value:Boolean):void{
			_isSmooth = value;
		}
		public function dispose():void{
			_endFunction = null;
			_bitmap.bitmapData = null;
			FrameManager.getInstance().removeProcessFunction(toNextFrame);
		}
	}
}