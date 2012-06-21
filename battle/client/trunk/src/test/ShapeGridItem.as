/**
 * Author:  小神仙
 * Created at: 2010-03-02
 */
package test {
	
	import com.netease.webgame.bitchwar.interfaces.IDragDropItem;
	import com.netease.webgame.bitchwar.interfaces.IDragDropItemData;
	import com.netease.webgame.bitchwar.interfaces.ILeftMenuClient;
	import com.netease.webgame.bitchwar.component.itemClasses.AbstractItem;
	
	import flash.display.BitmapData;
	
	public class ShapeGridItem extends AbstractItem implements ILeftMenuClient, IDragDropItem {
		
		public static var dragTimeout:int = 200;
		public static var clickTimeout:int = 200;
		
		public function ShapeGridItem(){
			
		}
		
		override public function set enabled(value:Boolean):void {
			mouseChildren = value;
		}
		
		override public function set data(value:IDragDropItemData):void {
			_data = value;
			graphics.clear();
			for(var i:int=0; i<value.shapeData.length; i++){
				for (var j:int=0; j<value.shapeData[i].length; j++){
					if(value.shapeData[i][j]==1){
						graphics.beginFill(0xffff00);
						graphics.drawRect(j*32, i*32, 24, 24);
						graphics.endFill();
					}
				}
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
		}
		
		override public function get dragIcon():BitmapData {
			var bit:BitmapData = new BitmapData(this.data.shapeData[0].length*32, this.data.shapeData.length*32, true, 0x00FFFFFF);
			bit.draw(this, null, null, null, null, false);
			return bit;
		}
		
		override public function get dragScaleX():Number {
			return 1;
		}
		
		override public function get dragScaleY():Number {
			return 1;
		}
		
		
	}
}