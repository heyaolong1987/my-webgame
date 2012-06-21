package com.netease.webgame.bitchwar.manager {
	import com.netease.webgame.bitchwar.interfaces.IPopUpWindow;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	
	internal class ProPopUpItem {
		
		public var childList:int;
		public var modal:Boolean;
		public var modalAlpha:Number;
		public var modalColor:int;
		public var instance:DisplayObject;
		
		public var topElement:IFlexDisplayObject;
		
		private var _mask:UIComponent;
		
		public function ProPopUpItem(){
			
		}
		
		public function set mask(value:UIComponent):void {
			if(_mask) {
				_mask.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			}
			_mask = value;
			if(_mask) {
				_mask.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			}
		}
		
		public function get mask():UIComponent {
			return _mask;
		}
		
		private function mouseDownHandler(event:MouseEvent):void {
			if(instance is IPopUpWindow) {
				IPopUpWindow(instance).modalAreaClick();
			}
		}
		
	}
}