package com.netease.webgame.bitchwar.model.vo.fight
{
	[Bindable]
	public class FightRequestVO
	{
		/**
		 *战斗回合数 
		 */
		public var roundId:int;
		
		/**
		 *选择的操作类型 
		 */
		public var actionType:int;
		
		/**
		 *技能模板ID 
		 */
		public var skillTempId:int;
		
		/**
		 *使用的物品ID
		 */
		public var itemId:int;
		/**
		 * 目标对象
		 */
		public var targetId:String;
		
		/**
		 *要更换的宠物ID 
		 */
		public var changePetId:int;
		
		/**
		 *克隆 
		 * @return 
		 * 
		 */
		public function clone():FightRequestVO{
			var request:FightRequestVO = new FightRequestVO();
			request.actionType = this.actionType;
			request.roundId = this.roundId;
			request.skillTempId = this.skillTempId;
			request.targetId = this.targetId;
			request.changePetId = this.changePetId;
			return request;
		}
		public function FightRequestVO()
		{
		}
	}
}