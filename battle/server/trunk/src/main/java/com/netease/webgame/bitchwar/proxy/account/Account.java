package com.netease.webgame.bitchwar.proxy.account;

import com.netease.webgame.bitchwar.core.net.NetConn;
import com.netease.webgame.bitchwar.core.net.NetManager;
import com.netease.webgame.bitchwar.model.vo.account.AccountVO;
import com.netease.webgame.core.model.vo.net.CallVO;

public class Account {
	public NetConn net;
	public AccountVO accountVO;
	public Account(AccountVO accountVO,NetConn net){
		this.accountVO = accountVO;
		this.net = net;
	}
	public void call(CallVO callVO){
		net.call(callVO);
	}
	
}
