package com.netease.webgame.bitchwar.model.vo.fight
{
	import com.netease.webgame.bitchwar.constants.fight.FightConstants;
	import com.netease.webgame.bitchwar.constants.fight.FightSideConstants;
	
	import mx.events.IndexChangedEvent;
	[Bindable]
	public class FightViewVO
	{
		/**
		 *是否是自动战斗
		 */
		public var autoMode:Boolean;
		
		/**
		 *自动战斗剩余回合数 
		 */
		public var remainRound:int;
		
		/**
		 *战场数据 
		 */
		public var fightFieldVO:FightFieldVO;
		
		/**
		 *战斗操作类型 
		 */
		public var actionType:int;
		/**
		 * 战斗物品或技能ID
		 */
		public var actionItemId:int;
		/**
		 *战斗操作的目标 
		 */
		public var actionTargetId:int;
		
		/**
		 *战斗操作步骤
		 */
		public var actionStep:int;
		
		/**
		 *战斗操作VO
		 */
		public var fightActionVO:FightActionVO;
		
		/**
		 *战场请求 
		 */
		public var fightRequestVO:FightRequestVO;
		
		/**
		 * 战斗结果
		 */
		public var selfVO:FightResultVO;
		
		/**
		 * 战斗分配
		 */
		public var fightAllocateMap:Object;
		
		/**
		 * 上一场战斗
		 */
		public var fightReplayVO:FightReplayVO;
		
		/**
		 *我的战斗方阵 
		 */
		public var myFightSide:int =  FightSideConstants.LEFT;
		public function FightViewVO()
		{
		}
	}
}