package com.netease.webgame.bitchwar.login.db;

import java.util.ArrayList;
import java.util.HashMap;

import com.netease.webgame.bitchwar.core.db.DBManager;
import com.netease.webgame.bitchwar.login.net.LoginClientPacketHandler;
import com.netease.webgame.bitchwar.login.net.LoginNetManager;

public class LoginDBQuery {
	public static boolean createAccount(String accountName,String passWord){	
		int result = DBManager.insert("insert into t_account(name,pwd,adult,createtime) values('"+accountName+"','"+passWord+"',0,'"+Math.floor(System.currentTimeMillis()/1000)+"')");
		if(result>0){
			return true;
		}
		return false;
	}
	public static HashMap<String,Object> getAccount(String userName,String password){
		HashMap<String,Object> account=null;
		ArrayList<HashMap<String,Object>> table = DBManager.select("select * from t_account where name ='"+userName+"' and pwd = '"+password+"'");
		if(table.size()>0){
			account = table.get(0);
		}
		return account;
	}
	public static HashMap<String,Object> getChar(String accname,Number charid){
		HashMap<String,Object> charactor=null;
		ArrayList<HashMap<String,Object>> table = DBManager.select("select * from t_char where accname = '"+accname+"' and id ='"+charid+"'");
		if(table.size()>0){
			charactor = table.get(0);
		}
		return charactor;
	}
	public static boolean createChar(String accname,String charname,int race){	
		int result = DBManager.insert("insert into t_char(accname,name,createtime,race) values('"+accname+"','"+charname+"','"+Math.floor(System.currentTimeMillis()/1000)+"','"+race+"')");
		if(result>0){
			return true;
		}
		return false;
	}
	public static boolean deleteChar(Number accountId,Number charId){
		int result = DBManager.delete("delete t_char where accountid = '"+accountId+"' and charid = '"+charId+"'");
		if(result>0){
			return true;
		}
		return false;
	}
	public static ArrayList<HashMap<String,Object>> getCharList(String accname){
		return DBManager.select("select id,name,accname,createtime,level,sex,race from t_char where accname = '"+accname+"' order by id");
	}
}

