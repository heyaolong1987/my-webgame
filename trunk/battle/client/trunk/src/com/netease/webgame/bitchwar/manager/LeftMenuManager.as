/**
 * Author:  Wang Xing
 * Created at: Jun 16, 2009
 */
package com.netease.webgame.bitchwar.manager {
	import com.netease.webgame.bitchwar.component.AdvancedMenu;
	import com.netease.webgame.core.events.GMouseEvent;
	import com.netease.webgame.bitchwar.interfaces..ILeftMenuClient;
	import com.netease.webgame.bitchwar.config.constants.MouseConstants;
	import com.netease.webgame.bitchwar.model.Global;
	import com.netease.webgame.bitchwar.model.Model;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.controls.Menu;
	import mx.core.Application;
	import mx.core.mx_internal;
	import mx.events.MenuEvent;

	use namespace mx_internal;
	
	public class LeftMenuManager {		
		
		private static var instance:LeftMenuManager;
		
		private var stage:Stage;
		private var menu:Menu;
		private var curTarget:ILeftMenuClient;
		
		public function LeftMenuManager() {
			if (instance) {
				throw Error("***Only one LeftMenuManager can be constructed***");
			}
		}
		
		public static function getInstance():LeftMenuManager {
			if (!instance) {
				instance = new LeftMenuManager();
			}
			return instance;
		}
		
		public function initialize(theStage:Stage):void {
			stage = theStage;
			stage.addEventListener(GMouseEvent.ITEM_CLICK, itemClickHandler, true);
		}
		
		/**
		 * mouse down on the stage.
		 * show the menu or hide it.
		 */ 
		private function itemClickHandler(event:GMouseEvent):void {
			var model:Model = Model.getInstance();
			if((Global.mouseMode!=MouseConstants.MOUSE_NORMAL && Global.mouseMode!=MouseConstants.MOUSE_MAP_HERO) || event.shiftKey){
				return;
			}
			var target:ILeftMenuClient = event.target as ILeftMenuClient;
			if (target) { 
				curTarget = target;
				if (curTarget.menuItems) {
					createMenu();
//					ProPopUpManager.bringToFront(menu);
					menu.show(-10000, -10000);
					menu.validateNow();
					//
					var w:Number = menu.getExplicitOrMeasuredWidth();
					var h:Number = menu.getExplicitOrMeasuredHeight();
					var xpos:int;
					var ypos:int;
					var point:Point;
					if(!isNaN(event.localY) && !isNaN(event.localX)) {
						point = DisplayObject(target).localToGlobal(new Point(event.localX, event.localY));
						xpos = point.x;
						ypos = point.y;
					} else {
						xpos = stage.mouseX;
						ypos = stage.mouseY;
					}
					menu.x = Math.min(stage.stageWidth- w, xpos);
					menu.y = Math.min(stage.stageHeight - h, ypos);
				}
			} else { 
				hideMenu();
				curTarget = null;
			}
		}
		
		private function menuItemClickHandler(event:MenuEvent):void {
			if (curTarget) {
				curTarget.menuSelectedHandler(event.item, event.label);
			}
		}
		
		/**
		 * hide the menu if ESC key down.
		 */ 
		private function stageKeyDownHandler(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.ESCAPE) {
				hideMenu();
			}
		}
		/***获取leftMenuManger创建并显示出来的当前menu****/
		public function get currentMenu():Menu {
			return menu;
		}
		
		private function hideMenu():void {
			if(menu){
				menu.hide();
				menu = null;
			}
		}
		
		private function createMenu():void {
			if (!menu) {
				menu = new AdvancedMenu();
				Menu.popUpMenu(menu, Application.application as DisplayObjectContainer, null);
//		        menu = ProPopUpManager.createPopup(AdvancedMenu, null, false) as Menu;
//				menu.width = 100;
				menu.rowHeight = 25;
		        menu.labelField = curTarget.menuLabelField?curTarget.menuLabelField:"@label";
				menu.addEventListener(MenuEvent.ITEM_CLICK, menuItemClickHandler);
				menu.addEventListener(MenuEvent.MENU_HIDE, menuHideHandler);
			}
			else{
				if(menu.stage==null){
//					ProPopUpManager.addPopup(menu);
					Menu.popUpMenu(menu, Application.application as DisplayObjectContainer, null);
				}
			}
			menu.dataProvider = curTarget.menuItems;
		}
		
		private function menuHideHandler(event:MenuEvent):void {
			hideMenu();
		}
		
	}
}