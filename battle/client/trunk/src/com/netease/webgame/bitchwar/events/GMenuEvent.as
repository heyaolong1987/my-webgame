/**
 * Author:  Wang Xing
 * Created at: July 02, 2009
 */
package com.netease.webgame.bitchwar.events {
	
	import flash.events.Event;

	public class GMenuEvent extends Event {
		
		public var menuLabel:String;
		public var menuItem:Object;
		public var data:Object;
		
		public static const MENU_SELECT:String = "menuSelect";
		
		public function GMenuEvent(menuLabel:String, menuItem:Object, data:Object = null) {
			super(MENU_SELECT);
			this.menuLabel = menuLabel;
			this.menuItem = menuItem;
			this.data = data;
		}
		
	}
}