package com.netease.webgame.bitchwar.manager
{
	import com.netease.webgame.bitchwar.assets.EmbedRes;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public class MouseManager
	{
		private static var _instance:MouseManager;
		private var _modeMap:Object = {};
		private var _stage:Stage;
		private var _currentMouseMode:int;
		private var _currentCursorMc:Sprite;
		public function MouseManager()
		{
		}
		/**
		 * 单例
		 * @return 
		 * 
		 */
		public static function getInstance():MouseManager{
			if(_instance==null){
				_instance = new MouseManager();
			}
			return _instance;
		}
		/**
		 *初始化stage 
		 * @param value
		 * 
		 */
		public function initialize(value:Stage):void {
			_stage = value;
		}
		//鼠标移动
		private function mouseMoveHandler(event:MouseEvent):void{
			if(_currentCursorMc){
				_currentCursorMc.x = _stage.mouseX;
				_currentCursorMc.y = _stage.mouseY;
			}
		}
		/**
		 * 注册鼠标模式
		 * @param mode
		 * @param cursorMc
		 * 
		 */
		public function registerMouseMode(mode:int,cls:Class):void{
			_modeMap[mode.toString()] = cls;
		}
		/**
		 * 获得当前的鼠标模式
		 * @param mode
		 * 
		 */
		public function set currentMouseMode(mode:int):void{
			if(_currentCursorMc){
				if(_currentCursorMc is MovieClip){
					var mc:MovieClip = _currentCursorMc as MovieClip;
					mc.stop();
				}
				_currentCursorMc.parent.removeChild(_currentCursorMc);
				_currentCursorMc = null;
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE ,mouseMoveHandler);
			}
			_currentMouseMode = mode;
			_currentCursorMc = getMouseMovieClip(mode);
			
			if(_currentCursorMc==null){
				Mouse.show();
			}
			else{
				_currentCursorMc.mouseEnabled = false;
				_currentCursorMc.mouseChildren = false;
				if(_currentCursorMc is MovieClip){
					var mc:MovieClip = _currentCursorMc as MovieClip;
					if(mc.totalFrames>1) {
						mc.play();
					}
				}
				
				_currentCursorMc.x = _stage.mouseX;
				_currentCursorMc.y = _stage.mouseY;
				Mouse.hide();
				_stage.addChild(_currentCursorMc);
				_stage.addEventListener(MouseEvent.MOUSE_MOVE ,mouseMoveHandler);
				
			}
			
			
		}
		public function get currentMouseMode():int{
			return _currentMouseMode;
		}
		private function getMouseMovieClip(mode:int):*{
			if(_modeMap[mode.toString()]){
				return new (_modeMap[mode.toString()] as Class);
			}
			return null;
		}
	}
}