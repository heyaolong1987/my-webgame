package com.netease.webgame.bitchwar.constants.mouse
{
	public class MouseConstants
	{
		
		public static const MOUSE_MODE_NORMAL:int = 0;	//正常模式，非正常模式物品鼠标左键菜单，拖放均不可用
		public static const MOUSE_MODE_REPAIR:int = 1;	//修理模式
		public static const MOUSE_MODE_SELL:int = 2;		//出售模式
		public static const MOUSE_MODE_FEED_PET:int = 3;	//喂养战斗兽
		public static const MOUSE_MODE_SPLIT:int = 4;	//拆分
		public static const MOUSE_MODE_DECOMPOSE:int = 5;//分解
		
		public static const MOUSE_MODE_FIGHT_CATCH:int = 6;
		public static const MOUSE_MODE_FIGHT_ATTACK:int = 7;
		public static const MOUSE_MODE_FIGHT_CHOOSE_SKILL:int = 8;
		public static const MOUSE_MODE_FIGHT_CHOOSE_ITEM:int = 9;
		public static const MOUSE_MODE_FIGHT_PROTECT:int = 10;
		
		public static const MOUSE_MODE_FIGHT_CATCH_ENABLE:int = 11;
		public static const MOUSE_MODE_FIGHT_ATTACK_ENABLE:int = 12;
		public static const MOUSE_MODE_FIGHT_SKILL_ENABLE:int = 13;
		public static const MOUSE_MODE_FIGHT_ITEM_ENABLE:int = 14;
		public static const MOUSE_MODE_FIGHT_PROTECT_ENABLE:int = 15;
		
		public static const MOUSE_MODE_FIGHT_CATCH_DISABLE:int = 16;
		public static const MOUSE_MODE_FIGHT_ATTACK_DISABLE:int = 17;
		public static const MOUSE_MODE_FIGHT_SKILL_DISABLE:int = 18;
		public static const MOUSE_MODE_FIGHT_ITEM_DISABLE:int = 19;
		public static const MOUSE_MODE_FIGHT_PROTECT_DISABLE:int = 20;
		
		public static const MOUSE_MODE_ITEM_FORGE:int = 21;	//注魔
		public static const MOUSE_MODE_ITEM_WEAPON_IDENTIFY:int = 22;//武器鉴定
		public static const MOUSE_MODE_ITEM_USE_TO_EQUIPMENT:int = 24;
		public static const MOUSE_MODE_ITEM_USE_TO_SLAVE:int = 25;
		public static const MOUSE_MODE_ITEM_USE_TO_PET:int = 26;		//双击指定战斗兽
		public static const MOUSE_MODE_ITEM_USE_CHUAN_SONG_SHEN_FU:int = 27;	//传送神符
		public static const MOUSE_MODE_ITEM_USE_KONG_SOU_YI:int = 28;	//使用控兽仪
		public static const MOUSE_MODE_ITEM_USE_MING_KE_FU:int = 29;		//铭刻符
		
		public static const MOUSE_MODE_PET_IDENTIFY:int = 100; //战斗兽鉴定(又：战斗兽驯化，战斗兽激活)
		public static const MOUSE_MODE_PET_APPOIN_SKILL:int = 101;//使用物品后，点击技能
		
		//以下世界地图部分，优先级最低，如果当前mouse不是MOUSE_NORMAL，移到mapitem上不需要改变
		public static const MOUSE_MODE_MAP_NORMAL:int = 1000;
		public static const MOUSE_MODE_MAP_PICK:int = 1001;
		public static const MOUSE_MODE_MAP_HERO:int = 1002;
		public static const MOUSE_MODE_MAP_FIGHT:int = 1003;
		public static const MOUSE_MODE_MAP_ENTER:int = 1004;
		
		public function MouseConstants()
		{
		}
	}
}