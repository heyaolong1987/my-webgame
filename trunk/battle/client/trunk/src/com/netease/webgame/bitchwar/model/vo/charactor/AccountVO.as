package com.netease.webgame.bitchwar.model.vo.charactor
{
	import com.netease.webgame.bitchwar.model.vo.baseclass.BaseItemVO;
	import com.netease.webgame.bitchwar.model.vo.fight.AutoFightSettingsVO;
	import com.netease.webgame.bitchwar.model.vo.systemsettings.SystemSettingsVO;
	
	import mx.collections.ArrayCollection;

	public class AccountVO extends BaseItemVO
	{
		public function AccountVO()
		{
		}	
		/**
		 *精力 
		 */
		public var energy:int;
		
		/**
		 *精力上限 
		 */
		public var maxEnergy:int;
		
		/**
		 *上次登录时间 
		 */
		public var lastLoginTime:int;
		
		/**
		 *上次登出时间 
		 */
		public var lastLogoutTime:int;
		
		/**
		 *最后一次在线时长 
		 */
		public var lastOnlineTime:int;
		
		/**
		 *总在线时长 
		 */
		public var totalOnlineTime:int;
		
		/**
		 *系统设置 
		 */
		public var systemSettingsVO:SystemSettingsVO;
		
		/**
		 *技能列表 
		 */
		public var skillList:ArrayCollection;
		
		/**
		 *buff列表 
		 */
		public var buffList:ArrayCollection;
		
		/**
		 *自动战斗时设置的技能列表 
		 */
		public var autoFightSettingsVO:AutoFightSettingsVO;
		
		/**
		 *物品背包 
		 */
		public var itemBag:ArrayCollection;
		
		/**
		 *任务背包 
		 */
		public var questBag:ArrayCollection;
		
		/**
		 *快捷键映射 
		 */
		public var hotBarMapping:ArrayCollection;
		
		/**
		 *宠物列表 
		 */
		public var petList:ArrayCollection;
		
		
	}
}