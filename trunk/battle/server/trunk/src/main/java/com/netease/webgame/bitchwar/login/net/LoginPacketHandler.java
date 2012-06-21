package com.netease.webgame.bitchwar.login.net;

import java.util.HashMap;
import java.util.Hashtable;

import com.netease.webgame.bitchwar.Convert.ConvertDataType;
import com.netease.webgame.bitchwar.console.Console;
import com.netease.webgame.bitchwar.login.logic.account.AccountManager;
import com.netease.webgame.bitchwar.login.logic.login.LoginLogic;
import com.netease.webgame.bitchwar.model.vo.account.AccountVO;
import com.netease.webgame.bitchwar.proxy.account.Account;
import com.netease.webgame.bitchwar.scene.charactor.Charactor;
import com.netease.webgame.core.model.vo.net.InceptVO;


public class LoginPacketHandler {
	public static String LOGIN = "login";
	public static String CREATE_ACCOUNT = "createAccount";
	public static String CREATE_CHAR = "createChar";
	public static boolean procFunc(int socketId,InceptVO inceptVO){
		boolean isLoginFunc = true;
		String funcName = inceptVO.funcName;
		if(funcName.equals(LoginPacketHandler.CREATE_ACCOUNT)){
			LoginLogic.sCreateAccount(socketId,(String)inceptVO.args[0],(String)inceptVO.args[1]);
		}
		else if(funcName.equals(LoginPacketHandler.LOGIN)){
			LoginLogic.sLogin(socketId,(String)inceptVO.args[0],(String)inceptVO.args[1]);
		}
		else{
			Account account= AccountManager.getAccountBySocketId(socketId);
			if(account==null){
				Console.error("no this account,socketId "+String.valueOf(socketId));
				return false;
			}
			if(funcName.equals(LoginPacketHandler.CREATE_CHAR)){
				LoginLogic.sCreateChar(account,(String)inceptVO.args[0],(Integer)inceptVO.args[1]);
			}
			else{
				isLoginFunc = false;
			}
		}
		return isLoginFunc;
	}


}
