package com.netease.webgame.bitchwar.core.db;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

import com.netease.webgame.bitchwar.console.Console;

public class DBManager {
	static String JDriver = "com.mysql.jdbc.Driver";  // MySQL�ṩ��JDBC������Ҫ��֤����CLASSPATH��ɼ�

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
		catch(ClassNotFoundException e) {  // ����Ҳ���������
			Console.error("Driver Not Found: " + e);
		}
		try {
			Connection con = DriverManager.getConnection(connUrl,dbAdmin, dbPass);  // �������ݿ�
			if(!con.isClosed()){
				Statement s = con.createStatement();  // Statement�������ύSQL���
				ResultSet rs = s.executeQuery(sql);  // �ύ��ѯ�����صı�񱣴���rs��
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
				s.close();     // �ͷ�Statement����
				con.close();   // �رյ�MySQL������������
				return table;
			}
		}
		catch(SQLException e) {     // ����SQLException
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
		catch(ClassNotFoundException e) {  // ����Ҳ���������
			Console.error("Driver Not Found: " + e);
		}
		try {
			Connection con = DriverManager.getConnection(connUrl,dbAdmin, dbPass);  // �������ݿ�
			if(!con.isClosed()){
				Statement s = con.createStatement();  // Statement�������ύSQL���
				int result = s.executeUpdate(sql);  // �ύ��ѯ�����صı�񱣴���rs��
				s.close();     // �ͷ�Statement����
				con.close();   // �رյ�MySQL������������
				return result;
			}
		}
		catch(SQLException e) {     // ����SQLException
			Console.error(e.toString());
		}
		return 0;
	}
}
