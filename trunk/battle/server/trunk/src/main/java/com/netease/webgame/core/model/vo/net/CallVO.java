package com.netease.webgame.core.model.vo.net;
public class CallVO {
	public String funcName;
	public Object[] args;
	public CallVO(String funcName,Object...args){
		this.funcName = funcName;
		this.args = args;
	}
}
