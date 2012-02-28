/**
 * Author:  Wang Xing
 * Created at: Jun 16, 2009
 * Server时间控制
 */
package com.netease.webgame.bitchwar.utils {
	import com.netease.webgame.bitchwar.model.vo.ServerTimeVO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class ServerTimer {
		
		public static const TIME_UPDATED:String = "timerUpdated";
		
		private static var timer:Timer;
		private static var dispacher:EventDispatcher;
		
		private static var time:ServerTimeVO = new ServerTimeVO();
		private static var lastUpdateTime:Number;
		
		public static function get timeVO():ServerTimeVO {
			return time;
		}
		
		/**
		 * 更新serverTime
		 */ 
		public static function set serverTime(value:Number):void {
			time.sysTime = value;
			lastUpdateTime = getTimer();
			if (!timer) {
				timer = new Timer(1000, 0);
				timer.addEventListener(TimerEvent.TIMER, onTimer_handler);
				timer.start();
			}
			if (!dispacher) {
				dispacher = new EventDispatcher();
			}
		}
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false
				, priority:int = 0, useWeakReference:Boolean = false):void {
			dispacher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public static function hasEventListener(type:String):Boolean {
			return dispacher.hasEventListener(type);
		}
				
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			dispacher.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * 获取Date格式的Server时间
		 */ 
		public static function getCurrentDate():Date {
			return new Date(time.sysTime + getTimer() - lastUpdateTime);
		}
		
		/**
		 * 获取Number格式的Server时间
		 * 单位：ms
		 */
		public static function getCurrentTime():Number {
			return time.sysTime + getTimer() - lastUpdateTime;
		}
		
		private static function onTimer_handler(e:TimerEvent):void {
			lastUpdateTime = getTimer();
			time.sysTime += 1000;
			dispacher.dispatchEvent(new Event(TIME_UPDATED));
		}
	}
}