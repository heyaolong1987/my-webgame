package com.netease.webgame.bitchwar.controller.incept.login{
	import com.netease.webgame.bitchwar.constants.application.ApplicationViewConstants;
	import com.netease.webgame.bitchwar.constants.gameview.GameViewConstants;
	import com.netease.webgame.bitchwar.controller.incept.BaseInceptCommand;
	import com.netease.webgame.bitchwar.model.Model;
	import com.netease.webgame.bitchwar.model.proxy.ApplicationProxy;
	import com.netease.webgame.bitchwar.model.proxy.gameview.GameViewProxy;
	import com.netease.webgame.bitchwar.model.proxy.login.LoginProxy;
	import com.netease.webgame.core.model.vo.net.InceptVO;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.INotification;
	
	/**
	 *
	 *@author heyaolong
	 *
	 *2011-10-11
	 */
	public class InceptLoginSuccessCommand extends BaseInceptCommand{
		
		public function InceptLoginSuccessCommand()
		{
		}
		override public function execute(note:INotification):void{
			var args:Array =InceptVO(note.getBody()).args;
			var charList:ArrayCollection = args[0] as ArrayCollection;
			var loginProxy:LoginProxy = retrieveProxy(LoginProxy.NAME) as LoginProxy;
			loginProxy.loginSuccess(charList);
			var applicationProxy:ApplicationProxy = retrieveProxy(ApplicationProxy.NAME) as ApplicationProxy;
			applicationProxy.changeApplicationView(ApplicationViewConstants.GAME_VIEW);
			var gameViewProxy:GameViewProxy = retrieveProxy(GameViewProxy.NAME) as GameViewProxy;
			gameViewProxy.setCurrentGameView(GameViewConstants.SELECT_CHAR_VIEW);
		}
	}
}