package com.netease.webgame.bitchwar.core.net;

import java.net.Socket;
import java.util.LinkedList;
import java.util.Queue;

import com.netease.webgame.bitchwar.console.Console;


public class NetManager {
	private static int sockNum = 0;
	private static NetConn serverThread[] = new NetConn[5000];
	private static Socket socketArr[] = new Socket[5000];
	private static Socket nowSocket[] = null;
	private static Queue<Integer> freeQueue = new LinkedList<Integer>();

	public static NetConn deleteNetConn(int socketId){
		return null;
	}
	public static NetConn addNetConn(int socketId,NetConn user){
		//return netConnMap.put(socketId,user);
		return null;
	}
	public static NetConn getNetConn(int socketId){
		return serverThread[socketId];
	}
	public static void init(){
		for(int i=0;i<5000;i++){
			freeQueue.add(i);
		}
	}
	private static int addSocket(Socket socket){
		Integer id = freeQueue.poll();
		if(id==null){
			Console.error("no free socket");
		}
		else{
			Console.print("socket "+id+" "+socket.getRemoteSocketAddress().toString()+" connected ");
			socketArr[id] = socket;
			sockNum++;
		}
		return id;
	}
	private static void deleteSocket(int id){
		if(socketArr!=null){
			socketArr[id] = null;
			freeQueue.add(id);
		}
	}
	public static NetConn createNetConn(Socket socket){
		
		int id = addSocket(socket);
		serverThread[id] = new NetConn(id,socket);
		return serverThread[id];
	}
}
