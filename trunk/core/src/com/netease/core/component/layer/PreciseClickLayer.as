package com.netease.core.component.layer{
	import com.netease.core.events.PreciseClickEvent;
	import com.netease.core.interfaces.IPreciseClickAble;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * @author heyaolong
	 * 
	 * 2012-7-26
	 */
	public class PreciseClickLayer extends Sprite{
		private var _cInteractiveItem:InteractiveObject;
		private var _evt:MouseEvent;
		public function PreciseClickLayer() {
			super();
			mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		private function onMouseMove(evt:MouseEvent):void {
			_evt = evt;
			var gpt:Point = new Point(evt.stageX, evt.stageY);
			var lpt:Point, matrix:Matrix;
			var bmpdata:BitmapData = new BitmapData(1, 1, true, 0x00000000);
			var objects:Array = this.getObjectsUnderPoint(gpt);
			var obj:DisplayObject;
			cInteractiveItem = null;
			//过滤出当前点底下需要交互的mapitem
			for(var i:int=objects.length-1; i>=0; i--) {
				obj = objects[i];
				do{
					if(obj is IPreciseClickAble && obj is InteractiveObject && InteractiveObject(obj).mouseEnabled == true){
						break;
					}
					else{
						if(obj.parent != this){
							obj = obj.parent; 
						}
						else{
							break;
						}
						
					}
				}while(true);
				if(obj is IPreciseClickAble && obj is InteractiveObject){
					//找出一个非透明的需要交互的item
					lpt = InteractiveObject(obj).globalToLocal(gpt);
					matrix = new Matrix(1, 0, 0, 1, -lpt.x, -lpt.y);
					bmpdata.draw(InteractiveObject(obj), matrix);
					//透明
					if(bmpdata.getPixel32(0,0) >> 24 == 0x00) {
						continue;
					}
					else {
						cInteractiveItem = obj as InteractiveObject;
						break;
					}
				}
			}
		}
		
		/**
		 * 内部设置当前交互的mapitem 
		 */		
		private function set cInteractiveItem(value:InteractiveObject):void {
			if(_cInteractiveItem != value) {
				if(_cInteractiveItem) {
					dispatchEvent(new PreciseClickEvent(PreciseClickEvent.ITEM_OUT,_evt.localX,_evt.localY, _cInteractiveItem));
				}
				_cInteractiveItem = value;
				if(_cInteractiveItem) {
					dispatchEvent(new PreciseClickEvent(PreciseClickEvent.ITEM_OVER,_evt.localX,_evt.localY, _cInteractiveItem));
				}
			}
		}
		
		private function onRollOut(evt:MouseEvent):void {
			_evt = evt;
			cInteractiveItem = null;
		}
		
		private function onClick(evt:MouseEvent):void {
			_evt = evt;
			if(_cInteractiveItem) {
				//对该item进行交互
				dispatchEvent(new PreciseClickEvent(PreciseClickEvent.ITEM_CLICK,_evt.localX,_evt.localY,_cInteractiveItem));
			}
		}
	}
}