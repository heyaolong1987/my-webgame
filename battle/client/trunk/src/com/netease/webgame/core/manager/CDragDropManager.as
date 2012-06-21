/**
 * Author: 小神仙
 * Created at: 2010-03-02
 */ 
package com.netease.webgame.core.manager {
	import com.netease.webgame.bitchwar.component.BaseWindow;
	import com.netease.webgame.core.events.DragDropEvent;
	import com.netease.webgame.bitchwar.interfaces..IDragDropGrid;
	import com.netease.webgame.bitchwar.config.constants.MouseConstants;
	import com.netease.webgame.bitchwar.model.Global;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	public class CDragDropManager {
		
		private static var instance:CDragDropManager;
		
		private var cursorScale:Number = 1;
		
		private var dragging:Boolean;
		
		private var point:Point = new Point();
		
		private var dragEvent:DragDropEvent;
		
		private var dropGrid:IDragDropGrid;
		
		private var dragMc:Sprite;
		private var dragMatrix:Matrix;
		
		private var preHightLightDic:Dictionary;
		
		private var stage:Stage;
		
		private var _activated:Boolean = true;

		public static function getInstance():CDragDropManager {
			if (!instance) {
				instance = new CDragDropManager();
			}
			return instance;
		}
		
		public function set activated(value:Boolean):void {
			_activated = value;
		}
		
		public function get activated():Boolean {
			return _activated;
		}
		
		public function initialize(stage:Stage):void {
			this.stage = stage;
			this.dragMc = new Sprite();
			this.dragMc.mouseEnabled = false;
			this.dragMatrix = new Matrix();
			this.preHightLightDic = new Dictionary(true);
		}
		
		public function registerDragable(grid:IDragDropGrid, dragable:Boolean):void {
			if(dragable){
				grid.addEventListener(DragDropEvent.DRAG_START, dragStartHandler, false, 0, true);
				grid.addEventListener(DragDropEvent.DRAG_STOP, dragStopHandler, false, 0, true);
			} else{
				grid.removeEventListener(DragDropEvent.DRAG_START, dragStartHandler);
				grid.removeEventListener(DragDropEvent.DRAG_STOP, dragStopHandler);
			}
		}
		
		public function registerPreHighlight(grid:IDragDropGrid, preHighlight:Boolean):void {
			if(preHighlight){
				preHightLightDic[grid] = grid;
			} else{
				delete preHightLightDic[grid];
			}
		}
		
		private function mouseMoveHandler(event:MouseEvent):void {
			if(dragging){
				var dropTarget:IDragDropGrid = getDropGrid();
				if(dropGrid && dropGrid!=dropTarget){
					dropGrid.dragOut(dragEvent);
				}
				dropGrid = dropTarget;
				if(dropGrid){
					if(preHightLightDic[dropGrid]!=null){
						return;
					}
					dropGrid.dragOver(dragEvent);
				}
			}
		}
		
		private function dragStopHandler(event:DragDropEvent):void {
			if(dragging && dragEvent!=null && dragEvent.dragGrid==event.target) {
				Global.mouseDragging = false;
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				Mouse.show();
				dragMc.stopDrag();
				stage.removeChild(dragMc);
				dragging = false;
				dragEvent = null;
			}
		}
		
		private function mouseUpHandler(event:MouseEvent):void {
			Global.mouseDragging = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			Mouse.show();
			if(dragging){
				dragMc.stopDrag();
				stage.removeChild(dragMc);
				dragging = false;
				if(!activated) {
					dragEvent = null;
					return;
				}
				var dropEvent:DragDropEvent;
				var dropTarget:IDragDropGrid = getDropGrid();
				if(dropGrid && dropGrid!=dropTarget){
					dropGrid.dragOut(dragEvent);
				}
				dropGrid = dropTarget;
				if(dropGrid){
					if(dropGrid.dragDrop(dragEvent)){
						dropEvent = new DragDropEvent(DragDropEvent.DRAG_DROP);
						dropEvent.copyProperties(dragEvent);
						dragEvent.dragGrid.dispatchEvent(dropEvent);
					} else{
						dropEvent = new DragDropEvent(DragDropEvent.DRAG_OUT);
						dropEvent.copyProperties(dragEvent);
						dropEvent.dropGrid = dropGrid;
						dragEvent.dragGrid.dispatchEvent(dropEvent);
					}
				} else{
					if(getBaseWindow(event)==null){
						dropEvent = new DragDropEvent(DragDropEvent.DRAG_OUT);
						dropEvent.copyProperties(dragEvent);
						dropEvent.dropGrid = null;
						dragEvent.dragGrid.dispatchEvent(dropEvent);
					}
				}
				for each(var dragGrid:IDragDropGrid in preHightLightDic){
					dragGrid.highLightDropable(dragEvent, false);
				}
				dragEvent = null;
			}
		}
		
		private function getBaseWindow(event:MouseEvent):BaseWindow {
			var stage:Stage = event.currentTarget as Stage;
			point.x = stage.mouseX;
			point.y = stage.mouseY;
			var targetList:Array = stage.getObjectsUnderPoint(point);
			var mouseitem:DisplayObject;
			while(targetList.length>0){
				mouseitem = targetList.pop();
				while(mouseitem&&mouseitem!=stage){
					if(mouseitem is BaseWindow){
						return mouseitem as BaseWindow;
						break;
					}
					mouseitem = mouseitem.parent;
				}
			}
			return null;
		}
		
		private function getDropGrid():IDragDropGrid {
			point.x = stage.mouseX;
			point.y = stage.mouseY;
			var targetList:Array = stage.getObjectsUnderPoint(point);
			var mouseitem:DisplayObject;
			if(targetList.length>0){
				mouseitem = targetList.pop();
				while(mouseitem&&mouseitem!=stage){
					if(mouseitem is IDragDropGrid){
						return mouseitem as IDragDropGrid;
						break;
					}
					mouseitem = mouseitem.parent;
				}
			}
			return null;
		}
		
		private function dragStartHandler(event:DragDropEvent):void {
			if(!activated) {
				return;
			}
			if(!dragging && Global.mouseMode==MouseConstants.MOUSE_NORMAL){
				Global.mouseDragging = true;
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				var source:BitmapData = event.dragSource;
				var dragWidth:int =  int(source.width*event.dragScaleX*cursorScale);
				var dragHeight:int =  int(source.height*event.dragScaleY*cursorScale);
				dragging = true;
				dragEvent = event;
				dragEvent.dragIcon = dragMc;
				dragMatrix.a = dragWidth/source.width;
				dragMatrix.d = dragHeight/source.height;
				dragMc.graphics.clear();
				if(source) {
					dragMc.graphics.beginBitmapFill(source, dragMatrix, false, true);
					dragMc.graphics.drawRect(0, 0, dragWidth, dragHeight);
					dragMc.graphics.endFill();
				}
				
				dragMc.graphics.beginFill(0xFFFFFF, 1);
				dragMc.graphics.moveTo(0, 0);
				dragMc.graphics.lineTo(6, 0);
				dragMc.graphics.lineTo(0, 6);
				dragMc.graphics.lineTo(0, 0);
				dragMc.graphics.endFill();
				
				dragMc.x = stage.mouseX + 2;
				dragMc.y = stage.mouseY + 2;
				dragMc.startDrag();
				stage.addChild(dragMc);
				Mouse.hide();
				for each(var dragGrid:IDragDropGrid in preHightLightDic){
					dragGrid.highLightDropable(dragEvent);
				}
				mouseMoveHandler(null);
			}
		}
		
	}
}