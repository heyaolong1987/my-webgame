package com.netease.webgame.bitchwar.model.proxy.message
{
	import com.netease.webgame.bitchwar.InnerCommandConstants;
	import com.netease.webgame.bitchwar.constants.message.MsgConstants;
	import com.netease.webgame.bitchwar.model.proxy.baseclass.BaseProxy;
	import com.netease.webgame.bitchwar.model.vo.msg.MsgVO;
	
	public class MessageProxy extends BaseProxy
	{
		public function MessageProxy()
		{
		}
		public function sendMessage(msgVO:MsgVO):void{
			var type0:int = msgVO.type0;
			var type1:int = msgVO.type1;
			var type2:int = msgVO.type2;
			var msg:String = msgVO.type2;
			//这里添加需要将那些类型的消息发送到哪些位置
			if(type0==MsgConstants.TYPE0&&type1==MsgConstants.TYPE1_MSG&&type2==MsgConstants.TYPE2_MSG){
				sendNotification(InnerCommandConstants.SEND_MSG_TO_MODELESS_TIP,msgVO);
			}
		}
	}
}