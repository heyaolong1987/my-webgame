package com.netease.webgame.bitchwar.core.net;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.net.SocketException;
import java.util.Timer;
import java.util.TimerTask;

import com.netease.webgame.bitchwar.Convert.ConvertDataType;
import com.netease.webgame.bitchwar.console.Console;
import com.netease.webgame.bitchwar.login.net.LoginClientPacketHandler;
import com.netease.webgame.bitchwar.login.net.LoginPacketHandler;
import com.netease.webgame.core.model.vo.net.CallVO;
import com.netease.webgame.core.model.vo.net.InceptVO;


public class NetConn implements Runnable {
	private Socket clientSocket;
	private int port;
	private int socketId=0;
	private DataInputStream dataInputStream;
	private DataOutputStream dataOutputStream;
	private String stringBuff;
	private String msg="";
	private Timer timer = new Timer();
	private static int STATE_HEADER = 0;
	private static int STATE_CONTENT = 1;
	private int recvState = STATE_HEADER;
	private int headerLength = 4;
	// 当前正在等待的内容总长度
	private int contentLength = 0; 
	private boolean isRun = true;
	public NetConn(int socketId,Socket s){
		this.socketId =socketId;
		clientSocket = s;
		/*timer.schedule(new TimerTask() {
			public void run() {
				call(new CallVO(LoginClientPacketHandler.UPDATE_TIME,System.currentTimeMillis()));
			}
		}, 0, 5000);*/

	}
	public int getSocketId(){
		return socketId;
	}
	public Socket getClient(){
		return clientSocket;
	}
	public void run(){
		try{
			dataInputStream = new DataInputStream(clientSocket.getInputStream());
			dataOutputStream = new DataOutputStream(clientSocket.getOutputStream());
			while(isRun){
				if(dataInputStream.available()>0){
					contentLength = dataInputStream.available();
					byte[] byteArr = new byte[contentLength];
					dataInputStream.read(byteArr,0,contentLength);
					onGetPacket(byteArr);
				}
			}
			try{
				clientSocket.close();
			}catch(IOException ioe){
				Console.error(ioe.toString());
			}
		}
		catch(SocketException e){
			Console.error(e.toString());
			try{
				clientSocket.close();
			}catch(IOException ioe){
				Console.error(ioe.toString());
			}

		}
		catch(IOException e){
			Console.error(e.toString());
		}
	}
	private void onGetPacket(byte[] byteArr){
		InceptVO inceptVO = (InceptVO)ConvertDataType.flashByteArrayToObject(byteArr);
		LoginPacketHandler.procFunc(this.socketId,inceptVO);
	}
	public void call(CallVO callVO){
		byte[] t = createPacket(callVO);
		try {
			dataOutputStream.writeInt(t.length);
			dataOutputStream.write(t);
			dataOutputStream.flush();
		} catch (IOException e) {
			try{
				clientSocket.close();
			}
			catch(IOException ex){
				
			}
			e.printStackTrace();
		}
	}
	private byte[] createPacket(CallVO callVO){
		byte[] t = ConvertDataType.objectToFlashByteArray(callVO);
		return t;
	}

}
