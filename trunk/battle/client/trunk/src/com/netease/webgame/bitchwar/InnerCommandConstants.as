package com.netease.webgame.bitchwar
{
	public class InnerCommandConstants
	{
		//应用程序启动
		public static const START_UP:String = "START_UP";
		
		public static const CHANGE_APPLICATION_VIEW:String = "CHANGE_APPLICATION_VIEW";
		public static const APPLICATION_VIEW_CHANGED:String = "APPLICATION_VIEW_CHANGED";
		public static const CHANGE_APPLICATION_VIEW_FAIL:String = "CHANGE_APPLICATION_VIEW_FAIL";
		/***************************************视图切换 start****************************************/
		//登陆视图改变
		public static const LOGIN_VIEW_CHANGED:String = "LOGIN_VIEW_CHANGED";
		public static const CHANGE_LOGIN_VIEW_FAIL:String = "CHANGE_LOGIN_VIEW_FAIL";
		//游戏视图改变
		public static const GAME_VIEW_CHANGED:String = "GAME_VIEW_CHANGED";
		public static const CHANGE_GAME_VIEW_FAIL:String = "CHANGE_GAME_VIEW_FAIL";
		
		/***************************************视图切换 end*******************************************/
		
		
		/***************************************登陆相关 start ***************************************/
		public static const LOGIN_SUCCESS:String = "LOGIN_SUCCESS";
		/***************************************登陆相关 end ***************************************/
		
		/***************************************战斗相关 start****************************************/
		//游戏视图改变
		public static const START_FIGHT:String = "START_FIGHT";
		
		public static const ACTION_FINISHED:String = "ACTION_FINISHED";
		/***************************************战斗相关 end*******************************************/
		
		
		/***************************************message start*******************************************/
		public static const SHOW_SYS_MSG:String = "SHOW_SYS_MSG";
		public static const SHOW_CHAT_MSG:String = "SHOW_CHAT_MSG";
		public static const SHOW_MODELESS_TIP_MSG:String = "SHOW_MODELESS_TIP_MSG"
		/***************************************test end*******************************************/
		
		/***************************************鼠标相关 start*******************************************/
		public static const CHANGE_MOUSE_MODE:String = "CHANGE_MOUSE_MODE";
		/***************************************鼠标相关 end*******************************************/
		
		
		/***************************************test start*******************************************/
		public static const SHOW_PLAYER:String = "SHOW_PLAYER";
		/***************************************test end*******************************************/
		
		public function InnerCommandConstants()
		{
		
		}
	}
}