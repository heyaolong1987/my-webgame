package com.netease.webgame.bitchwar.controller.incept{
	import com.netease.webgame.core.model.vo.net.InceptVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	/**
	 *
	 *@author heyaolong
	 *
	 *2011-10-10
	 */
	public class InceptCommand extends BaseInceptCommand{
		public function InceptCommand()
		{
		}
		private static function fightRoundStart():void{
			var fightMediator:FightMediator = retrieveMediator(FightMediator.NAME) as FightMediator;
			fightMediator.startNextRound();
		}
		private static function userFightOperate():void{
			//初始化战场数据
			var fightStartVO:FightStartVO = note.getBody() as FightStartVO;
			var fightProxy:FightProxy = new FightProxy();
			registerProxy(fightProxy);
			//切换视图到战斗视图
			var gameViewProxy:GameViewProxy = retrieveProxy(GameViewProxy.NAME) as GameViewProxy;
			gameViewProxy.setCurrentGameView(GameViewConstants.FIGHT_VIEW);
			
			fightProxy.startFight(fightStartVO);
		}
		
		private static function loginSuceess():void{
			
		}
		private static function loginFail():void{
			
		}
		private static function connectSuccess():void{
			
		}
		private static function connectError():void{
			
		}
	}
}