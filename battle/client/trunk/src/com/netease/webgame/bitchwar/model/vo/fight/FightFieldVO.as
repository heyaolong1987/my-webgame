package com.netease.webgame.bitchwar.model.vo.fight
{
	import mx.collections.ArrayCollection;
	[Bindable]
	public class FightFieldVO
	{
		/**
		 *战斗类型 0为普通类型，1为boss战斗 
		 */
		public var fightType:int;
		
		/**
		 *战斗Id 
		 */
		public var fightId:int;
		
		/**
		 *回合ID 
		 */
		public var roundId:int;
		
		/**
		 * 二维数组，[2][5]方阵
		 */
		public var fighters:Array;
		
		/**
		 *战斗者的映射表（id,FighterVO)
		 */
		public var fighterMap:Object;
		/**
		 *所有出现过的战斗者的映射表 (id,FighterVO)
		 */
		public var fighterAllMap:Object;
			
		/**
		 *历史回合列表
		 */
		public var roundList:Array = [];
		public var roundData:Array = [];
		
		/**
		 *当前回合数据 
		 */
		public var currentRound:FightRoundVO;
		
		public function FightFieldVO()
		{
		}
	}
}