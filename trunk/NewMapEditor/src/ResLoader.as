package {
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import mx.messaging.AbstractConsumer;
	
	/**
	 * @author heyaolong
	 * 
	 * 2011-11-2
	 */ 
	public class ResLoader {
		public const MAX_FRESS_LOADER_NUM:int = 10;
		private var _freeLoaderList:Array = new Array(MAX_FRESS_LOADER_NUM);
		private var _loadingLoaderList:Dictionary = new Dictionary();
		private var _loadingFuncList:Dictionary = new Dictionary();
		private var _waitingFuncList:Array = [];
		private var _resCacher:ResCacher = ResCacher.getInstance();
		protected var _loaderContext:LoaderContext;
		
		private static var _instance:ResLoader;
		public function ResLoader()
		{
			createLoaderContext();
			createLoaders();
		}
		public static function getInstance():ResLoader{
			if(_instance==null){
				_instance = new ResLoader();
			}
			return _instance;
		}
		/**
		 *创建context 
		 * 
		 */
		protected function createLoaderContext():void{
			_loaderContext = new LoaderContext(true);
			_loaderContext.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);	
			
		}
		/**
		 *创建loader池 
		 * 
		 */
		protected function createLoaders():void{
			var num:int = MAX_FRESS_LOADER_NUM;
			var loader:Loader;
			for(var i:int=0; i< num; i++){
				loader = new Loader();
				var loaderInfo:LoaderInfo = loader.contentLoaderInfo;
				loaderInfo.addEventListener(Event.COMPLETE, onComplete);
				loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
				loaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				_freeLoaderList[i] = loader;
			}
		}
		
		/**
		 *载入资源 
		 * @param url
		 * @param client
		 * @param loadedFunc 回调参数 client,data
		 * 
		 */
		public function load(url:String,client:Object,loadedFunc:Function):void{
			var res:Object = _resCacher.getRes(url);
			if(res){
				loadedFunc(res);
				return;
			}
			if(_loadingFuncList[url]!=null){
				_loadingFuncList[url].push([client,loadedFunc]);
				return;
			}
			if(_freeLoaderList.length>0){
				var loader:Loader = _freeLoaderList.shift() as Loader;
				_loadingFuncList[url] = [[client,loadedFunc]];
				_loadingLoaderList[loader] = [loader,url];
				loader.load(new URLRequest(url),_loaderContext);
			}
			else{
				_waitingFuncList.push([url,client,loadedFunc]);
			}
			
			
		}
		/**
		 * 加载完成
		 */ 
		private function onComplete(e:Event):void {
			var info:LoaderInfo = e.currentTarget as LoaderInfo;
			var loader:Loader = info.loader;
			var url:String = _loadingLoaderList[loader][1];
			var funcList:Array = _loadingFuncList[url];
			_loadingFuncList[url] = null;
			_loadingLoaderList[loader] = null;
			if(funcList){
				var len:int = funcList.length;
				var func:Array;
				for(var i:int=0; i<len; i++){
					func = funcList[i];
					func[1](func[0],info.content);
				}
			}
			addLoaderToFreeList(loader);
		}
		protected function addLoaderToFreeList(loader:Loader):void{
			
			try{
				loader.close();
			}
			catch(e:Error){
			}
			loader.unloadAndStop();
			_freeLoaderList.push(loader);
			if(_freeLoaderList.length==1&&_waitingFuncList.length>0){
				var func:Array = _waitingFuncList.shift();
				load(func[0],func[1],func[2]);
			}
		}
		/**
		 * 出错事件
		 */ 
		private function onError(e:Event):void {
			var info:LoaderInfo = e.currentTarget as LoaderInfo;
			var loader:Loader = info.loader;
			addLoaderToFreeList(loader);
			if(e is IOErrorEvent){
				//Console.warn("未处理的IOErrorEvent：", e.toString());
			}
			else if(e is SecurityErrorEvent){
				//Console.warn("未处理的SecurityErrorEvent：", e.toString());
			}
			
		}
	}
}