package{
	/**
	 * @author heyaolong
	 * 
	 * 2011-11-3
	 */ 
	public class ResPathUtil{
		public static const NPC_URL:String = "http://192.168.149.188/bitchwar/assets/imgSwf/npc/";
		public static const ITEM_URL:String = "http://192.168.149.188/bitchwar/assets/img/item/item_";
		public static const VERSION:String = "01.0028";
		public static const SWF2PNG:String = "swf2png";
		private static var _instance:ResPathUtil;
		public function ResPathUtil()
		{
		}
		public static function getInstance():ResPathUtil{
			if(_instance==null){
				_instance = new ResPathUtil();
			}
			return _instance;
		}
		public function getNpcUrl(name:String):String{
			return NPC_URL+name+".swf?"+VERSION+"&"+SWF2PNG;
		}
		public function getItemUrl(name:String):String{
			return ITEM_URL+name+".jpg?"+VERSION;
		}
	}
}