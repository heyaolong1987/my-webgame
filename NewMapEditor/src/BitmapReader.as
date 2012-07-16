package 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	/**
	 * 读取压缩的bitmapData数组。 
	 * @author Ryan
	 * 
	 */	
	public class BitmapReader
	{
		public var data:Array;
		public function BitmapReader(bytes:ByteArray)
		{
			data = bytes.readObject();
			var obj:Object;
			// decode
			for each( obj in data ){
				if( obj.data ){
					obj.data = decode(obj.data);
				}
			}
			// set reference
			for each( obj in data ){
				if( !obj.data ){
					obj.data = data[obj.dataId].data;
				}
			}
		}
		
		private static function decode(bytes:ByteArray):BitmapData{
			bytes.uncompress();
			var width:int = bytes.readShort();
			var height:int = bytes.readShort();
			var transparent:Boolean = bytes.readBoolean();
			
			var datas:ByteArray = new ByteArray();			
			bytes.readBytes(datas,0,bytes.bytesAvailable);
			var bmp:BitmapData = new BitmapData(width,height,transparent,0);
			bmp.setPixels(new Rectangle(0,0,width,height),datas);
			return bmp;
		}
	}
}