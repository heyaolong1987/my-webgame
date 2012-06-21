package com.netease.webgame.bitchwar.model.vo.baseclass;

/**
 *宠物，人物，物品，装备，怪物的基类 
 * @author hyl
 * 
 */
public class BaseItemVO {
	/**
	 *ID 
	 */
	public int id;
	
	/**
	 *名称 
	 */
	public String name;

	/**
	 * 物品模板ID
	 */
	public int tempId;

	/**
	 * 创建时间
	 */
	public long createTime;
	
	/**
	 *资源url 
	 */
	public String resName;
	
}
