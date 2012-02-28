package com.netease.webgame.bitchwar.model.vo.charactor;

import com.netease.webgame.bitchwar.model.vo.baseclass.BaseItemVO;
public class CharactorVO extends BaseItemVO {
	/**
	 * 性别
	 */
	public int sex;
	
	/**
	 *等级 
	 */
	public int level;
	
	/**
	 *经验 
	 */
	public int exp;
	
	/**
	 *金币 
	 */
	public int money;
	
	/** 
	 * 种族,门派，阵营
	 */
	public int race;
	
	/**
	 *精力 
	 */
	public int energy;
	
	/**
	 *精力上限 
	 */
	public int maxEnergy;
	
	/**
	 * vip类型
	 */
	public int vipType;
	
	/**
	 *所在场景类型 
	 */
	public int sceneType;
	
	/**
	 *场景ID 
	 */
	public int sceneId;
}
