package com.netease.webgame.bitchwar.model.vo.fight
{
	import com.netease.webgame.bitchwar.constants.fight.FightSide;
	import com.netease.webgame.bitchwar.constants.fight.FighterType;
	import com.netease.webgame.bitchwar.model.vo.fight.FightActionVO;
	import com.netease.webgame.bitchwar.model.vo.gameobject.FighterVO;

	public class FightVO
	{
		/**
		 *当前玩家 
		 */
		public var fighter:FighterVO;
		/**
		 *战斗场景 
		 */
		public var fightField:FightFieldVO;
		
		/**
		 *是否自动 
		 */
		public var isAuto:Boolean;
		
		/**
		 *自动战斗剩余回合数 
		 */
		public var autoFightRemainRound:int;
		/**
		 *当前玩家选择的操作 
		 */
		public var fightActionVO:FightActionVO;
		
		/**
		 *战斗方阵 
		 */
		public var fightSide:int = FightSide.LEFT;
		
		/**
		 *战斗结果 
		 */
		public var fightResult:FightResultVO;
		
		/**
		 *战斗物品分配 
		 */
		public var fightAllocateResult:Object;
		
		public function FightVO()
		{
		}
	}
}