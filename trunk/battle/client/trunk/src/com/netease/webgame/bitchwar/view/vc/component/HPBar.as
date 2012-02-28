package com.netease.webgame.bitchwar.view.vc.component
{
	import com.netease.webgame.core.view.vc.component.HBar;
	
	import mx.controls.ProgressBarMode;

	public class HPBar extends HBar
	{
		public function HPBar()
		{
			mode = ProgressBarMode.MANUAL;
			width = 100;
			height = 6;
			
		}
		public function get hpMax():int{
			return this.maximum;
		}
		public function set hpMax(max:int):void{
			maximum = max;
		}
		public function set hp(value:int):void{
			this.value = value;
		}
		
		public function get hp():int{
			return value;
		}
	}
}