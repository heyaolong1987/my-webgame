package com.netease.webgame.core.model.vo.net{
	/**
	 *
	 *@author heyaolong
	 *
	 *2011-10-10
	 */
	[RemoteClass(alias="com.netease.webgame.core.model.vo.net.InceptVO")]
	public class CallVO{
		public var funcName:String;
		public var args:Array;
		public function CallVO(funcName:String,args:Array)
		{
			this.funcName = funcName;
			this.args = args;
		}
	}
}