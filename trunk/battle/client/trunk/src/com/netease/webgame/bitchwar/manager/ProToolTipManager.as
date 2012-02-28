/**
 * Author：小妖怪的天敌-小神仙
 * 修正：
 * 		游戏中的大多数ToolTip是随时变动的
 * 		Flex自带的ToolTip以及前一个版本的ProToolTipManager对这种灵活性较强的ToolTip支持不好
 * 添加:
 * 		添加了currentWatcher,侦听client的tooltipData,以达到在tooltipData改变时实时改变的效果(如:buff的 tooltip)
 */
package com.netease.webgame.bitchwar.manager {
	
	import com.netease.webgame.bitchwar.interfaces..IProToolTipManagerClient;
	import com.netease.webgame.bitchwar.interfaces..IToolTip;
	import com.netease.webgame.bitchwar.component.tooltip.BasicTooltip;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	
	public class ProToolTipManager {
		
		private static var instance:ProToolTipManager;
		
		private var stage:Stage;
		private var instanceMap:Dictionary = new Dictionary();
		
		private var showTimeout:int;
		
		private var currentToolTip:IToolTip;
		private var currentWatcher:ChangeWatcher;
		private var currentClient:IProToolTipManagerClient;
		
		public function ProToolTipManager() {
			if (instance != null) {
				throw new Error("");
			}
			instance = this;
		}
		
		public static function getInstance():ProToolTipManager {
			if (instance == null) {
				instance = new ProToolTipManager();
			}
			return instance;
		}
		
		public function initialize(stage:Stage):void {
			this.stage = stage;
		}
		
		public function registerToolTip(target:IProToolTipManagerClient):void {
			target.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
			target.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
			target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			//2011.3.2 target移除时，移除target当前显示的tooltip
			target.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		public function unRegisterToolTip(target:IProToolTipManagerClient):void {
			target.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			target.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			target.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		private function onRemove(evt:Event):void {
			if(currentClient == evt.currentTarget && currentToolTip!=null) {
				hideToolTip();
			}
		}
		
		public function updateToolTip(client:IProToolTipManagerClient):void {
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
		
		public function updateCurrentToolTip():void {
			if(currentClient!=null) {
				updateToolTip(currentClient);
			}
		}
		
		private function mouseOverHandler(event:MouseEvent):void {
			var client:IProToolTipManagerClient = event.currentTarget as IProToolTipManagerClient;
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
			if(currentToolTip!=null){
				hideToolTip();
			}
		}
		
		private function mouseDownHandler(event:MouseEvent):void {
			clearTimeout(showTimeout);
			if(currentToolTip!=null){
				hideToolTip();
			}
		}
		
		private function showToolTip(client:IProToolTipManagerClient):void {
			//在mouseover后的，如果延时显示时已经从舞台移除
			if((client as DisplayObject).stage == null) {
				return;
			}
			clearTimeout(showTimeout);
			var toolTipData:Object;
			var toolTipClass:Class;
			if(currentToolTip!=null){
				hideToolTip();
			}
			if(client.toolTipDataFunction==null){
				toolTipData = client.toolTipData;
			}
			else{
				toolTipData = client.toolTipDataFunction.apply();
			}
			if(toolTipData==null){
				return;
			}
			currentClient = client;
			toolTipClass = client.toolTipClass;
			if(toolTipClass==null){
				toolTipClass = BasicTooltip;
			}
			currentToolTip = instanceMap[toolTipClass];
			if(currentToolTip==null){
				currentToolTip = new toolTipClass();
				instanceMap[toolTipClass] = currentToolTip;
			}
			if (currentToolTip is UIComponent) {
				if (UIComponent(currentToolTip).initialized == false) {
					UIComponent(currentToolTip).initialize();
				}
			}
			currentToolTip.tipData = toolTipData;
			if(currentToolTip is UIComponent) {
				ProPopUpManager.addPopup(UIComponent(currentToolTip), Application.application as DisplayObject, false, ProPopUpChildList.TOP);
			} else{
				stage.addChild(currentToolTip as DisplayObject);
			}
			
			if (currentToolTip is UIComponent) {
				UIComponent(currentToolTip).validateNow();
				UIComponent(currentToolTip).setActualSize(UIComponent(currentToolTip).getExplicitOrMeasuredWidth(),
														   UIComponent(currentToolTip).getExplicitOrMeasuredHeight());
			}
			var displayObj:DisplayObject = currentToolTip as DisplayObject;
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
		
		private function clientDataChangeHandler(event:PropertyChangeEvent):void {
			if (currentToolTip) {
				currentToolTip.tipData = event.newValue;	
			}
		}
		
		private function hideToolTip():void {
			currentToolTip.tipData = null;
			if(currentToolTip is UIComponent){
				ProPopUpManager.hidePopup(UIComponent(currentToolTip));
			}
			else{
				stage.removeChild(currentToolTip as DisplayObject);
			}
			if (currentWatcher) {
				currentWatcher.unwatch();
				currentWatcher = null;
			}
			currentToolTip = null;
			currentClient = null;
		}
	}
}