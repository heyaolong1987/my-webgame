/**
 * Author：小妖怪的天敌-小神仙
 */
package com.netease.webgame.bitchwar.interfaces. {
	
	import flash.events.IEventDispatcher;

	/**
	 * Please NOTE that set the toolTipData to null if you want to destory the component
	 */ 
	public interface IProToolTipManagerClient extends IEventDispatcher {
		
		function get toolTipData():Object;
		
		function get toolTipClass():Class;

		function get toolTipShowDelay():int;
		
		function get toolTipDataFunction():Function;
		
		function get toolTipLayoutDirection():int;
		
		function set toolTipData(value:Object):void;
		
		function set toolTipClass(value:Class):void;
		
		function set toolTipShowDelay(value:int):void;
		
		function set toolTipDataFunction(value:Function):void;
		
		function set toolTipLayoutDirection(value:int):void;
		
		function registerToolTip(tipData:Object, tipClass:Class=null, tipFunction:Function=null, toolTipLayoutDirection:int=0, showDelay:int=200):void;
		
	}
}