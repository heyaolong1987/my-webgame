package com.netease.webgame.bitchwar.scene.net;

import com.netease.webgame.core.model.vo.net.InceptVO;

public class ScenePacketHandler {
	public static boolean procFunc(int socketId,InceptVO inceptVO){
		boolean isSceneFunc = true;
		String funcName = (String)inceptVO.funcName;
		if(funcName=="selectChar"){
			
		}
		else{
			isSceneFunc = false;
			
		}
		return isSceneFunc;
	}
	public static void callClient(int accountId,String funcName,Object[]...args){
		
	}
	public static void callScene(int accountId,String funcName,Object[]...args){
		
	}
	public static void broadcastAllScenes(String funcName,Object[]...args){
		
	}
	public static void callWorld(String funcName,Object[]...args){
		
	}
}
