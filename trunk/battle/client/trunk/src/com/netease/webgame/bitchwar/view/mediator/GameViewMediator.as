package com.netease.webgame.bitchwar.view.mediator
{
	import com.netease.webgame.bitchwar.InnerCommandConstants;
	import com.netease.webgame.bitchwar.InceptCommandConstants;
	import com.netease.webgame.bitchwar.constants.gameview.GameViewConstants;
	import com.netease.webgame.bitchwar.model.proxy.ApplicationProxy;
	import com.netease.webgame.bitchwar.model.proxy.fight.FightProxy;
	import com.netease.webgame.bitchwar.model.proxy.gameview.GameViewProxy;
	import com.netease.webgame.bitchwar.model.proxy.socket.InceptCommandProxy;
	import com.netease.webgame.bitchwar.view.mediator.fight.FightMediator;
	import com.netease.webgame.bitchwar.view.vc.layer.FightLayer;
	import com.netease.webgame.bitchwar.view.vc.layer.GameViewLayer;
	
	import org.puremvc.as3.interfaces.INotification;
	import com.netease.webgame.core.view.mediator.baseclass.BaseMediator;
	
	public class GameViewMediator extends BaseMediator
	{
		public static const NAME:String = "GameViewMediator";
		
		private var _gameViewProxy:GameViewProxy;
		public function GameViewMediator(viewComponent:Object)
		{
			super(GameViewMediator.NAME,viewComponent);
		}
		
		override public function onRegister():void{
			_gameViewProxy = retrieveProxy(GameViewProxy.NAME) as GameViewProxy;
 			_gameViewProxy.setCurrentGameView(GameViewConstants.NONE);
		}
		override public function onRemove():void{
			
		}
		override public function addCommandListeners():void{
		}
		public function changeGameView(view:String):void{
			gameViewLayer.currentGameView = view;
		}
		public function get gameViewLayer():GameViewLayer{
			return this.viewComponent as GameViewLayer;
		}
	}
}