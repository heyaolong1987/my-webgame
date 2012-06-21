package com.netease.core.manager{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	import mx.managers.DragManager;
	import com.netease.core.events.CDragEvent;
	import com.netease.core.interfaces.ICDragManager;
	
	/**
	 * @author heyaolong
	 * 
	 * 2011-11-5
	 */ 
	public class CDragManager implements ICDragManager {
	
		private static var _instance:CDragManager;
		private var _dragging:Boolean;
		private var _stage:Stage;
		private var _dragContainer:Sprite;
		private var _dragSource:DisplayObject;
		private var _dragIcon:Sprite;
		private var _xOffset:int;
		private var _yOffset:int;
		private var _mouseIsDown:Boolean;
		
		public function CDragManager()
		{
			
		}
		public static function getInstance():CDragManager{
			if(_instance==null){
				_instance = new CDragManager();
			}
			return _instance;
		}
		public function get isDragging():Boolean{
			return _dragging;
		}
		public function initialize(value:Stage):void{
			if(_stage){
				return;
			}
			_stage = value; 
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler0, false, 0, true);
			_stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler0, false, 0, true);
			_dragIcon = new Sprite();
			_dragIcon.mouseChildren = false;
			_dragIcon.mouseEnabled = false;

		}
		public function get mouseIsDown():Boolean{
			return _mouseIsDown;
		}
		private function mouseDownHandler0(event:MouseEvent):void{
			_mouseIsDown = true;
		}
		private function mouseUpHandler0(event:MouseEvent):void{
			_mouseIsDown = false;
		}
		protected function mouseMoveHandler(event:MouseEvent):void {
			if(_dragging){
				if(event == null){
					return;
				}
				var target:Sprite = event.target as Sprite;
				var stageX:Number = event.stageX;
				var stageY:Number = event.stageY;
				_dragIcon.x = stageX + _xOffset;
				_dragIcon.y = stageY + _yOffset;
				
				var dropTarget:DisplayObject = getDropTarget();
				dispatchDragEvent(CDragEvent.DRAG_OVER, event,dropTarget );
				dispatchDragEvent(CDragEvent.DRAG_ENTER, event, dropTarget);
				//dispatchDragEvent(CDragEvent.DRAG_EXIT, event, oldTarget);
			}
		}
		protected function mouseUpHandler(event:MouseEvent):void{
			endDrag();
		}
		public function doDrag(dragContainer:Sprite, dragSource:DisplayObject,mouseEvent:MouseEvent,
							   dragImage:DisplayObject = null,xOffset:int = 0,yOffset:int = 0,imageAlpha:Number = 0.5):void{
			
			//正在拖动
			if(_dragging){
				return;
			}
			//鼠标按下或鼠标click时才能进行拖拽
			if (!(mouseEvent.type == MouseEvent.MOUSE_DOWN ||
				mouseEvent.type == MouseEvent.CLICK ||
				_mouseIsDown ||
				mouseEvent.buttonDown))
			{
				return;
			}   
			if(dragImage==null){
				return;
			}
			_dragging = true;
			addDragEvent();
			_dragContainer = dragContainer;
			_dragSource = dragSource;
			_xOffset = xOffset;
			_yOffset = yOffset;
			var dropTarget:DisplayObject;
			var i:int;
			var pt:Point = new Point();
			//var target:DisplayObject = DisplayObject(mouseEvent.target);
			while(_dragIcon.numChildren>0){
				_dragIcon.removeChildAt(0);
			}
			
			var stageX:Number = mouseEvent.stageX;
			var stageY:Number = mouseEvent.stageY;
			_dragIcon.x = stageX + _xOffset;
			_dragIcon.y = stageY + _yOffset;
			_dragIcon.addChild(dragImage);
			dragImage.cacheAsBitmap = true;
			_dragIcon.alpha = imageAlpha;
			_stage.addChild(_dragIcon);
			Mouse.hide();
		
			
			
		}
		public function endDrag():void{
			_stage.removeChild(_dragIcon);
			removeDragEvent();
			_dragContainer = null;
			_dragSource = null;
			_xOffset = 0;
			_yOffset = 0;
			Mouse.show();
			_dragging = false;
		}
		protected function addDragEvent():void{
			_stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler, true);
			_stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler, true);
		}
		protected function removeDragEvent():void{
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler,true);
			_stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,true);
		}
		
		public function acceptDragDrop(target:Sprite):void{
			
		}
		private function dispatchDragEvent(type:String,event:MouseEvent,dropTarget:DisplayObject):void
		{
			var dragEvent:CDragEvent = new CDragEvent(type,_dragContainer,_dragSource,event.ctrlKey,event.altKey,event.shiftKey);
			dragEvent.localX = event.localX;
			dragEvent.localY = event.localY;
			dropTarget.dispatchEvent(dragEvent);
		}
		protected function getDropTarget(targetType:Class=null):DisplayObject{
			var pos:Point = new Point(_stage.mouseX,_stage.mouseY);
			if(targetType == null){
				targetType = DisplayObject;
			}
			var targets:Array = _stage.getObjectsUnderPoint(pos);
			var n:int = targets.length;
			for(var i:int=n-1; i>=0; i--){
				var tar:DisplayObject = targets[i];
				if(tar is targetType && tar != _dragIcon && !_dragIcon.contains(tar)){
					return tar;
				}
			}
			return null;
		}
		
		
	}
}