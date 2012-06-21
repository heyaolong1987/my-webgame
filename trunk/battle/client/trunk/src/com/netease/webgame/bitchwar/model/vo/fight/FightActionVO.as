package com.netease.webgame.bitchwar.model.vo.fight{
	[Bindable]
	public class FightActionVO{
		
		/**
		 *回合 
		 */
		public var roundId:int;
		/**
		 *动作类型， 
		 */
		public var actionType:int;
		/**
		 *物品，技能，更换的宠物ID
		 */
		public var itemId:int;
		/**
		 *动作目标，对方或己方战斗对象 
		 */
		public var targetId:int;
		
		public function FightActionVO(roundId:int,actionType:int,itemId:int,targetId:int){
			this.roundId = roundId;
			this.actionType = actionType;
			this.itemId = itemId;
			this.targetId = targetId;
			
		}
	}
}