package tools
{
	import com.netease.webgame.core.view.vc.component.CDisplayObject;
	import com.netease.webgame.bitchwar.interfaces.IDragDropItemData;
	import com.netease.webgame.bitchwar.config.BuffTemplate;
	import com.netease.webgame.bitchwar.util.AssetUtil;
	
	public class ToolBuffItem extends CDisplayObject
	{
		public function ToolBuffItem()
		{
			super();
		}
		
		public function set data(value:Object):void {
			if (value == null) {
				source = null;
				return;
			}
			source = AssetUtil.getBuffImg(BuffTemplate(value).id);
			this.registerToolTip(BuffTemplate(value).name + '\n' + BuffTemplate(value).desc);
		}
	}
}