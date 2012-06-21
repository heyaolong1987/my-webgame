package com.netease.webgame.bitchwar.view.mediator.login{
	import com.netease.webgame.bitchwar.CallCommandConstants;
	import com.netease.webgame.bitchwar.model.Model;
	import com.netease.webgame.bitchwar.net.CallPacketHandler;
	import com.netease.webgame.bitchwar.view.vc.panel.login.LoginView;
	import com.netease.webgame.core.events.GameEvent;
	import com.netease.webgame.core.model.vo.net.CallVO;
	import com.netease.webgame.core.net.NetEngine;
	import com.netease.webgame.core.view.mediator.baseclass.BaseMediator;
	
	import org.puremvc.as3.patterns.observer.Notification;

	/**
	 * 
	 * @author Administrator
	 * 
	 */
	public class LoginViewMediator extends BaseMediator{
		public static const NAME:String = "LOGIN_MEDIATOR";
		public function LoginViewMediator(viewComponent:Object)
		{
			super(LoginViewMediator.NAME,viewComponent);
		}
		override public function onRegister():void{
			view.addEventListener(LoginView.EVENT_LOGIN,loginHandler);
			
		}
		
		override public function onRemove():void{
		}
		override public function addCommandListeners():void{
		}
		
		private function onConnected(note:Notification):void{
			
		}
		private function onConnectError(note:Notification):void{
			
		}
		private function loginHandler(event:GameEvent):void{
			sendNotification(CallCommandConstants.CALL_SERVER,new CallVO(CallPacketHandler.LOGIN,event.data as Array));
			
		}
		private function onLoginSuccess(note:Notification):void{
			view.onLoginSuccess(null);
		}
		private function onLoginFail(note:Notification):void{
			view.onLoginFail();
		}
		public function get view():LoginView{
			return this.viewComponent as LoginView;
		}
		
	}
}