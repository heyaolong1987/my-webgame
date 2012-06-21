package com.netease.webgame.bitchwar.logic.message
{
	import com.netease.webgame.bitchwar.constants.message.MsgConstants;
	import com.netease.webgame.bitchwar.model.vo.msg.MsgVO;

	public class MsgLogic
	{
		public function MsgLogic()
		{
		}
		/**
		 *创建一个消息 
		 * @param mes 消息内容
		 * @param type 消息类型0，good,bad,normal
		 * @param type1 消息类型1,所属系统，如交易，好友，聊天等
		 * @param type2 消息类型2，所属系统中的子功能，如聊天中的世界聊天，组队聊天，私聊等
		 * 
		 */
		public static function createMsg(msg:String,type0:int=0,type1:int=0,type2:int=0):Object{
			return new MsgVO(msg,type0,type1,type2);
		}
		
		
		public static function createNormalMsg(msg:String,type1:int=0,typ2:int=0):Object{
			return createMsg(msg,MsgConstants.NORMAL_MSG,type1,type2);
		}
		public static function createGoodMsg(msg:String,type1:int=0,typ2:int=0):Object{
			return createMsg(msg,MsgConstants.GOOD_MSG,type1,type2);
		}
		public static function createBadMsg(msg:String,type1:int=0,typ2:int=0):Object{
			return createMsg(msg,MsgConstants.BAD_MSG,type1,type2);
		}
		
		public static function createChatMsg(msg:String,type2:int=0):Object{
			return createNormalMsg(msg,MsgConstants.CHAT_MSG,type2);
		}
		public static function createTradeMsg(msg:String,type2:int=0):Object{
			return createNormalMsg(msg,MsgConstants.TRADE_MSG,type2);
		}
		public static function createFriendMsg(msg:String,type2:int=0):Object{
			return createNormalMsg(msg,MsgConstants.FRIEND_MSG,type2);
		}
		public static function createGroupMsg(msg:String,type2:int=0):Object{
			return createNormalMsg(msg,MsgConstants.GROUP_MSG,type2);
		}
		public static function createCharMsg(msg:String,type2:int=0):Object{
			return createNormalMsg(msg,MsgConstants.CHAR_MSG,type2);
		}
		
		public static function createPetMsg(msg:String,type2:int=0):Object{
			return createNormalMsg(msg,MsgConstants.PET_MSG,type2);
		}
		public static function createMapMsg(msg:String,type2:int=0):Object{
			return createNormalMsg(msg,MsgConstants.MAP_MSG,type2);
		}
		public static function createFightMsg(msg:String,type2:int=0):Object{
			return createNormalMsg(msg,MsgConstants.CHAR_MSG,type2);
		}
		public static function createStallMsg(msg:String,type2:int=0):Object{
			return createNormalMsg(msg,MsgConstants.STALL_MSG,type2);
		}
		public static function createQuestMsg(msg:String,type2:int=0):Object{
			return createNormalMsg(msg,MsgConstants.QUEST_MSG,type2);
		}
		
	}
}