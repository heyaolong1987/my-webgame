package com.netease.core.component
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import com.netease.core.events.ClickEvent;
	import com.netease.core.events.DoubleClickEvent;
	
	/**
	 * @author heyaolong
	 * 实现可交互的Sprite
	 * 2012-3-19
	 */ 
	public class InteractiveSprite extends Sprite{
		
		/**
		 *两次点击时间间隔小于200毫秒为双击 
		 */
		public static var CLICK_TIME_OUT:int = 200;
		/**
		 *上次点击时间 
		 */
		protected var _lastClickTime:Number = 0;
		/**
		 *连续点击次数
		 */
		protected var _clickCount:Number=0;
		/**
		 *上次点击事件 
		 */
		protected var _mouseEvent:MouseEvent;
		public function InteractiveSprite()
		{
			addEventListener(MouseEvent.CLICK, mouseClickHandler);
		}
		
		protected function mouseClickHandler(event:MouseEvent):void{
			_mouseEvent = event;
			var currentTime:Number = getTimer();
			if(_clickCount == 1){
				_clickCount = 0;
				if(currentTime-_lastClickTime<CLICK_TIME_OUT){
					itemDoubleClick();
				}
				else{
					itemClick();
				}
			}
			else{
				_clickCount = 1;
			}
			_lastClickTime = currentTime;
		}
		protected function itemClick():void{
			var event:ClickEvent = new ClickEvent(_mouseEvent.localX,_mouseEvent.localY);
			dispatchEvent(event);
		}
		protected function itemDoubleClick():void{
			var event:DoubleClickEvent = new DoubleClickEvent(_mouseEvent.localX,_mouseEvent.localY);
			dispatchEvent(event);
		}
	}
}