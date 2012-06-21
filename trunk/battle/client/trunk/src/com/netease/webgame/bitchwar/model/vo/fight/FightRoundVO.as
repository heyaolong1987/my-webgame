package com.netease.webgame.bitchwar.model.vo.fight{
	[Bindable]
	public class FightRoundVO{
		/**
		 *战场ID 
		 */
		public var fightId:int;
		/**
		 *回合ID 
		 */
		public var roundId:int;
		/**
		 *动作列表 
		 */
		public var actionList:Array;
		public function FightRoundVO(fightId:int=0,roundId:int=0,actionList:Array=null){
			this.fightId = fightId;
			this.roundId = roundId;
			this.actionList = actionList;
		}
		
	}
}