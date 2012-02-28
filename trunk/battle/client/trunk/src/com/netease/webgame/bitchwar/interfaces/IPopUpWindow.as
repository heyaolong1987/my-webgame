/**
 * Author:  ShenXian
 * Created at: Dec 16, 1010
 */
package com.netease.webgame.bitchwar.interfaces {
	import mx.core.IFlexDisplayObject;
	
	public interface IPopUpWindow extends IFlexDisplayObject {
		
		function get offsetTop():int;
		function set offsetTop(v:int):void;
		
		function set popUpData(value:*):void;
		function get popUpData():*;
		
		function set ignoreESC(value:Boolean):void;
		function get ignoreESC():Boolean;
		
		function set ignoreESCImmediately(value:Boolean):void;
		function get ignoreESCImmediately():Boolean;
		
		function get cacheSize():int;//是否常用，常用的话就缓存不删除。 常用1，不常用0
		
		function onCreate():void;
		function onRemove(byESC:Boolean = false):void;
		
		function modalAreaClick():void;
		
	}
}