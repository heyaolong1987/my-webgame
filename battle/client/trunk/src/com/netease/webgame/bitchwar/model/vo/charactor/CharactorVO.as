package com.netease.webgame.bitchwar.model.vo.charactor
{
	import com.netease.webgame.bitchwar.model.vo.baseclass.BaseItemVO;
	[RemoteClass(alias="com.netease.webgame.bitchwar.model.vo.charactor.CharactorVO")]
	public class CharactorVO extends BaseItemVO
	{
		/**
		 * 性别
		 */
		public var sex:int;
		
		/**
		 *等级 
		 */
		public var level:int;
		
		/**
		 *经验 
		 */
		public var exp:int;
		
		/**
		 *金币 
		 */
		public var money:int;
		
		/** 
		 * 种族,门派，阵营
		 */
		public var race:int;
		
		/**
		 *精力 
		 */
		public var energy:int;
		
		/**
		 *精力上限 
		 */
		public var maxEnergy:int;
		
		/**
		 * vip类型
		 */
		public var vipType:int;
		
		/**
		 *所在场景类型 
		 */
		public var sceneType:int;
		
		/**
		 *场景ID 
		 */
		public var sceneId:int;
		
		
		public function CharactorVO()
		{
		}
	}
}