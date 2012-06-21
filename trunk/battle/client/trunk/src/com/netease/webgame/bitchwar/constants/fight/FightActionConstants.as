package com.netease.webgame.bitchwar.constants.fight
{
	public class FightActionConstants
	{
		public static const NONE:int=0;
		/**
		 * 战斗动作，物理攻击
		 */
		public static const ATTACK:int = 1;
		/**
		 * 战斗动作，保护
		 */
		public static const PROTECT:int = 2;
		/**
		 * 战斗动作，捕捉宠物
		 */
		public static const CATCH_PET:int = 3;
		/**
		 *战斗动作，防御 
		 */
		public static const DEFEND:int = 4;
		/**
		 *战斗动作，逃跑
		 */
		public static const ESCAPE:int = 5;
		/**
		 *战斗动作，自动
		 */
		public static const AUTO:int = 6;
		
		/**
		 * 战斗动作，使用技能
		 */
		public static const USE_SKILL:int = 7;
		
		/**
		 * 战斗动作，使用物品
		 */
		public static const USE_ITEM:int = 8;
		
		/**
		 *选择操作类型 
		 */
		public static const STEP_CHOOSE_ACTION_TYPE:int=0;
		/**
		 *选择物品 
		 */
		public static const STEP_CHOOSE_ITEM:int=1;
		/**
		 *选择目标 
		 */
		public static const STEP_CHOOSE_TARGET:int=2;
		
		/**
		 *操作结束
		 */
		public static const STEP_FINISH:int=3;
	
		public function FightActionConstants()
		{
		}
	}
}