package
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	/**
	 * 将MovieClip对象转换为位图信息数组
	 * 并可以输出为ByteArray 
	 * 转换时绘制最小包围框
	 * 
	 * 该函数用于游戏编辑工具
	 * 故处理效率上不做太多考虑。
	 * @author Ryan
	 * 
	 */	
	public class BitmapWriter
	{
		public var data:Array = [];
		public function BitmapWriter(mc:MovieClip)
		{
			var i : int = 1;
			while( i <= mc.totalFrames ){
				mc.gotoAndStop(i);
				// 这种方式得到的包围框，如果有透明区也会包含在内。
				// 所以需要手动抠图。
				// 如果要取到不包含透明区的，只用BitmapUtil中的函数
				// 该函数从0，0开始检测
				// 所以制作效果swf时，尽量不要在负的坐标区域绘制东西。
				var rect:Rectangle = mc.getBounds(mc);
				var bmp:BitmapData = new BitmapData(rect.width,rect.height,true,0);
				bmp.draw(mc,new Matrix(1,0,0,1,-rect.left,-rect.top));
				
				// 每绘制完检查是否与之前的一样。
				// 如果一样，则记录下标ID。
				var id:int = checkPre(bmp);
				
				var obj:Object = {};
				obj.x = rect.left;
				obj.y = rect.top;
				
				if( id >= 0 ){
					obj.dataId = id;
				}else{
					obj.data = bmp;
				}
				data.push(obj);
				i++;
			}
			// encode
			for each( var info:Object in data ){
				if( info.data ){
					info.data = encode(info.data);
				}
			}
			trace("mc length:", data.length );
		}
		
		private function encode(data:BitmapData):ByteArray{
			var bytes:ByteArray = new ByteArray();
			bytes.writeShort(data.width);
			bytes.writeShort(data.height);
			bytes.writeBoolean(data.transparent);
			var bmpData:ByteArray = data.getPixels(data.rect);
			bytes.writeBytes( bmpData );
			bytes.compress();
			return bytes;
		}
		
		/**
		 * 检查是否与已有的一样，如果一样，则返回下标id
		 * 否则返回-1 
		 * @param data
		 * @return 
		 * 
		 */		
		private function checkPre( bmp :BitmapData ) : int {
			var i:int = 0;
			while( i < data.length ){
				var obj:Object = data[i];
				if( obj.data ){
					var code:Object = bmp.compare( obj.data as BitmapData );
					if( code == 0 ){
						trace("Reuse Bitmap:",i);
						return i;
					} else {
						if( code is BitmapData ){
							if( checkUnlike( code as BitmapData ) < bmp.width ){
								return i;
							}
						}
					}
				}
				i++;
			}
			return -1;
		}
		
		/**
		 * 检查误差度 
		 * @param bmp
		 * @return 
		 * 
		 */		
		private function checkUnlike( bmp:BitmapData):int{
			var count:uint = 0;
			for( var i:int = 0 ;i<bmp.width;i++){
				for(var j:int =0;j<bmp.height;j++){
					var color:uint = bmp.getPixel( i,j );
					if( color !=0 ){
						count++;
					}
				}
			}
			return count;
		}
	}
}