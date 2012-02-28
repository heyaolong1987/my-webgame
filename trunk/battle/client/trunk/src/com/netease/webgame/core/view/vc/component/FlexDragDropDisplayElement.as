package com.netease.webgame.core.view.vc.component {
	
	import com.netease.webgame.bitchwar.view.component.core.events.DragDropEvent;
	import com.netease.webgame.bitchwar.interfaces.IDragDropGrid;
	import com.netease.webgame.bitchwar.view.component.core.managers.DragDropManager;
	
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	public class FlexDragDropDisplayElement extends UIComponent implements IDragDropGrid {
		
		protected var _dragable:Boolean = false;
		protected var _dropable:Boolean = false;
		protected var _preHighlight:Boolean = false;
		protected var _gridType:String;
		
		public function FlexDragDropDisplayElement() {
			super();
		}
		
		public function get preHighlight():Boolean {
			return this._preHighlight;
		}
		
		public function set preHighlight(value:Boolean):void {
			DragDropManager.getInstance().registerPreHighlight(this, value);
			this._preHighlight = value;
		}
		
		public function get dragable():Boolean {
			return this._dragable;
		}
		
		public function set dragable(value:Boolean):void {
			DragDropManager.getInstance().registerDragable(this, value);
			this._dragable = value;
		}
		
		public function get dropable():Boolean {
			return this._dropable;
		}
		
		public function set dropable(value:Boolean):void {
			this._dropable = value;
		}
		
		public function get gridType():String{
			return _gridType;
		}
		
		public function set gridType(value:String):void{
			_gridType = value;
		}
		
		public function dragOver(dragEvent:DragDropEvent):void {
			
		}
		
		public function dragOut(dragEvent:DragDropEvent):void{
			
		}
		
		public function highLightDropable(dragEvent:DragDropEvent, value:Boolean=true):void {
			
		}
		
		public function dragDrop(dragEvent:DragDropEvent):Boolean {
			return false;
		}
		
		public function getItemPosition(position:int):Point {
			return null;
		}
		
	}
}