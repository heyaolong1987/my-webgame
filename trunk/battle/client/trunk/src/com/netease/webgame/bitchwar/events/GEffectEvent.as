package com.netease.webgame.bitchwar.events
{
	import com.netease.webgame.core.events.GameEvent;

	public class GEffectEvent extends GameEvent
	{
		/**
		 *特效开始播放 
		 */
		public static const EFFECT_START:String = "EFFECT_START";
		/**
		 *特效播放结束 
		 */
		public static const EFFECT_END:String = "EFFECT_END";
		/**
		 *特效被暂停 
		 */
		public static const EFFECT_STOP:String = "EFFECT_STOP";
		
		/**
		 *特效继续播放
		 */
		public static const EFFECT_CONTINUE:String = "EFFECT_CONTINUE";
		
		public function GEffectEvent(type:String,data:Object=null)
		{
			super(type,data);
		}
	}
}