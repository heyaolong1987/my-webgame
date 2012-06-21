package com.netease.webgame.bitchwar.core.db;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

import com.netease.webgame.bitchwar.console.Console;

public class DBManager {
	static String JDriver = "com.mysql.jdbc.Driver";  // MySQL提供的JDBC驱动，要保证它在CLASSPATH里可见

	static String dbUrl = "localhost";
	static String dbPort = "3306";
	static String dbAdmin = "root";
	static String dbPass = "";
	static String dbName = "game";
	static String connUrl = "";
	public static void init(){
		connUrl = "jdbc:mysql://"+dbUrl+":"+dbPort+"/"+dbName;
	}
	public static ArrayList<HashMap<String,Object>> select(String sql){
		try {
			Class.forName(JDriver);
		}
		catch(ClassNotFoundException e) {  // 如果找不到驱动类
			Console.error("Driver Not Found: " + e);
		}
		try {
			Connection con = DriverManager.getConnection(connUrl,dbAdmin, dbPass);  // 连接数据库
			if(!con.isClosed()){
				Statement s = con.createStatement();  // Statement类用来提交SQL语句
				ResultSet rs = s.executeQuery(sql);  // 提交查询，返回的表格保存在rs中
				int colNum = rs.getMetaData().getColumnCount();
				String[] colName = new String[colNum];
				for(int i=0;i<colNum;i++){
					colName[i] = rs.getMetaData().getColumnName(i+1);
				}
				ArrayList<HashMap<String,Object>> table = new ArrayList<HashMap<String,Object>>();
				while(rs.next()){
					HashMap<String,Object> col = new HashMap<String,Object>();
					int i;
					for(i=0;i<colNum;i++){
						col.put(colName[i],rs.getObject(i+1));
					}
					table.add(col);
				}
				s.close();     // 释放Statement对象
				con.close();   // 关闭到MySQL服务器的连接
				return table;
			}
		}
		catch(SQLException e) {     // 都是SQLException
			Console.error(e.toString());
		}
		return null;
	}
	public static int insert(String sql){
		return _update(sql);
	}
	public static int update(String sql){
		return _update(sql);
	}
	public static int delete(String sql){
		return _update(sql);
	}
	private static int _update(String sql){
		try {
			Class.forName(JDriver);
		}
		catch(ClassNotFoundException e) {  // 如果找不到驱动类
			Console.error("Driver Not Found: " + e);
		}
		try {
			Connection con = DriverManager.getConnection(connUrl,dbAdmin, dbPass);  // 连接数据库
			if(!con.isClosed()){
				Statement s = con.createStatement();  // Statement类用来提交SQL语句
				int result = s.executeUpdate(sql);  // 提交查询，返回的表格保存在rs中
				s.close();     // 释放Statement对象
				con.close();   // 关闭到MySQL服务器的连接
				return result;
			}
		}
		catch(SQLException e) {     // 都是SQLException
			Console.error(e.toString());
		}
		return 0;
	}
}
