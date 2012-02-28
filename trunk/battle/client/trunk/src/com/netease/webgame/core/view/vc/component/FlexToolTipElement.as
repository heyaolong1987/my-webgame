package com.netease.webgame.core.view.vc.component {

	import com.netease.webgame.bitchwar.interfaces.IProToolTipManagerClient;
	import com.netease.webgame.bitchwar.view.component.core.managers.ProToolTipManager;
	
	import mx.core.UIComponent;
	
	public class FlexToolTipElement extends UIComponent implements IProToolTipManagerClient {
		
		protected var _toolTipData:Object;
		protected var _toolTipDataFunction:Function;
		protected var _toolTipClass:Class;
		protected var _toolTipShowDelay:int;
		protected var _toolTipLayoutDirection:int;
		
		public function FlexToolTipElement(){
			
		}
		
		public function set toolTipDataFunction(value:Function):void {
			this._toolTipDataFunction = value;
			invalidateProperties();
		}
		
		public function get toolTipDataFunction():Function {
			return this._toolTipDataFunction;
		}
		
		public function set toolTipClass(value:Class):void {
			this._toolTipClass = value;
			invalidateProperties();
		}
		
		public function get toolTipClass():Class {
			return this._toolTipClass;
		}
		
		public function set toolTipShowDelay(value:int):void {
			_toolTipShowDelay = value;
			invalidateProperties();
		}
		
		public function get toolTipShowDelay():int {
			return this._toolTipShowDelay;
		}
		
		public function set toolTipData(value:Object):void {
			_toolTipData = value;
			invalidateProperties();
		}
		
		public function get toolTipData():Object {
			return _toolTipData;
		}
		
		public function set toolTipLayoutDirection(value:int):void {
			_toolTipLayoutDirection = value;
			invalidateProperties();
		}
		
		public function get toolTipLayoutDirection():int {
			return _toolTipLayoutDirection;
		}
		
		public function registerToolTip(tipData:Object, tipClass:Class=null, tipFunction:Function=null, layoutDirection:int=0, showDelay:int=200):void {
			toolTipData = tipData;
			toolTipClass = tipClass;
			toolTipDataFunction = tipFunction;
			toolTipShowDelay = showDelay;
			toolTipLayoutDirection = layoutDirection;
			invalidateProperties();
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			if(toolTipData==null && toolTipDataFunction==null){
				ProToolTipManager.getInstance().unRegisterToolTip(this);
			} else{
				ProToolTipManager.getInstance().registerToolTip(this);
			}
		}
		
	}
}