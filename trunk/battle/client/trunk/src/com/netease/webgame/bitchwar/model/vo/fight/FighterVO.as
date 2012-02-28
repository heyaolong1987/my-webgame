package com.netease.webgame.bitchwar.model.vo.fight
{
	import com.netease.webgame.bitchwar.model.vo.baseclass.BaseItemVO;

	public class FighterVO extends BaseItemVO
	{
		/**
		 *所在的方阵 
		 */
		public var stand:int;
		
		public var position:int;
		/**
		 *战斗对象的战斗外角色，可以是人物，宠物，NPC,怪物 
		 */
		public var owner:BaseItemVO;
		
		/**
		 *宿主ID,例如宠物的宿主是人物 
		 */
		public var parentId:int;
		
		/**
		 *动作类型 
		 */
		public var actionType:int;
		public function FighterVO()
		{
		}
	}
}