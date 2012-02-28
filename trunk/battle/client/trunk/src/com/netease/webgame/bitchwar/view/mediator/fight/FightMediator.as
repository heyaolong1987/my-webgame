package com.netease.webgame.bitchwar.view.mediator.fight
{
	import com.netease.webgame.bitchwar.InnerCommandConstants;
	import com.netease.webgame.bitchwar.constants.fight.FightActionConstants;
	import com.netease.webgame.bitchwar.constants.mouse.MouseConstants;
	import com.netease.webgame.core.events.GameEvent;
	import com.netease.webgame.bitchwar.model.proxy.fight.FightProxy;
	import com.netease.webgame.bitchwar.model.vo.fight.FightViewVO;
	import com.netease.webgame.bitchwar.view.vc.component.Fighter;
	import com.netease.webgame.core.view.mediator.baseclass.BaseMediator;
	import com.netease.webgame.bitchwar.view.vc.layer.FightLayer;
	import com.netease.webgame.bitchwar.view.vc.panel.fight.FightActionSelectPanel;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;

	public class FightMediator extends BaseMediator
	{
		public static const NAME:String = "FightViewMediator";
		private var _fightProxy:FightProxy;
		public function FightMediator(viewComponent:Object)
		{
			super(FightMediator.NAME,viewComponent);
		}
		override public function onRegister():void{
			
			_fightProxy = retrieveProxy(FightProxy.NAME) as FightProxy;
			
			fightView.addEventListener(FightActionSelectPanel.CHOOSE_ACTION_TYPE,chooseActionHandler);
			
			fightView.addEventListener(FightLayer.BLANK_CLICK, blankClickHandler);
			fightView.addEventListener(FightLayer.FIGHTER_CLICK, fighterClickHandler);
			fightView.addEventListener(FightLayer.FIGHTER_ROLL_OUT,fighterRollOutHandler);
			fightView.addEventListener(FightLayer.FIGHTER_ROLL_OVER, fighterRollOverHandler);
			
		//	fightView.addEventListener(FightPanel.CANCEL_AUTO_FIGHT, cancelAutoFightHandler);
		//	fightView.addEventListener(FightPanel.CANCEL_FIGHT_ACTION, cancelSelectFighterHandler);
		//	fightView.addEventListener(FightPanel.AUTO_FIGHT_SETTING, showAutoFightSetting);
		}
		override public function onRemove():void{
			fightView.removeEventListener(FightActionSelectPanel.CHOOSE_ACTION_TYPE, chooseActionHandler);
			
			fightView.removeEventListener(FightLayer.BLANK_CLICK, blankClickHandler);
			fightView.removeEventListener(FightLayer.FIGHTER_CLICK, fighterClickHandler);
			fightView.removeEventListener(FightLayer.FIGHTER_ROLL_OUT, fighterRollOutHandler);
			fightView.removeEventListener(FightLayer.FIGHTER_ROLL_OVER, fighterRollOverHandler);
			///fightView.removeEventListener(FighterView.FIGHTER_SELECTED, fighterSelectedHandler);
			//fightView.removeEventListener(FighterView.FIGHTER_ROLL_OUT, fighterRollOutHandler);
			//fightView.removeEventListener(FighterView.FIGHTER_ROLL_OVER, fighterRollOverHandler);
			//fightView.removeEventListener(FightPanel.CANCEL_AUTO_FIGHT, cancelAutoFightHandler);
			//fightView.removeEventListener(FightPanel.CANCEL_FIGHT_ACTION, cancelSelectFighterHandler);
			//fightView.removeEventListener(FightPanel.AUTO_FIGHT_SETTING, showAutoFightSetting);
			//simpleFacade.removeMediatorByType(AutoFightSettingMediator);
		}
		override public function addCommandListeners():void{
			addCommandListener(InnerCommandConstants.START_FIGHT,startFight);
		}
		private function startFight(note:INotification):void{
			var fightViewVO:FightViewVO = note.getBody() as FightViewVO;
			fightView.startFight(fightViewVO);
			
		}
		//选择动作
		private function chooseActionHandler(event:GameEvent):void {
			var actionType:int = event.data as int;
			//todo 添加前置判断
			
			var result:int = _fightProxy.setActionType(actionType);
		}
		//点击空地
		private function blankClickHandler(event:GameEvent):void{
			event.stopImmediatePropagation();
			if(_fightProxy.canCancelCurrentAction()){
				_fightProxy.cancelCurrentAction();
			}
		}
		//点击fighter
		private function fighterClickHandler(event:GameEvent):void {
			event.stopImmediatePropagation();
			var fighter:Fighter = Fighter(event.data);
			if(_fightProxy.isSetTarget()){
				_fightProxy.setActionTargetId(fighter.fighterVO.id);
			}
		}
		//鼠标移过fighter
		private function fighterRollOutHandler(event:Event):void {
			event.stopImmediatePropagation();
			var fighter:Fighter = Fighter(event.target);
			//fightProxy.setMouseFighter(null);
		}
		
		private function fighterRollOverHandler(event:Event):void {
			var fighter:Fighter = Fighter(event.target);
			//fightProxy.setMouseFighter(fighterView.fighterVO);
		}
		//开始下一个回合
		public function startNextRound():void{
			fightView.startNextRound();
		}
		private function get fightView():FightLayer{
			return viewComponent as FightLayer;
		}
		
	}
}