package com.netease.webgame.bitchwar.model.vo.pet
{
	import com.netease.webgame.bitchwar.model.vo.baseclass.BaseItemVO;

	public class PetVO extends BaseItemVO
	{
		/**
		 * 等级
		 */
		public var level:int;
		
		/**
		 *初始力
		 */ 
		public var initStr:int;
		
		/**
		 *初始体
		 */ 
		public var initSta:int;
		
		/**
		 *初始敏
		 */ 
		public var initAgi:int;
		
		/**
		 *初始法
		 */ 
		public var initSpi:int;
		
		/**
		 *初始智
		 */
		public var initInt:int;
		
		/**
		 *当前力
		 */ 
		public var str:int;
		
		/**
		 *当前体
		 */ 
		public var sta:int;
		
		/**
		 *当前敏
		 */ 
		public var agi:int;
		
		/**
		 * 当前法
		 */ 
		public var spi:int;
		
		/**
		 *当前智
		 */
		public var int:int;
		
		/**
		 * 经验
		 */
		public var exp:Number;		
		/**
		 *寿命
		 */		
		public var age:int;
		/**
		 *忠诚
		 */
		public var loyal:int;
		
		/**
		 *种族
		 */
		public var race:int;
		
		/**
		 *初始等级
		 */
		public var initLevel:int;
		
		/**
		 * 悟性
		 */
		public var savvy:int;
		
		/**
		 *当前血 
		 */
		public var hp:int;
		
		/**
		 *当前蓝 
		 */
		public var mp:int;
		
		/**
		 *最大血 
		 */
		public var maxHp:int;
		
		/**
		 * 最大蓝
		 */
		public var maxMp:int;
		
		/**
		 * 技能 
		 */		
		public var skillList:ArrayCollection;
		
		
		public function PetVO()
		{
		}
	}
}