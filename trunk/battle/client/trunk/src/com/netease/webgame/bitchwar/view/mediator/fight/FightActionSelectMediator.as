package com.netease.webgame.bitchwar.view.mediator.fight
{
	import com.netease.webgame.bitchwar.InnerCommandConstants;
	import com.netease.webgame.bitchwar.constants.fight.FightConstants;
	import com.netease.webgame.core.events.GameEvent;
	import com.netease.webgame.core.view.mediator.baseclass.BaseMediator;
	import com.netease.webgame.bitchwar.view.vc.panel.fight.FightActionSelectPanel;

	public class FightActionSelectMediator extends BaseMediator
	{
		public static const NAME:String = "FightActionSelectMediator";
		public function FightActionSelectMediator(viewComponent:Object)
		{
			super(FightActionSelectMediator.NAME,viewComponent);
		}
		override public function onRegister():void{
			view.addEventListener(FightActionSelectPanel.ACTION_ATTACK,actionAttackClickHandler);
			
		}
	
		override public function onRemove():void{
			
		}
		override public function addCommandListeners():void{
		
		}
		/**
		 *点击攻击按钮 
		 * @param event
		 * 
		 */
		private function actionAttackClickHandler(event:GameEvent):void{
			sendNotification(InnerCommandConstants.FIGHT_ACTION_SELECTED,FightConstants.FIGHT_ACTION_ATTACK);
		}
		
		private function get view():FightActionSelectPanel{
			return viewComponent as FightActionSelectPanel;
		}
	}
		
}