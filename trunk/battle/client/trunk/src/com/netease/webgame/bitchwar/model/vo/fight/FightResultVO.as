package com.netease.webgame.bitchwar.model.vo.fight{
	[Bindable]
	public class FightResultVO{
		/**
		 *平局 
		 */
		public static const TIE:int = 0;
		/**
		 *胜利 
		 */
		public static const WIN:int = 1;
		/**
		 *失败 
		 */
		public static const FAIL:int = 2;
		
		/**
		 *战场ID 
		 */
		public var fightId:int = 0;
		/**
		 *
		 *战斗结果，胜，负，平 
		 */
		public var fightResult:int=0;
		/**
		 *获得的金钱 
		 */
		public var getMoney:Number = 0;
		/**
		 *获得的经验 
		 */
		public var getExp:Number = 0;
		/**
		 *宠物获得的经验 
		 */
		public var getPetExp:Number = 0;
		/**
		 *获得的物品 
		 */
		public var getItems:Array = [];
		public function FightResultVO(){
		}
	}
}