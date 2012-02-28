package com.netease.webgame.bitchwar.login.logic.login;

import java.util.ArrayList;
import java.util.HashMap;

import com.netease.webgame.bitchwar.core.net.NetConn;
import com.netease.webgame.bitchwar.core.net.NetManager;
import com.netease.webgame.bitchwar.login.db.LoginDBQuery;
import com.netease.webgame.bitchwar.login.logic.account.AccountManager;
import com.netease.webgame.bitchwar.login.net.LoginClientPacketHandler;
import com.netease.webgame.bitchwar.login.net.LoginNetManager;
import com.netease.webgame.bitchwar.model.vo.account.AccountVO;
import com.netease.webgame.bitchwar.model.vo.common.ResultVO;
import com.netease.webgame.bitchwar.proxy.account.Account;
import com.netease.webgame.core.model.vo.net.CallVO;


public class LoginLogic {
	public static void sCreateAccount(int socketId,String accountName,String passWord){
		boolean success = LoginDBQuery.createAccount(accountName, passWord);
		if(success){
			LoginNetManager.callClient(socketId,new CallVO(LoginClientPacketHandler.C_CREATE_ACCOUNT_SUCCESS));
		}
		else{
			LoginNetManager.callClient(socketId,new CallVO(LoginClientPacketHandler.C_CREATE_ACCOUNT_FAIL));
		}
	}
	public static void sLogin(int socketId,String accountName,String password){
		boolean  success = login(socketId,accountName,password);
		if(success){
			ArrayList<HashMap<String,Object>> charList = LoginDBQuery.getCharList(accountName);
			LoginNetManager.callClient(socketId,new CallVO(LoginClientPacketHandler.C_LOGIN_SUCCESS,charList));
		}
		else{
			LoginNetManager.callClient(socketId,new CallVO(LoginClientPacketHandler.C_LOGIN_FAIL));
		}
	}
	public static boolean login(int socketId,String userName,String password){
		HashMap<String,Object> data = LoginDBQuery.getAccount(userName, password);
		if(data!=null){
			AccountVO accountVO = new AccountVO();
			accountVO.id = (Integer)data.get("id");
			accountVO.name = (String)data.get("name");
			accountVO.adult = (Integer)data.get("adult");
			NetConn net = NetManager.getNetConn(socketId);
			Account account = new Account(accountVO,net);
			AccountManager.addAccountBySocketId(socketId, account);
			return true;
		}
		else{
			return false;
		}

	}
	public static void sCreateChar(Account account,String charname,int race){
		ResultVO result = createChar(account.accountVO.name,charname,race);
		if(result.code==ResultVO.SUCCESS_CODE){
			account.call(new CallVO(LoginClientPacketHandler.C_CREATE_CHAR));
		}
		else{
			
		}
			
	}
	public static ResultVO createChar(String accname,String charname,int race){
		ArrayList<HashMap<String,Object>> charList = LoginDBQuery.getCharList(accname);
		if(charList.size()>=3){
			return ResultVO.ERROR;
		}
		else{
			boolean success = LoginDBQuery.createChar(accname, charname, race);
			if(success){
				return ResultVO.SUCCESS;
			}
			else{
				return ResultVO.ERROR;
			}
		}
	}
	public static void chooseChar(int socketId,int charaid){

	}
}
