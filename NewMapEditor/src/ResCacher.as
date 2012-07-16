package {
	import flash.utils.Dictionary;

	/**
	 * @author heyaolong
	 * 
	 * 2011-11-2
	 */ 
	public class ResCacher{
		private static var _instance:ResCacher;
		protected var _cacheDic:Dictionary = new Dictionary();
		public function ResCacher()
		{
		}
		public static function getInstance():ResCacher{
			if(_instance==null){
				_instance = new ResCacher();
			}
			return _instance;
		}
		public function addRes(key:Object,value:Object):void{
			_cacheDic[key] = value;	
		}
		public function getRes(key:Object):Object{
			return _cacheDic[key];
		}
	}
}