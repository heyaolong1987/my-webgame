package com.netease.webgame.core.view.vc.component {
	
	import com.netease.webgame.bitchwar.interfaces.IProToolTipManagerClient;
	import com.netease.webgame.bitchwar.view.component.core.managers.ProToolTipManager;
	
	import mx.containers.Canvas;

	/**
	 * 继承了自身protooltip接口的canvas.主要用于整个控件都需要显示tooltip的情况。 
	 * @author zhp
	 */	
	public class ProTooltipCanvasImpl extends Canvas implements IProToolTipManagerClient {
		
		public function ProTooltipCanvasImpl(){
			super();
		}
		
		protected var _toolTipData:Object;
		protected var _toolTipDataFunction:Function;
		protected var _toolTipClass:Class;
		protected var _toolTipShowDelay:int;
		protected var _toolTipLayoutDirection:int = 0;
		
		public function set toolTipData(value:Object):void {
			_toolTipData = value;
			invalidateProperties();
		}
		
		public function get toolTipData():Object {
			return _toolTipData;
		}
		
		public function set toolTipClass(value:Class):void {
			_toolTipClass = value;
		}
		
		public function get toolTipClass():Class {
			return _toolTipClass;
		}
		
		public function set toolTipShowDelay(value:int):void {
			_toolTipShowDelay = value;
		}
		
		public function get toolTipShowDelay():int {
			return _toolTipShowDelay;
		}
		
		public function get toolTipDataFunction():Function {
			return _toolTipDataFunction;
		}
		
		public function set toolTipDataFunction(value:Function):void {
			_toolTipDataFunction = value;
			invalidateProperties();
		}
		
		public function set toolTipLayoutDirection(value:int):void {
			_toolTipLayoutDirection = value;
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
			if(_toolTipData==null && _toolTipDataFunction==null){
				ProToolTipManager.getInstance().unRegisterToolTip(this);
			} else{
				ProToolTipManager.getInstance().registerToolTip(this);
			}
		}
		
	}
}