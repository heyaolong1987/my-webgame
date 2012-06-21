package com.netease.webgame.core.interfaces{
	
	/**
	 *
	 *@author heyaolong
	 *
	 *2011-10-14
	 */
	public interface ICCacher{
		function set maxCacheNum(value:int):void;
		function get maxCacheNum():int;
		function set nowCacheNum(value:int):void;
		function get nowCacheNum():int;
		function set cacheMode(value:int):void;
		function get cacheMode():int;
		function cacheObject(key:Object,obj:Object):Boolean;
		function getObject(key:Object):Object;
		function getRandomObject():Object;
		function getObjectByType(cls:Class):Object;
		function deleteObject(key:Object):Object;
		function clear():void;
	}
}