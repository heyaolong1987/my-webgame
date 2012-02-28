package com.netease.webgame.bitchwar.core.net;

import com.netease.webgame.bitchwar.console.Console;
import com.netease.webgame.bitchwar.login.net.LoginPacketHandler;
import com.netease.webgame.bitchwar.model.vo.account.AccountVO;
import com.netease.webgame.bitchwar.scene.charactor.Charactor;
import com.netease.webgame.bitchwar.scene.net.ScenePacketHandler;
import com.netease.webgame.bitchwar.world.net.WorldPacketHandler;
import com.netease.webgame.core.model.vo.net.InceptVO;

public class PacketManager {
	public static boolean procFunc(int socketId,InceptVO inceptVO){
		if(LoginPacketHandler.procFunc(socketId,inceptVO)){
			return true;
		}
		if(ScenePacketHandler.procFunc(socketId,inceptVO)){
			return true;
		}
		else if(WorldPacketHandler.procFunc(socketId,inceptVO)){
			return true;
		}
		return false;
	}
}
