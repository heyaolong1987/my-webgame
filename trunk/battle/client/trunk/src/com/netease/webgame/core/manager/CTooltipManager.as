package com.netease.webgame.core.manager{
	import com.netease.webgame.core.interfaces.ICToolTip;
	import com.netease.webgame.core.interfaces.ICToolTipManagerClient;
	import com.netease.webgame.core.view.vc.component.CToolTip;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	
	import mx.controls.ToolTip;
	import mx.core.IToolTip;
	import mx.core.IUIComponent;
	import mx.core.Singleton;
	import mx.effects.IAbstractEffect;
	import mx.events.PropertyChangeEvent;
	import mx.managers.IToolTipManagerClient;

	/**
	 *
	 *@author heyaolong
	 *
	 *2011-10-13
	 */
	public class CToolTipManager extends EventDispatcher
	{
		private var _currentTarget:IToolTipManagerClient;
		private var _currentToolTip:ICToolTip;
		
		private static var _instance:CToolTipManager;
		private var _enabled:Boolean;
		private var _hideDelay:int;
		private var _showDelay:int;
		private var _stage:Stage;
		
		
		public function initialize(stage:Stage):void {
			this._stage = stage;
		}
		private static function get Instance():ToolTipManager
		{
			if (!_instance)
			{
				_instance = new ToolTipManager();
			}
			return _instance;
		}
		
		public static function get currentTarget():DisplayObject
		{
			return _currentTarget;
		}
		public static function set currentTarget(value:DisplayObject):void
		{
			_currentTarget = value;
		}
	
		public static function get _currentToolTip():ICToolTipManagerClient
		{
			return _currentToolTip;
		}
		
		public static function set _currentToolTip(value:ICToolTipManagerClient):void
		{
			_currentToolTip = value;
		}
		public static function get enabled():Boolean
		{
			return _enabled;
		}
	
		public static function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
	
		public static function get hideDelay():Number
		{
			return _hideDelay;
		}
		
		public static function set hideDelay(value:Number):void
		{
			_hideDelay = value;
		}

		public static function get showDelay():Number
		{
			return _showDelay;
		}

		public static function set showDelay(value:Number):void
		{
			_showDelay = value;
		}
		
		public static function get toolTipClass():ICToolTip{
			return _toolTipClass;
		}
		public static function set toolTipClass(value:ICToolTip):void{
			_toolTipClass = value;
		}
		
		private function registerToolTip(target:DisplayObject):void{
			target.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
			target.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
			target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			target.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		public function showToolTip(client:ICToolTipManagerClient):ICToolTip
		{
			//在mouseover后的，如果延时显示时已经从舞台移除
			if(client.stage == null) {
				return;
			}
			clearTimeout(showTimeout);
			if(_currentToolTip!=null){
				hideToolTip();
			}
			var toolTipData:Object = client.toolTipData;
			if(toolTipData==null){
				return;
			}
			_currentClient = client;
			var toolTipClass:Class  = client.toolTipClass;
			if(toolTipClass==null){
				toolTipClass = CToolTip;
			}
			_currentToolTip = ;
			if(_currentToolTip==null){
				_currentToolTip = new toolTipClass();
				instanceMap[toolTipClass] = _currentToolTip;
			}
			
			_currentToolTip.tipData = toolTipData;
			if(_currentToolTip is UIComponent) {
				ProPopUpManager.addPopup(UIComponent(_currentToolTip), Application.application as DisplayObject, false, ProPopUpChildList.TOP);
			} else{
				stage.addChild(_currentToolTip as DisplayObject);
			}
			
			if (_currentToolTip is UIComponent) {
				UIComponent(_currentToolTip).validateNow();
				UIComponent(_currentToolTip).setActualSize(UIComponent(_currentToolTip).getExplicitOrMeasuredWidth(),
					UIComponent(_currentToolTip).getExplicitOrMeasuredHeight());
			}
			var displayObj:DisplayObject = _currentToolTip as DisplayObject;
			if(client.toolTipLayoutDirection==ProToolTipLayoutDirection.TOP) {
				var point:Point = DisplayObject(client).localToGlobal(new Point(0, 0));
				displayObj.x = Math.min(stage.stageWidth-displayObj.width ,point.x + DisplayObject(client).width/2 - displayObj.width/2);
				displayObj.y = point.y - displayObj.height - 5;
			} else {
				displayObj.x = Math.max(0, Math.min(stage.stageWidth- displayObj.width-15, stage.mouseX + 15));
				displayObj.y = Math.max(0, Math.min(stage.stageHeight - displayObj.height-20, stage.mouseY + 20));
			}
			if (displayObj is DisplayObjectContainer) {
				DisplayObjectContainer(displayObj).mouseChildren = false;
				DisplayObjectContainer(displayObj).mouseEnabled = false;
			}
			if (currentWatcher) {
				currentWatcher.unwatch();
				currentWatcher = null;
			}
			currentWatcher = ChangeWatcher.watch(client, ['toolTipData'], clientDataChangeHandler);
		}
	
		public static function destroyToolTip(toolTip:ICToolTipManagerClient):void
		{
		}
		
		
		public function registerToolTip(target:ICToolTipManagerClientManagerClient):void {
		}
		
		public function unRegisterToolTip(target:ICToolTipManagerClient):void {
			target.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			target.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			target.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		private function onRemove(evt:Event):void {
			if(currentClient == evt.currentTarget && _currentToolTip!=null) {
				hideToolTip();
			}
		}
		
		public function updateToolTip(client:ICToolTipManagerClient):void {
			registerToolTip(client);
			if(currentClient!=null) {
				if(currentClient == client) {
					showToolTip(client);
				}
			} else {
				currentClient = client;
				showToolTip(client);
			}
		}
		
		public function update_currentToolTip():void {
			if(currentClient!=null) {
				updateToolTip(currentClient);
			}
		}
		
		private function mouseOverHandler(event:MouseEvent):void {
			var client:ICToolTipManagerClient = event.currentTarget as ICToolTipManagerClient;
			clearTimeout(showTimeout);
			if(client){
				event.stopImmediatePropagation();
				if(client==currentClient) {
					return;
				}
				if(client.toolTipShowDelay>0){
					showTimeout = setTimeout(showToolTip, client.toolTipShowDelay, client);
				} else{
					showToolTip(client);
				}
			}
		}
		
		private function mouseOutHandler(event:MouseEvent):void {
			clearTimeout(showTimeout);
			if(_currentToolTip!=null){
				hideToolTip();
			}
		}
		
		private function mouseDownHandler(event:MouseEvent):void {
			clearTimeout(showTimeout);
			if(_currentToolTip!=null){
				hideToolTip();
			}
		}
		private function clientDataChangeHandler(event:PropertyChangeEvent):void {
			if (_currentToolTip) {
				_currentToolTip.tipData = event.newValue;	
			}
		}
	}
}


