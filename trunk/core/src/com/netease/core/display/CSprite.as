package com.netease.core.display{
	import com.netease.core.manager.CallLaterManager;
	
	import flash.display.Sprite;

	/**
	 * @author heyaolong
	 * 
	 * 2012-6-6
	 */ 
	public class CSprite extends Sprite {
		
		public function CSprite()
		{
		}
		public function validate():void{
			CallLaterManager.getInstance().addFunction(invalidate);
		}
		public function invalidate():void{
			
		}
	}
}