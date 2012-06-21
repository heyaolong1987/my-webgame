package com.netease.webgame.bitchwar.model.vo.common;

public class ResultVO {
	public static ResultVO ERROR = new ResultVO(-1);
	public static ResultVO ERROR1 = new ResultVO(-1);
	public static ResultVO ERROR2 = new ResultVO(-2);
	public static ResultVO ERROR3 = new ResultVO(-3);
	public static ResultVO ERROR4 = new ResultVO(-4);
	public static ResultVO ERROR5 = new ResultVO(-5);
	public static ResultVO ERROR6 = new ResultVO(-6);
	public static ResultVO ERROR7 = new ResultVO(-7);
	public static ResultVO ERROR8 = new ResultVO(-8);
	public static ResultVO ERROR9 = new ResultVO(-9);
	public static ResultVO ERROR10 = new ResultVO(-10);
	public static ResultVO SUCCESS = new ResultVO(1);

	public static int ERROR_CODE_1 = -1;
	public static int ERROR_CODE2 = -2;
	public static int ERROR_CODE3 = -3;
	public static int ERROR_CODE4 = -4;
	public static int ERROR_CODE5 = -5;
	public static int ERROR_CODE6 = -6;
	public static int ERROR_CODE7 = -7;
	public static int ERROR_CODE8 = -8;
	public static int ERROR_CODE9 = -9;
	public static int ERROR_CODE10 = -10;
	public static int ERROR_CODE = -1;
	public static int SUCCESS_CODE = 1;
	
	public int code;
	public Object result;
	public ResultVO(int code,Object result){
		this.result = result;
		this.code = code;
	}
	public ResultVO(Object result){
		this.result = result;
		code = 0;
	}
	public ResultVO(int code){
		this.code = code;
		this.result = null;
	}
}
