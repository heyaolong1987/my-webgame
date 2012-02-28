package com.netease.webgame.bitchwar
{
	import com.netease.webgame.bitchwar.controller.call.*;
	import com.netease.webgame.bitchwar.controller.incept.fight.*;
	import com.netease.webgame.bitchwar.controller.incept.login.*;
	import com.netease.webgame.bitchwar.controller.inner.application.*;
	import com.netease.webgame.bitchwar.controller.inner.gameview.*;
	import com.netease.webgame.bitchwar.controller.inner.mouse.*;
	
	import org.puremvc.as3.interfaces.INotification;

	public class ApplicationFacade extends BaseFacade
	{
		public function ApplicationFacade()
		{
		}
		public static function getInstance():ApplicationFacade {
			if (instance == null)
				instance = new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		
		override protected function initializeController():void {
			super.initializeController();
			//*********************************************************************call command  start **********************************************************************//
			registerCommand(CallCommandConstants.CALL_SERVER,CallServerCommand);
			//*********************************************************************call command end **********************************************************************//
			
			
			
			
			
			//*********************************************************************incept command start**********************************************************************//
			registerCommand(InceptCommandConstants.START_FIGHT,InceptStartFightCommand);
			registerCommand(InceptCommandConstants.LOGIN_SUCCESS,InceptLoginSuccessCommand);
			registerCommand(InceptCommandConstants.LOGIN_FAIL,InceptLoginFailCommand);
			
			//*********************************************************************incept command end**********************************************************************//
			
			
						
			//*********************************************************************inner command start**********************************************************************//
			/***************************************启动 start  *****************************/
			registerCommand(InnerCommandConstants.START_UP,StartUpCommand);
			/***************************************启动 end *****************************/
			
			/***************************************角色视图 start  *****************************/
			
			/***************************************角色视图 end  *****************************/
			
			
			/***************************************应用程序视图 start  *****************************/
			registerCommand(InnerCommandConstants.APPLICATION_VIEW_CHANGED,ApplicationViewChangedCommand);
			/***************************************应用程序视图 end  *****************************/
			
			/***************************************游戏视图 start*********************************/
			registerCommand(InnerCommandConstants.GAME_VIEW_CHANGED,GameViewChangedCommand);
			/***************************************游戏视图 end*********************************/
			
			/*****************************鼠标 start**************************************/
			registerCommand(InnerCommandConstants.CHANGE_MOUSE_MODE,ChangeMouseModeCommand);
			/*****************************鼠标 end**************************************/
			//*********************************************************************inner command end**********************************************************************//
				
		}
		
	}
}