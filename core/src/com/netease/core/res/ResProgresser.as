package com.netease.core.res{
	import flash.display.Bitmap;
	import com.netease.core.display.cell.Cell;

	/**
	 * @author heyaolong
	 * 
	 * 2011-11-3
	 */ 
	public class ResProgresser{
		
		public function ResProgresser()
		{
		}
		public static function loadFunc(client:Object,data:Object):void{
			client.res = data;
		}
		public static function loadSwf2PngFunc(bitmap:Bitmap,data:Object):void{
			bitmap.bitmapData = data.bitmapData;
		}
		public static function loadBitGridResFunc(cell:Cell,data:Object){
			
		}
	}
}