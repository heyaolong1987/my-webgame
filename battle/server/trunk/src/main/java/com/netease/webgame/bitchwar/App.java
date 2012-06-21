package com.netease.webgame.bitchwar;

import com.netease.webgame.bitchwar.core.db.DBManager;
import com.netease.webgame.bitchwar.core.server.Server;

public class App 
{

	public static void main( String[] args )
	{
		DBManager.init();
		Server scene = new Server(Config.port);
		scene.run();
		
	}
}
