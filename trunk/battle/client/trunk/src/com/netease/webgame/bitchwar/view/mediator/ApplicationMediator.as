package com.netease.webgame.bitchwar.view.mediator
{
	import com.netease.webgame.bitchwar.InnerCommandConstants;
	import com.netease.webgame.bitchwar.constants.application.ApplicationViewConstants;
	import com.netease.webgame.bitchwar.model.proxy.ApplicationProxy;
	import com.netease.webgame.bitchwar.view.vc.layer.GameViewLayer;
	import com.netease.webgame.bitchwar.view.vc.panel.login.LoginView;
	import com.netease.webgame.core.view.mediator.baseclass.BaseMediator;
	
	import org.puremvc.as3.interfaces.INotification;

	/**
	 *负责场景切换和全局管理 
	 * @author Administrator
	 * 
	 */
	public class ApplicationMediator extends BaseMediator
	{
		public static const NAME:String = "ApplicationMediator";
		private var applicationProxy:ApplicationProxy;
		
		public function ApplicationMediator(viewComponent:Object)	{
			super(ApplicationMediator.NAME,viewComponent);
			
		}
		override public function onRegister():void{
			super.onRegister();
			applicationProxy = retrieveProxy(ApplicationProxy.NAME) as ApplicationProxy;
			applicationProxy.changeApplicationView(ApplicationViewConstants.LOGIN_VIEW);
		}
		override public function onRemove():void{
			super.onRemove();
		}
		public function changeApplicationView(view:String):void{
			this.view.gameLayer.changeView(view);
		}
		public function get view():Battle{
			return Battle(viewComponent);
		}
		
		
	}
}