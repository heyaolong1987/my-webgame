package com.netease.core.display.tooltip {
	/**
	 * @author heyaolong
	 * 
	 * 2011-10-29
	 */ 
	public interface ICToolTipClient{
		function registerToolTip(tipData:Object,tipClass:Class=null,tipFunction:Function=null):void;
	}
}