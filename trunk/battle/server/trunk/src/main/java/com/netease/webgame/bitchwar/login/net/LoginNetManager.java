package com.netease.webgame.bitchwar.login.net;

import com.netease.webgame.bitchwar.core.net.NetConn;
import com.netease.webgame.bitchwar.core.net.NetManager;
import com.netease.webgame.bitchwar.login.logic.account.AccountManager;
import com.netease.webgame.core.model.vo.net.CallVO;

public class LoginNetManager {
	public static void conn(){

	}
	public static void callClient(int socketId,CallVO callVO){
		NetConn net = NetManager.getNetConn(socketId);
		net.call(callVO);
	}
	public static void callWorld(String funcName,Object...args){

	}
	public static void callScene(int sceneId,String funcName,Object...args){

	}
	public static void broadcastAllScenes(String funcName,Object...args){
		
	}
}
