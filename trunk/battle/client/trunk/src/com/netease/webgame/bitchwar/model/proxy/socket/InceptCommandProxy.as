package com.netease.webgame.bitchwar.model.proxy.socket
{
	import com.netease.webgame.bitchwar.InceptCommandConstants;
	import com.netease.webgame.bitchwar.model.proxy.baseclass.BaseProxy;
	import com.netease.webgame.bitchwar.model.vo.fight.FightStartVO;
	import com.netease.webgame.bitchwar.model.vo.fight.FightUserOperateVO;
	import com.netease.webgame.bitchwar.model.vo.fight.FighterVO;

	public class InceptCommandProxy extends BaseProxy
	{
		public static const NAME:String = "BACK_COMMAND_PROXY";
		public function InceptCommandProxy()
		{
			super(NAME);
		}
		public function call(backCommandName:String,body:Object):void{
			sendNotification(backCommandName,body);
		}
		public function startFight():void{
			var fightStartVO:FightStartVO = new FightStartVO();
			fightStartVO.fighters = [];
			var fighters:Array = fightStartVO.fighters;
			for(var i:int=0; i<2; i++){
				fighters.push([]);
				for(var j:int=0; j<5; j++){
					var fighterVO:FighterVO = new FighterVO();
					fighterVO.id = i*5+j;
					fighterVO.name = "第" +(i+1).toString() +"排"+"第"+(j+1).toString()+"行"+"怪物";
					fighterVO.resName = fighterVO.name;
					fighters[i].push(fighterVO);
				}
			}
			call(InceptCommandConstants.START_FIGHT,fightStartVO);
		}
		
		public function inceptFightUserOpearte(userOperate:FightUserOperateVO):void{
			
		}
		
	}
}