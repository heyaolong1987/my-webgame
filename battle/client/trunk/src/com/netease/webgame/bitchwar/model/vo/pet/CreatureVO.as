package com.netease.webgame.bitchwar.model.vo.pet
{
	import com.netease.webgame.bitchwar.model.vo.baseclass.BaseItemVO;

	public class CreatureVO extends BaseItemVO
	{
		
		/**
		 *基础力量 
		 */
		public var baseStr:Number;
		/**
		 *基础体质 
		 */
		public var baseCon:Number;
		/**
		 *基础智力 
		 */
		public var baseInt:Number;
		/**
		 *基础敏捷 
		 */
		public var baseAgi:Number;
		/**
		 *基础精神
		 */
		public var baseSpi:Number;
		
		
		/**
		 *力量 
		 */
		public var addStr:Number;
		/**
		 *体质 
		 */
		public var addCon:Number;
		/**
		 *智力 
		 */
		public var addInt:Number;
		/**
		 *敏捷 
		 */
		public var addAgi:Number;
		/**
		 * 精神
		 */
		public var addSpi:Number;
		
		
		/**
		 *血量 
		 */
		public var hp:Number;
		/**
		 *魔量 
		 */
		public var mp:Number;
		
		/******************************以下是二级属性 start *******************************/
		/**
		 *最大血量
		 */
		public var maxHp:Number;
		
		/**
		 *最大魔量 
		 */
		public var maxMp:Number;
		
		/**
		 *物理攻击力 
		 */
		public var attack:Number;
		/**
		 *法术攻击力 
		 */
		public var magic:Number;
		/**
		 *防御力 
		 */
		public var defence:Number;
		
		/**
		 *法术防御力 
		 */
		public var mDefence:Number;
		/**
		 *命中
		 */
		public var hit:Number;
		/**
		 *闪避 
		 */
		public var dodge:Number;
		/**
		 *速度 
		 */
		public var speed:Number;
		/**
		 *暴击 
		 */
		public var critRate:Number;
		/******************************以下是二级属性 end *******************************/
		
		/**
		 *技能列表 
		 */
		public var skillList:Array=[];
		/**
		 *装备列表 
		 */
		public var equipmentList:Array = [];
		
		public function CreatureVO()
		{
		}
	}
}