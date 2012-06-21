package com.netease.webgame.bitchwar.view.vc.component.effects
{
	import com.netease.webgame.bitchwar.events.GEffectEvent;
	
	import flash.display.DisplayObject;

	public class GBaseEffect extends DisplayObject
	{
		private var _playing:Boolean = false;
		public function GBaseEffect()
		{
		}
		/**
		 *播放特效 
		 * 
		 */
		public function playEffect():void{
			_playing = true;
			dispatchEvent(new GEffectEvent(GEffectEvent.EFFECT_START));
		}
		/**
		 *特效播放结束 
		 * 
		 */
		protected function effectEnd():void{
			
			_playing = false;
			dispatchEvent(new GEffectEvent(GEffectEvent.EFFECT_END));
		}
		/**
		 *特效是否正在播放 
		 * @return 
		 * 
		 */
		public function isPlaying():Boolean{
			return _playing;
		}
	}
}