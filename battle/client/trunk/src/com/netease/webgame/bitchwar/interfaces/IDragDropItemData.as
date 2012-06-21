/**
 * Author:  小神仙
 * Created at: 2010-03-02
 */
package com.netease.webgame.bitchwar.interfaces. {
	
	public interface IDragDropItemData {
		
		function get shapeData():Array;
		function get position():int;
		function set position(value:int):void;
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
	}
}