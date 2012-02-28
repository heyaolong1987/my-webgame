package tools
{
	import com.netease.flash.common.log.Console;
	import com.netease.flash.common.net.PoolResLoader;
	import com.netease.flash.common.net.ResLoaderEvent;
	import com.netease.flash.framework.puremvc.AbstractService;
	import com.netease.webgame.bitchwar.component.CommonAlert;
	import com.netease.webgame.bitchwar.component.mapClasses.map.config.MapDataConfig;
	import com.netease.webgame.bitchwar.config.Config;
	import com.netease.webgame.bitchwar.config.constants.Constants;
	import com.netease.webgame.bitchwar.model.vo.PreloadVO;
	import com.netease.webgame.bitchwar.util.AssetUtil;
	import com.netease.webgame.bitchwar.util.ConfigUtil;
	import com.netease.webgame.bitchwar.util.LayOutUtil;
	import com.netease.webgame.bitchwar.util.ResourceBundleUtil;
	import com.netease.webgame.bitchwar.view.popup.LoadingPopUp;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	/**
	 * 用于编辑器的预加载 
	 * @author zhp
	 * 
	 */	
	public class EditorPreloadProxy extends AbstractService
	{
		private var resList:Array;
		private var resIndex:int;
		
		/**
		 * 标记加载的阶段，0表示初始化必须的资源加载，1表示登陆后第二次加载
		 */ 
		private var queue:int;
		private var queueComplete:Boolean;
		
		private var queueCallBack:Boolean;
		
		public function EditorPreloadProxy(data:Object=null){
			super(data);
		}
		
		override public function onRegister():void {
			initLoadQueue();
		}
		
		public function initLoadQueue():void {
			var preload:PreloadVO;
			var loader:URLLoader;
			resIndex = 0;
			queue = 0;
			queueComplete = false;
			queueCallBack = true;
			
			resList = new Array();
			
//			//用户协议
//			preload = new PreloadVO();
//			preload.url = AssetUtil.getDatPath("agreement.dat");
//			preload.callback = new AgreementAsset();
//			preload.type = PreloadVO.BINARY;
//			resList.push(preload);
			
			
			
			//配置
			preload = new PreloadVO();
			preload.url = AssetUtil.getConfigPath("config.swf");
			preload.callback = ConfigUtil.getInstance();
			preload.type = PreloadVO.BINARY;
			resList.push(preload);
			
			preload = new PreloadVO();
			preload.url = AssetUtil.getConfigPath("layout.swf");
			preload.callback = LayOutUtil.getInstance();
			preload.type = PreloadVO.BINARY;
			resList.push(preload);
			
			preload = new PreloadVO();
			preload.url = AssetUtil.getConfigPath("maplayout.swf");
			preload.callback = MapDataConfig.instance;
			preload.type = PreloadVO.BINARY;
			resList.push(preload);
			
//			preload = new PreloadVO();
//			preload.url = AssetUtil.getSwfPath("fight_before.swf");
//			preload.callback = new FightBeforeAsset();
//			preload.type = PreloadVO.BINARY;
//			resList.push(preload);
			
//			preload = new PreloadVO();
//			preload.url = AssetUtil.getSwfPath("fight_end.swf");
//			preload.callback = new FightEndAsset();
//			preload.type = PreloadVO.BINARY;
//			resList.push(preload);
			
			if(!AssetUtil.fightRes.complete) {
				resList.push(AssetUtil.fightRes);
			}
			resList.push(AssetUtil.commonRes);
			if(!AssetUtil.clanBuildingRes.complete) {
				resList.push(AssetUtil.clanBuildingRes);
			}
			if(!AssetUtil.villageBuildingRes.complete) {
				resList.push(AssetUtil.villageBuildingRes);
			}
			if(!AssetUtil.mapRes.complete) {
				resList.push(AssetUtil.mapRes);
			}
//			if(!AssetUtil.faceRes.complete) {
//				resList.push(AssetUtil.faceRes);
//			}
//			if(!AssetUtil.heroMoveRes.complete) {
//				resList.push(AssetUtil.heroMoveRes);
//			}
			loadRes();
		}
		
		
		
		private function loadRes():void {
			var loader:Object;
			if(resIndex<resList.length){
				loader = resList[resIndex];
				if(loader is PreloadVO) {
					var urlLoader:URLLoader = new URLLoader();
					PreloadVO(loader).loader = urlLoader;
					urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
					urlLoader.addEventListener(Event.COMPLETE, completeHandler);
					urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
					urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
					urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
					urlLoader.load(new URLRequest(PreloadVO(loader).url));
				} else {
					PoolResLoader(loader).addEventListener(ResLoaderEvent.RES_LOADED, completeHandler);
					PoolResLoader(loader).addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
					PoolResLoader(loader).addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
					PoolResLoader(loader).addEventListener(ProgressEvent.PROGRESS, progressHandler);
					PoolResLoader(loader).load();
				}
			}else {
				LoadingPopUp.remove();
			}
		}
		
		private function completeHandler(event:Event):void {
			var loader:Object = resList[resIndex];
			if(loader is PreloadVO) {
				PreloadVO(loader).callback.loadComplete(PreloadVO(loader).loader.data, PreloadVO(loader).url);
			}
			resIndex++;
			removeAddedListeners(event.currentTarget as PoolResLoader, event.currentTarget as URLLoader);
			loadRes();
		}
		
		private function errorHandler(event:Event):void {
			LoadingPopUp.show("加载出错!", true);
			CommonAlert.alert(true, ResourceBundleUtil.LOAD_RESOURCE_FAIL);
			Console.debug(event);
			if(event.currentTarget is PoolResLoader) {
				removeAddedListeners(event.currentTarget as PoolResLoader);
			} else {
				removeAddedListeners(null, event.currentTarget as URLLoader);
			}
			var loader:Object = resList[resIndex];
			if(loader is PreloadVO && PreloadVO(loader).ignoreEnable == true) {
				resIndex++;
				loadRes();
			}
			
		}
		
		private function progressHandler(event:ProgressEvent):void {
			if(queueCallBack) {
				LoadingPopUp.show("正在加载资源 " + (resIndex+1) + "/" + resList.length, false,  int(100*(event.bytesLoaded/event.bytesTotal)) + "%", ((event.bytesLoaded/event.bytesTotal) + resIndex) / resList.length);
			}
		}
		
		private function removeAddedListeners(target:PoolResLoader, loader:URLLoader=null):void {
			if(target!=null) {
				target.removeEventListener(ResLoaderEvent.RES_LOADED, completeHandler);
				target.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
				target.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			}
			if(loader!=null) {
				loader.removeEventListener(Event.COMPLETE, completeHandler);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
				loader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			}
		}
		
	}
}
import com.adobe.utils.StringUtil;
import com.netease.webgame.bitchwar.interfaces.IPreloadClient;
import com.netease.webgame.bitchwar.config.Config;
import com.netease.webgame.bitchwar.util.AssetUtil;

import flash.utils.ByteArray;

class AgreementAsset implements IPreloadClient {
	public function loadComplete(data:Object, url:String):void {
		var str:String = String(data);
		AssetUtil.agreementData = String(data);
	}
}

