package tools {
	
	import com.netease.webgame.bitchwar.component.mapClasses.village.BuildingGrid;
	import com.netease.webgame.bitchwar.model.vo.building.VillageBuildingVO;
	import com.netease.webgame.bitchwar.util.AssetUtil;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class AdvancedBuildingGrid extends BuildingGrid {
		
		public static var BUILDING_MOUSE_DOWN:String = "BUILDING_MOUSE_DOWN";
		
		protected var statusMc:MovieClip;
		
		public function AdvancedBuildingGrid() {
			super();
			_label.addEventListener(MouseEvent.MOUSE_DOWN, labelMouseDownHandler);
			_container.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		public function relayoutStatusMc():void {
			invalidateDisplayList();
		}
		
		protected function mouseDownHandler(event:MouseEvent):void {
			dispatchEvent(new Event(BUILDING_MOUSE_DOWN));
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		override protected function createStatusMc(i:int):MovieClip {
			var point:Point = _statusIconPositionFunction.apply(null, [data, i+1]);
			var mc:MovieClip = AssetUtil.getBuildingStatusMc(VillageBuildingVO(data).buildingType, Math.max(1, boundIndex)*10+(i+1));
			mc.mouseChildren = false;
			mc.play();
			mc.x = point.x;
			mc.y = point.y;
			mc.addEventListener(MouseEvent.MOUSE_DOWN, statusMouseDownHandler);
			mc.mouseEnabled = true;
			addChild(mc);
			return mc;
		}
		
		protected function labelMouseDownHandler(event:MouseEvent):void {
			if(stage==null){
				_label.removeEventListener(MouseEvent.MOUSE_DOWN, labelMouseDownHandler);
			} else {
				_label.startDrag();
				stage.addEventListener(MouseEvent.MOUSE_UP, labelMouseUpHandler);
			}
		}
		
		protected function labelMouseUpHandler(event:MouseEvent):void {
			event.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, labelMouseUpHandler);
			_label.stopDrag();
			var point:Point = _labelPositionFunction.apply(null, [data]);
				point.x = _label.x + _label.width/2;
				point.y = _label.y + _label.height;
		}
		
		protected function statusMouseDownHandler(event:MouseEvent):void {
			statusMc = event.currentTarget as MovieClip;
			statusMc.startDrag();
			if(stage==null){
				statusMc.removeEventListener(MouseEvent.MOUSE_DOWN, statusMouseDownHandler);
			} else {
				stage.addEventListener(MouseEvent.MOUSE_UP, statusMouseUpHandler);
			}
		}
		
		protected function statusMouseUpHandler(event:MouseEvent):void {
			event.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, statusMouseUpHandler);
			var i:int;
			var point:Point;
			statusMc.stopDrag();
			for(i=0; i<statusMcList.length; i++) {
				if(statusMcList[i]==statusMc) {
					point = _statusIconPositionFunction.apply(null, [data, i+1]);
					point.x = statusMc.x;
					point.y = statusMc.y;
					break;
				}
			}
		}
	}
}