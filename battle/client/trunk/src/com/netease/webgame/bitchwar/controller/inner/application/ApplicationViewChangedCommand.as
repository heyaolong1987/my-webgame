package com.netease.webgame.bitchwar.controller.inner.application
{
	import com.netease.webgame.bitchwar.InnerCommandConstants;
	import com.netease.webgame.bitchwar.constants.application.ApplicationConstants;
	import com.netease.webgame.bitchwar.constants.application.ApplicationViewConstants;
	import com.netease.webgame.bitchwar.constants.gameview.GameViewConstants;
	import com.netease.webgame.bitchwar.controller.inner.baseClass.BaseInnerCommand;
	import com.netease.webgame.bitchwar.model.proxy.ApplicationProxy;
	import com.netease.webgame.bitchwar.model.proxy.gameview.GameViewProxy;
	import com.netease.webgame.bitchwar.view.mediator.ApplicationMediator;
	import com.netease.webgame.bitchwar.view.mediator.GameViewMediator;
	import com.netease.webgame.bitchwar.view.mediator.login.LoginViewMediator;
	import com.netease.webgame.bitchwar.view.vc.layer.GameViewLayer;
	import com.netease.webgame.bitchwar.view.vc.panel.login.LoginView;
	
	import org.puremvc.as3.interfaces.INotification;

	public class ApplicationViewChangedCommand extends BaseInnerCommand
	{
		public function ApplicationViewChangedCommand()
		{
		}
		override public function execute(note:INotification):void{
			var view:String = note.getBody() as String;
			var applicationMediator:ApplicationMediator = retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			applicationMediator.changeApplicationView(view);
			
			switch(view){
				case ApplicationViewConstants.LOGIN_VIEW:
					registerMediator(new LoginViewMediator(applicationMediator.view.gameLayer.loginView));
					break;
				case ApplicationViewConstants.GAME_VIEW:
					var applicationMediator:ApplicationMediator = retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
					var gameViewProxy:GameViewProxy = new GameViewProxy();
					gameViewProxy.setCurrentGameView(GameViewConstants.NONE);
					registerProxy(gameViewProxy);
					registerMediator(new GameViewMediator(applicationMediator.view.gameLayer.gameViewLayer));
					break;
			}
		}
	}
}