package com.netease.webgame.bitchwar.model.proxy
{
	import com.netease.webgame.bitchwar.InnerCommandConstants;
	import com.netease.webgame.bitchwar.model.Model;
	import com.netease.webgame.bitchwar.model.proxy.baseclass.BaseProxy;
	import com.netease.webgame.bitchwar.model.proxy.login.LoginProxy;
	import com.netease.webgame.bitchwar.model.proxy.mouse.MouseProxy;
	import com.netease.webgame.bitchwar.model.proxy.socket.InceptCommandProxy;
	

	public class ApplicationProxy extends BaseProxy
	{
		public static const NAME:String = "ApplicationProxy";
		
		public function ApplicationProxy(proxyName:String){
			super(proxyName);
		}
		override public function onRegister():void{
			registerProxy(new InceptCommandProxy());
			registerProxy(new MouseProxy());
			registerProxy(new LoginProxy());
		}
		public function changeApplicationView(value:String):void{
			if(Model.getInstance().applicationView == value){
				sendNotification(InnerCommandConstants.CHANGE_APPLICATION_VIEW_FAIL,value);
				return;
			}
			Model.getInstance().applicationView = value;
			sendNotification(InnerCommandConstants.APPLICATION_VIEW_CHANGED,Model.getInstance().applicationView);
		}
	}
}