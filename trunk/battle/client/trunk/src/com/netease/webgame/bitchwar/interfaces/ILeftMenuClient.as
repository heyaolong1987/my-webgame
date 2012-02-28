/**
 * Author:  Wang Xing
 * Created at: Jun 16, 2009
 */
package com.netease.webgame.bitchwar.interfaces. {
	public interface ILeftMenuClient {
		function set menuItems(value:Object):void;
		function get menuItems():Object;
		
		/** label field of the menu item */
		function set menuLabelField(value:String):void;
		function get menuLabelField():String;
		
		function menuSelectedHandler(selectedItem:Object, selectedLabel:String):void;
	}
}