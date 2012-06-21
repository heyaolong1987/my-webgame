package com.netease.webgame.bitchwar.view.vc.component
{
	import com.netease.webgame.core.view.vc.component.HBar;
	
	import mx.controls.ProgressBarMode;
	
	public class MPBar extends HBar
	{
		public function MPBar()
		{
			mode = ProgressBarMode.MANUAL;
			width = 100;
			height = 6;
			
		}
	
		public function get mpMax():int{
			return this.maximum;
		}
		public function set mpMax(max:int):void{
			maximum = max;
		}
		public function set mp(value:int):void{
			this.value = value;
		}
		
		public function get mp():int{
			return value;
		}
	}
}