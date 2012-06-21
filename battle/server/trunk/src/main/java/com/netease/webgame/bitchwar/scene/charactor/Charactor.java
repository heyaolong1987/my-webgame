package com.netease.webgame.bitchwar.scene.charactor;

import com.netease.webgame.bitchwar.proxy.account.Account;
import com.netease.webgame.bitchwar.scene.net.ScenePacketHandler;

public class Charactor {
	public int id;
	public String name;
	public String level;
	public int accountId;
	public void call(String funcName,Object...args){
		ScenePacketHandler.callClient(accountId, funcName, args);
	}
}
