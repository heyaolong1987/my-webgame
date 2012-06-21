/**
 * Author:  小神仙
 * Created at: 2010-03-02
 */
package com.netease.webgame.bitchwar.interfaces. {
	
	import com.netease.webgame.core.events.DragDropEvent;
	
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	public interface IDragDropGrid extends IEventDispatcher {
		
		function get preHighlight():Boolean;
		function set preHighlight(value:Boolean):void;
		
		function get dragable():Boolean;
		function set dragable(value:Boolean):void;
		
		function get dropable():Boolean;
		function set dropable(value:Boolean):void;
		
		function dragOver(dragEvent:DragDropEvent):void;
		function dragOut(dragEvent:DragDropEvent):void;
		function dragDrop(dragEvent:DragDropEvent):Boolean;
		function highLightDropable(dragEvent:DragDropEvent, value:Boolean=true):void;
		
		function get gridType():String;
		function set gridType(value:String):void;
		
		function getItemPosition(position:int):Point;
		
	}
}