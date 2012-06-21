package com.netease.webgame.core.view.vc.component
{
	public class HBar extends GProgressBar
	{
		public function HBar()
		{
			
		}
		override public function set maximum(max:Number):void{
			setProgress(value,max);
			label  = "";
		}
		public function set value(currentValue:Number):void{
			setProgress(currentValue,maximum);
			label  = "";
		}
	}
}