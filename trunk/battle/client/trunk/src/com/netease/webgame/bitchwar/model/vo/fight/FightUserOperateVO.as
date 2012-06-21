package com.netease.webgame.bitchwar.model.vo.fight
{
	public class FightUserOperateVO
	{
		
		/**
		 *战场ID 
		 */
		public var fightId:Number;
		/**
		 *回合ID 
		 */
		public var roundId:int;
		/**
		 *战斗者ID
		 */
		public var fighterId:int;
		/**
		 *动作类型 
		 */
		public var actionType:int;
		public function FightUserOperateVO(fightId:int,roundId:int,fighterId:int,actionType:int):void
		{
			this.fightId = fightId;
			this.roundId = roundId;
			this.fighterId = fighterId;
			this.actionType = actionType;
		}
	}
}