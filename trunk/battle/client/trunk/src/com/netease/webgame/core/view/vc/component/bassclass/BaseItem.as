package com.netease.webgame.core.view.vc.component.bassclass
{
	import com.netease.webgame.bitchwar.model.vo.baseclass.BaseItemVO;
	import com.netease.webgame.core.cacher.ResCacher;
	import com.netease.webgame.core.events.ResEvent;
	import com.netease.webgame.core.res.ResGraphic;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	
	public class BaseItem extends UIComponent
	{
		public static var DEFAULT_RES_URL:String;
		
		public static var RES_URL_PREFIX:String;
		
		public static var RES_URL_POSTFIX:String;
		
		
		/**
		 *数据对象 
		 */
		protected var _data:*;
		
		/**
		 *资源路径 
		 */
		protected var _resUrl:String;
		/**
		 *资源 
		 */
		protected var res:ResGraphic;
		
		protected var defaultDir:int = 1;
		protected var defaultBehavior:int = 0;
		
		public function BaseItem(value:BaseItemVO)
		{
			
			mouseChildren = false;
			data = value;
			setResUrl();
			initComponent();
			addListeners();
			loadDefaultRes();
			validateDisplayList();
		}
		/**
		 *设置资源url 
		 * 
		 */
		protected function setResUrl():void{
			_resUrl = RES_URL_PREFIX+baseItemVO.resName+RES_URL_POSTFIX;
		}
		/**
		 *初始化组件
		 * 
		 */
		protected function initComponent():void{
		}
		
		protected function loadDefaultRes():void{
			ResCacher.getInstance().loadRes(DEFAULT_RES_URL,defaultResLoadCompleteHandler);
		}
		protected function defaultResLoadCompleteHandler(event:ResEvent):void{
			if(event.data){
				setRes(event.data);
			}
			loadRes();
		}
		protected function loadRes():void{
			ResCacher.getInstance().loadRes(_resUrl,resLoadCompleteHandler);
		}
		protected function resLoadCompleteHandler(event:ResEvent):void{
			setRes(event.data);
		}
		protected function setRes(value:Object):void{
			if(res){
				defaultDir = res.dir;
				defaultBehavior = res.behavior;
				if(res.parent){
					res.parent.removeChild(res);
				}
				res.unload();
				res = null;
			}
			var str:String = value.id as String;
			if ( value.info ){
				ResCacher.getInstance().loadRes(RES_URL_PREFIX + str.substr(7,str.length - 7) +"_1"+RES_URL_POSTFIX);
			}
			
			res = new ResGraphic(_resUrl, value as MovieClip);
			res.play(defaultDir,defaultBehavior);
			//res.x = -res.baseX;
			//res.y = -res.baseY;
			res.x = 10;
			res.y = 10;
			res.alpha = alpha;
			addChild( res );
			res.enterFrameCallback = enterFrameCallback;
			res.callBack = actionEnd;
			//initDir();		
			
		}
		
		/**
		 *获取对象数据 
		 * @param value
		 * 
		 */
		private function get baseItemVO():BaseItemVO{
			return data as BaseItemVO;
		}
		/**
		 *添加侦听器 
		 * 
		 */
		protected function addListeners():void{
			addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
		}
		/**
		 *获取对象数据 
		 * @param value
		 * 
		 */
		public function get data():*{
			return _data;
		}
		public function set data(value:*):void{
			_data = value;
		}
		
		/**
		 *鼠标按下 
		 * @param event
		 * 
		 */
		private function mouseDownHandler(event:MouseEvent):void{
			
		}
		// 没一帧调用
		public function enterFrameCallback(cg:ResGraphic):void{
		}
		protected function actionEnd(cg:* = null) : void {
			
		}
		
	}
}