package test {
	import com.netease.webgame.bitchwar.view.component.core.events.AdvancedMouseEvent;
	import com.netease.webgame.bitchwar.interfaces.ILeftMenuClient;
	import com.netease.webgame.bitchwar.component.gridClasses.gridCellClass.BaseGridCell;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class ShapeGridCell extends BaseGridCell implements ILeftMenuClient {
		
		public function ShapeGridCell() {
			
		}
		public function set menuItems(value:Object):void {
			
		}
		
		public function get menuItems():Object {
			return ["创建"];
		}
		
		/** label field of the menu item */
		public function set menuLabelField(value:String):void {
			
		}
		
		public function get menuLabelField():String {
			return null;
		}
		
		override protected function clickHandler(event:MouseEvent):void {
			dispatchEvent(new AdvancedMouseEvent(AdvancedMouseEvent.ITEM_CLICK));
		}
		
		public function menuSelectedHandler(selectedItem:Object, selectedLabel:String):void {
			dispatchEvent(new Event("createShape"));
		}
		
	}
}