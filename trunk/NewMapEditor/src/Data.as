package{
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	/**
	 * @author heyaolong
	 * 
	 * 2012-7-16
	 */ 
	public class Data{
		public static var file:File = null;
		public static var main:NewMapEditor = null;
		
		
		public static var path:String;
		
		public static var mapId:int;
		public static var mapWidth:int;
		public static var mapHeight:int;
		public static var stepX:int;
		public static var stepY:int;
		public static var itemInfoList:Array;
		public static var bitmapData:BitmapData;
		//这个数据不解压,容易出错,使用时复制一份,效率????
		public static var wallInfo:ByteArray = new ByteArray;
		public function Data()
		{
		}
	}
}