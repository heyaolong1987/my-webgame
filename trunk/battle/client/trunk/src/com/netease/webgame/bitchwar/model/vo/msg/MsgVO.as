package com.netease.webgame.bitchwar.model.vo.msg
{
	public class MsgVO
	{
		public var msg:String;
		public var type0:int;
		public var type1:int;
		public var type2:int;
		public function MsgVO(msg:String,type0:int=0,type1:int=0,type2:int=0)
		{
			this.msg = msg;
			this.type0 = type0;
			this.type1 = type1;
			this.type2 = type2;
		}
	}
}