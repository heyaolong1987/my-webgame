package com.netease.webgame.bitchwar.model.proxy.fight
{
	import com.netease.webgame.bitchwar.InnerCommandConstants;
	import com.netease.webgame.bitchwar.constants.fight.FightActionConstants;
	import com.netease.webgame.bitchwar.constants.mouse.MouseConstants;
	import com.netease.webgame.bitchwar.model.Model;
	import com.netease.webgame.bitchwar.model.proxy.baseclass.BaseProxy;
	import com.netease.webgame.bitchwar.model.vo.fight.FightActionVO;
	import com.netease.webgame.bitchwar.model.vo.fight.FightFieldVO;
	import com.netease.webgame.bitchwar.model.vo.fight.FightStartVO;
	import com.netease.webgame.bitchwar.model.vo.fight.FightUserOperateVO;
	import com.netease.webgame.bitchwar.model.vo.fight.FightViewVO;
	import com.netease.webgame.bitchwar.model.vo.fight.FighterVO;
	
	public class FightProxy extends BaseProxy
	{
		public static const NAME:String = "FightProxy";
		public function FightProxy()
		{
			super(FightProxy.NAME);	
		}
		/**
		 *战斗视图 
		 * @return 
		 * 
		 */
		public function get fightViewVO():FightViewVO{
			return Model.getInstance().fightViewVO;
		}
		/**
		 *战斗视图 
		 * @return 
		 * 
		 */
		public function set fightViewVO(value:FightViewVO):void{
			Model.getInstance().fightViewVO = value;
		}
		/**
		 *开始战斗 
		 * @param fightStartVO
		 * 
		 */
		public function startFight(fightStartVO:FightStartVO):void{
			Model.getInstance().fightViewVO = new FightViewVO();
			var fightViewVO:FightViewVO = Model.getInstance().fightViewVO;
			fightViewVO.fightFieldVO = new FightFieldVO();
			var fightFieldVO:FightFieldVO = fightViewVO.fightFieldVO;
			fightFieldVO.fighters = fightStartVO.fighters;
			fightFieldVO.fighterMap = {};
			fightFieldVO.fighterAllMap = {};
			for(var i:int=0; i<2; i++){
				for(var j:int=0; j<5; j++){
					var fighter:FighterVO = fightFieldVO.fighters[i][j];
					fightFieldVO.fighterMap[fighter.id.toString()] = fighter;
					fightFieldVO.fighterAllMap[fighter.id.toString()] = fighter;
				}
			}
			fightFieldVO.fightType = fightStartVO.fightType;
			fightFieldVO.fightId = fightStartVO.fightId;
			fightFieldVO.roundId = 1;
			sendNotification(InnerCommandConstants.START_FIGHT,fightViewVO);
			
		}
		/**
		 *返回一个处理结果
		 * @param value
		 * @return 
		 * 
		 */
		public function setActionType(value:int):int{
			fightViewVO.actionType = value;
			var actionType:int = fightViewVO.actionType;
			var actionStep:int;
			switch(actionType){
				case FightActionConstants.ATTACK:
					actionStep = FightActionConstants.STEP_CHOOSE_TARGET;
					sendNotification(InnerCommandConstants.CHANGE_MOUSE_MODE,MouseConstants.MOUSE_MODE_FIGHT_ATTACK);
					break;
				case FightActionConstants.CATCH_PET:
					actionStep = FightActionConstants.STEP_CHOOSE_TARGET;
					sendNotification(InnerCommandConstants.CHANGE_MOUSE_MODE,MouseConstants.MOUSE_MODE_FIGHT_CATCH);
					break;
				case FightActionConstants.DEFEND:
					actionStep = FightActionConstants.STEP_CHOOSE_TARGET;
					break;
				case FightActionConstants.PROTECT:
					actionStep = FightActionConstants.STEP_CHOOSE_TARGET;
					sendNotification(InnerCommandConstants.CHANGE_MOUSE_MODE,MouseConstants.MOUSE_MODE_FIGHT_PROTECT);
					break;
				case FightActionConstants.USE_ITEM:
					actionStep = FightActionConstants.STEP_CHOOSE_ITEM;
					sendNotification(InnerCommandConstants.CHANGE_MOUSE_MODE,MouseConstants.MOUSE_MODE_FIGHT_CHOOSE_ITEM);
					break;
				case FightActionConstants.USE_SKILL:
					actionStep = FightActionConstants.STEP_CHOOSE_ITEM;
					sendNotification(InnerCommandConstants.CHANGE_MOUSE_MODE,MouseConstants.MOUSE_MODE_FIGHT_CHOOSE_SKILL);
					break;
				case FightActionConstants.AUTO:
				case FightActionConstants.ESCAPE:
					actionStep = FightActionConstants.STEP_FINISH;
					break;
				case FightActionConstants.NONE:
					sendNotification(InnerCommandConstants.CHANGE_MOUSE_MODE,MouseConstants.MOUSE_MODE_NORMAL);
					actionStep = FightActionConstants.STEP_CHOOSE_ACTION_TYPE;
					break;
				default:
					actionStep = FightActionConstants.STEP_FINISH;
					break;
			}
			setActionStep(actionStep);
			
			return 0;
		}
		public function getActionType():int{
			return fightViewVO.actionType;
		}
		public function canCancelCurrentAction():Boolean{
			return fightViewVO.actionStep == FightActionConstants.STEP_CHOOSE_TARGET;
		}
		public function cancelCurrentAction():void{
			setActionType(FightActionConstants.NONE);
		}
		
		public function setActionItemId(itemId:int):int{
			if(fightViewVO.actionStep == FightActionConstants.STEP_CHOOSE_ITEM){
				fightViewVO.actionItemId = itemId;
				setActionStep(FightActionConstants.STEP_CHOOSE_TARGET);
			}
			else{
				
			}
			return 0;
		}
		
		public function isSetTarget():Boolean{
			return fightViewVO.actionStep == FightActionConstants.STEP_CHOOSE_TARGET;
		}
		/**
		 * 
		 * @param fighterId
		 * @return 0：成功，1：失败
		 * 
		 */
		public function setActionTargetId(fighterId:int):void{
			if(isSetTarget()){
				fightViewVO.actionTargetId = fighterId;
				setActionStep(FightActionConstants.STEP_FINISH);
			}
		}
		/**
		 * 
		 * @param fighterId
		 * @return 0：成功，1：失败
		 * 
		 */
		private function setActionStep(step:int):void{
			fightViewVO.actionStep = step;
			if(fightViewVO.actionStep == FightActionConstants.STEP_FINISH){
				sendNotification(InnerCommandConstants.ACTION_FINISHED,new FightActionVO(fightViewVO.fightFieldVO.roundId,fightViewVO.actionType,fightViewVO.actionItemId,fightViewVO.actionTargetId));
			}
		}
		public function setUserOperate(operate:FightUserOperateVO):void{
			var fighter:FighterVO;
			var fightFieldVO:FightFieldVO = fightViewVO.fightFieldVO;
			if(fightFieldVO.fightId==operate.fightId){
				if(fightFieldVO.roundId+1==operate.roundId) {
					fighter = getFighterByID(operate.fighterId);
					fighter.actionType = operate.actionType;
				}
				else {
				}
			}
		}
		public function getFighterByID(id:int):FighterVO{
			var fightFieldVO:FightFieldVO = fightViewVO.fightFieldVO;
			return fightFieldVO.fighterMap[id];
		}
		
		
	}
}