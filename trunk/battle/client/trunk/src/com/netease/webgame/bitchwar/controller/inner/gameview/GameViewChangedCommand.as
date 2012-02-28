package com.netease.webgame.bitchwar.controller.inner.gameview
{
	import com.netease.webgame.bitchwar.constants.gameview.GameViewConstants;
	import com.netease.webgame.bitchwar.controller.inner.baseClass.BaseInnerCommand;
	import com.netease.webgame.bitchwar.model.proxy.gameview.GameViewProxy;
	import com.netease.webgame.bitchwar.model.proxy.login.LoginProxy;
	import com.netease.webgame.bitchwar.view.mediator.GameViewMediator;
	import com.netease.webgame.bitchwar.view.mediator.fight.FightMediator;
	import com.netease.webgame.bitchwar.view.mediator.login.SelectCharViewMediator;
	import com.netease.webgame.bitchwar.view.vc.layer.FightLayer;
	import com.netease.webgame.bitchwar.view.vc.layer.GameViewLayer;
	import com.netease.webgame.bitchwar.view.vc.panel.login.SelectCharView;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class GameViewChangedCommand extends BaseInnerCommand
	{
		public function GameViewChangedCommand()
		{
		}
		override public function execute(note:INotification):void{
			var view:String = note.getBody() as String;
			switch(view){
				case GameViewConstants.FIGHT_VIEW:
					var gameViewMediator:GameViewMediator = retrieveMediator(GameViewMediator.NAME) as GameViewMediator;
					if(gameViewMediator){
						gameViewMediator.changeGameView(view);
						var gameViewLayer:GameViewLayer = gameViewMediator.gameViewLayer;
						var fightLayer:FightLayer = gameViewLayer.fightLayer;
						registerMediator(new FightMediator(fightLayer));
						
					}
					break;
				case GameViewConstants.SELECT_CHAR_VIEW:
					var gameViewMediator:GameViewMediator = retrieveMediator(GameViewMediator.NAME) as GameViewMediator;
					if(gameViewMediator){
						gameViewMediator.changeGameView(view);
						var gameViewLayer:GameViewLayer = gameViewMediator.gameViewLayer;
						var selectCharView:SelectCharView = gameViewLayer.selectCharLayer;
						var loginProxy:LoginProxy = retrieveProxy(LoginProxy.NAME) as LoginProxy;
						selectCharView.charList = loginProxy.charList;
						registerMediator(new SelectCharViewMediator(selectCharView));
						
					}
			}
		}
	}
}