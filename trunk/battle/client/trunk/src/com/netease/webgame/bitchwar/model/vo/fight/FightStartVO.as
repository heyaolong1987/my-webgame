package com.netease.webgame.bitchwar.model.vo.fight
{
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class FightStartVO
	{
		public function FightStartVO()
		{
		}
		/**
		 *战场ID 
		 */
		public var fightId:Number;
		
		/**
		 * 战场类型
		 */
		public var fightType:int;
		/**
		 * 战斗成员列表[2][3][5]
		 */
		public var fighters:Array;
		
		/**
		 *是否是重放，用于录像功能
		 */
		public var isRestart:Boolean = false;
		/**
		 *战场起始数据 
		 */
		public var fightStartData:ByteArray;
		
		
		
	}
}