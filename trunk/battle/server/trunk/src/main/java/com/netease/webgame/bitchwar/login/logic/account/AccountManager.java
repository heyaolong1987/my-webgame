package com.netease.webgame.bitchwar.login.logic.account;

import java.util.HashMap;

import com.netease.webgame.bitchwar.proxy.account.Account;



public class AccountManager {
	private static HashMap<Integer,Account> accountMap = new HashMap<Integer,Account>();
	private static HashMap<Integer,Account> accountMapBySocket = new HashMap<Integer,Account>();
	private static HashMap<Integer,Integer> socketMapByAccount = new HashMap<Integer,Integer>();
	public static void addAccountBySocketId(int socketId,Account account){
		accountMap.put(account.accountVO.id,account);
		accountMapBySocket.put(socketId,account);
		socketMapByAccount.put(account.accountVO.id,socketId);
	}
	public static Account getAccountBySocketId(int socketId){
		return accountMapBySocket.get(socketId);
	}
	public static Account deleteAccountBySocketId(int socketId){
		Account account = accountMapBySocket.remove(socketId);
		if(account!=null){
			socketMapByAccount.remove(account.accountVO.id);
		}
		return account;
	}
	
	public static int getSocketIdByAccountId(int accountId){
		return socketMapByAccount.get(accountId);
	}
	
	public static Account deleteAccount(int accountId){
		Account account = accountMap.remove(accountId);
		long socketId = socketMapByAccount.remove(accountId);
		if(socketId>0){
			accountMapBySocket.remove(socketId);
		}
		return account;
	}
	public static Account getAccount(int accountId){
		return accountMap.get(accountId);
	}
}
