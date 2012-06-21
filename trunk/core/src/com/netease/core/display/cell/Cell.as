package com.netease.core.display.cell{
	import com.netease.core.res.ResLoader;
	import com.netease.core.res.ResProgresser;

	/**
	 * @author heyaolong
	 * 
	 * 2011-11-2
	 */ 
	public class Cell extends BaseCell{
		public function Cell()
		{
			normalFillData = BitmapDataUtil.baseCell;
		}
		override protected function loadIcon():void{
			if(_data){
				if(icon.bitmapData==null){
					ResLoader.getInstance().load(ResPathUtil.getInstance().getItemUrl(data.tempId),icon,ResProgresser.loadSwf2PngFunc);
				}
			}
			else{
				icon.bitmapData = null;
			}
			
		}
		
	}
}