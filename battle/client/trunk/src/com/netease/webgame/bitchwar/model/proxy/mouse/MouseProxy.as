package com.netease.webgame.bitchwar.model.proxy.mouse
{
	import com.netease.webgame.bitchwar.assets.EmbedRes;
	import com.netease.webgame.bitchwar.constants.mouse.MouseConstants;
	import com.netease.webgame.bitchwar.manager.MouseManager;
	import com.netease.webgame.bitchwar.model.proxy.baseclass.BaseProxy;
	
	public class MouseProxy extends BaseProxy
	{
		public static const NAME:String = "MOUSE_PROXY";
		
		
		public function MouseProxy()
		{
			super(NAME);
		}
		override public function onRegister():void{
			var mouseManager:MouseManager = MouseManager.getInstance();
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_NORMAL,null);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_SELL,EmbedRes.MouseSellMc);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_FEED_PET,EmbedRes.MouseFeedMc);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_REPAIR,EmbedRes.MouseRepairMc);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_DECOMPOSE,EmbedRes.MouseRepairMc);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_SPLIT,EmbedRes.MouseRepairMc);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_FIGHT_ATTACK,EmbedRes.FightAttackCursor);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_FIGHT_CATCH,EmbedRes.FightCatchCursor);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_FIGHT_CHOOSE_ITEM,EmbedRes.FightUseItemCursor);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_FIGHT_CHOOSE_SKILL,EmbedRes.FightUseSkillCursor);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_FIGHT_PROTECT,EmbedRes.FightProtectCursor);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_FIGHT_ATTACK_DISABLE,EmbedRes.FightAttackDisableCursor);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_FIGHT_CATCH_DISABLE,EmbedRes.FightCatchDisableCursor);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_FIGHT_ITEM_DISABLE,EmbedRes.FightUseItemDisableCursor);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_FIGHT_SKILL_DISABLE,EmbedRes.FightUseSkillDisableCursor);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_FIGHT_PROTECT_DISABLE,EmbedRes.FightProtectDisableCursor);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_FIGHT_ATTACK_ENABLE,EmbedRes.FightAttackEnableCursor);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_FIGHT_CATCH_ENABLE,EmbedRes.FightCatchEnableCursor);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_FIGHT_ITEM_ENABLE,EmbedRes.FightUseItemEnableCursor);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_FIGHT_SKILL_ENABLE,EmbedRes.FightUseSkillEnableCursor);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_FIGHT_PROTECT_ENABLE,EmbedRes.FightProtectEnableCursor);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_ITEM_FORGE,EmbedRes.MouseForgeMc);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_ITEM_WEAPON_IDENTIFY,EmbedRes.MouseIdentifyMc);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_PET_IDENTIFY,EmbedRes.MouseSelectItemMc);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_ITEM_USE_TO_EQUIPMENT,EmbedRes.MouseSelectItemMc);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_ITEM_USE_TO_PET,EmbedRes.MouseSelectItemMc);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_ITEM_USE_TO_SLAVE,EmbedRes.MouseSelectItemMc);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_ITEM_USE_CHUAN_SONG_SHEN_FU,EmbedRes.MouseSelectItemMc);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_ITEM_USE_KONG_SOU_YI,EmbedRes.MouseSelectItemMc);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_ITEM_USE_MING_KE_FU,EmbedRes.MouseSelectItemMc);
			mouseManager.registerMouseMode(MouseConstants.MOUSE_MODE_PET_APPOIN_SKILL,EmbedRes.MouseSelectItemMc);			
		}
		
		public function changeMouseMode(mouseMode:int):void {
			MouseManager.getInstance().currentMouseMode = mouseMode;
		}
	}
}