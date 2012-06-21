package com.netease.webgame.bitchwar.core.server;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import com.netease.webgame.bitchwar.console.Console;
import com.netease.webgame.bitchwar.core.net.NetConn;
import com.netease.webgame.bitchwar.core.net.NetManager;


public class Server extends Thread{
	ServerSocket serverSocket;
	int port;
	Boolean isRun = true;
	//线程池
	private ExecutorService threadPool;
    
	public Server(int port){
		try{
			this.port = port;
			serverSocket = new ServerSocket(port);
			NetManager.init();
		}catch(IOException e){
			Console.error(e.toString());
		}

	}
	public void run(){

		threadPool = Executors.newCachedThreadPool();

		Console.print("server start");
		while(isRun){
			try {
				//接受客户端连接，并启动新的线程
				Socket socket = serverSocket.accept();
				socket.setKeepAlive(true);
				NetConn netConn = NetManager.createNetConn(socket);
				threadPool.execute(netConn);
				Console.print("server is continue");
			} catch(SocketException e){
				Console.error(e.toString());
			}
			catch (IOException e) {
				Console.error(e.toString());
			}
			
		}

		Console.print("server end");
		try {
			serverSocket.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	



}
