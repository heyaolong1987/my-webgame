package test {
	import com.netease.webgame.bitchwar.config.BuffConfig;
	import com.netease.webgame.bitchwar.config.constants.BuffConstants;
	import com.netease.webgame.bitchwar.config.constants.FightConstants;
	import com.netease.webgame.bitchwar.config.constants.ProfileConstants;
	import com.netease.webgame.bitchwar.model.Model;
	import com.netease.webgame.bitchwar.model.proxy.FightProxy;
	import com.netease.webgame.bitchwar.model.vo.fight.FightEndVO;
	import com.netease.webgame.bitchwar.model.vo.fight.FightRoundStartVO;
	import com.netease.webgame.bitchwar.model.vo.fight.FightRoundVO;
	import com.netease.webgame.bitchwar.model.vo.fight.FightStartVO;
	import com.netease.webgame.bitchwar.model.vo.fight.FighterVO;
	import com.netease.webgame.bitchwar.model.vo.fight.action.*;
	import com.netease.webgame.bitchwar.model.vo.fight.event.*;
	import com.netease.webgame.bitchwar.model.vo.item.UserItemVO;
	import com.netease.webgame.bitchwar.model.vo.pet.PetVO;
	import com.netease.webgame.bitchwar.model.vo.skill.FightBuffVO;
	
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	
	
	public class FightTestCase {
		
		public function FightTestCase(){
			
		}
		
		private static var testActions:Array;
		
		public static function test(proxy:FightProxy, roundIndex:int):void {
			var fightStart:FightStartVO = new FightStartVO();
				fightStart.fightId = 1;
				fightStart.firstSideFighters = new ArrayCollection(
					[	generateFighter(1, 7),
						generateFighter(2, 2),
						generateFighter(3, 3),
						generateFighter(4, 4),
						generateFighter(5, 5),
						generateFighter(11, 6),
						generateFighter(12, 1),
						generateFighter(13, 8),
						generateFighter(14, 9),
						generateFighter(15, 10)	] );
				fightStart.secondSideFighters =	new ArrayCollection(
					[	generateFighter(6, 3),
						generateFighter(7, 2),
						generateFighter(8, 9),
						generateFighter(9, 4),
						generateFighter(10, 8),
						generateFighter(16, 1),
						generateFighter(17, 5),
						generateFighter(18, 7),
						generateFighter(19, 6),
						generateFighter(20, 10)	] );
			if(roundIndex<=0) {
				proxy.startFight(fightStart);
				setTimeout(initFightRound, 5000, fightStart, proxy);
			} else {
				
			}
		}
		
		private static function initFightRound(fightStart:FightStartVO, proxy:FightProxy):void {
			var fight:FightRoundVO;
			var roundIndex:int = 1;
			var fightEnd:FightEndVO;
			var fightRoundStart:FightRoundStartVO;
			fight = getRoundActions(fightStart);
			while(fight!=null) {
				fightRoundStart = new FightRoundStartVO();
				fightRoundStart.fightId = 1;
				fightRoundStart.roundIndex = roundIndex;
				proxy.initRound(fightRoundStart);
				roundIndex++;
				proxy.setFightRound(fight);
				fight = getRoundActions(fightStart);
			}
			fightEnd = new FightEndVO();
			fightEnd.fightId = 1;
			proxy.endFight(fightEnd);
		}
		
		private static function getRoundActions(fightStart:FightStartVO):FightRoundVO {
			if(testActions==null) {
				generateRoundList(fightStart);
			}
			if(testActions.length>0) {
				return testActions.shift();
			}
			testActions = null;
			return null;
		}
		
		private static function generateRoundList(fightStart:FightStartVO):void {
			testActions = [];
			var i:int;
			for(i=0; i<1; i++) {
				testActions.push(generateFightRound(i+1, fightStart));
			}
		}
		
		private static function generateFighter(userId:Object, index:int):FighterVO {
			var fighter:FighterVO = new FighterVO();
			var nameList:Array = ["核心纯洁","堕落中的舒","有裂痕的BE","有裂痕的zhp","有裂痕的王翔","有裂痕的少侠","有裂痕的李杭","破碎的影子","破碎的农民","破碎的灰灰","破碎的宝明","破碎的宝头","破碎的光环","破碎的肉松"];
			if(Model.getInstance().hero.id<21) {
				if(userId==Model.getInstance().hero.id) {
					fighter.fighterId = Model.getInstance().hero.id+"#"+FightConstants.PLAYER_TERRAN;
				} else {
					fighter.fighterId = userId + "#" + FightConstants.PLAYER_TERRAN;
				}
			} else {
				if(userId==1) {
					fighter.fighterId = Model.getInstance().hero.id+"#"+FightConstants.PLAYER_TERRAN;
				} else {
					fighter.fighterId = userId + "#" + FightConstants.PLAYER_TERRAN;
				}
			}
			fighter.fighterName = nameList[Math.floor(Math.random()*nameList.length)];
			fighter.gender = ProfileConstants.MALE;
			fighter.clan = 1;
			fighter.hp = 1000;
			fighter.maxHp = 1000;
			fighter.mp = 800;
			fighter.maxMp = 1000;
			fighter.buffList = new ArrayCollection();
			fighter.teamIndex = index;
			fighter.type = FightConstants.PLAYER_TERRAN;
			return fighter;
		}
		
		private static function getFighterId(fightStart:FightStartVO, id:int):String {
			var list:ArrayCollection = new ArrayCollection();
				list.addAll(fightStart.firstSideFighters);
				list.addAll(fightStart.secondSideFighters);
			var i:int;
			var fighter:FighterVO;
			for(i=0; i<list.length; i++) {
				fighter = list[i];
				if(fighter.fighterId.substr(0, fighter.fighterId.indexOf("#"))==String(id)) {
					return fighter.fighterId;
				}
			}
			return Model.getInstance().hero.id + "#" + FightConstants.PLAYER_TERRAN;
		}
		
		private static function getBuffId():Number {
			return 1;
		}
		
		private static function getBuffTemplateId():Number {
			var buffs:Array = [100101, 100201, 100301, 100401, 100501, 100601, 100701, 100801];
			return buffs[Math.floor(Math.random()*buffs.length)];
		}
		
		private static function getBuffEffectType():void {
			var bufftypes:Array = [	BuffConstants.FIGHT_EFFECT_TYPE_ANGER,
									BuffConstants.FIGHT_EFFECT_TYPE_CHAOS,
									BuffConstants.FIGHT_EFFECT_TYPE_DIZZY,
									BuffConstants.FIGHT_EFFECT_TYPE_FROZEN,
									BuffConstants.FIGHT_EFFECT_TYPE_HURT,
									BuffConstants.FIGHT_EFFECT_TYPE_POISON,
									BuffConstants.FIGHT_EFFECT_TYPE_SEAL,
									BuffConstants.FIGHT_EFFECT_TYPE_SLEEP,
									BuffConstants.FIGHT_EFFECT_TYPE_VERRADEN	];
			BuffConfig.getInstance().getBuffTemplateById(100101).animationType = bufftypes[0];
			BuffConfig.getInstance().getBuffTemplateById(100201).animationType = bufftypes[1];
			BuffConfig.getInstance().getBuffTemplateById(100301).animationType = bufftypes[2];
			BuffConfig.getInstance().getBuffTemplateById(100401).animationType = bufftypes[3];
			BuffConfig.getInstance().getBuffTemplateById(100501).animationType = bufftypes[4];
			BuffConfig.getInstance().getBuffTemplateById(100601).animationType = bufftypes[5];
			BuffConfig.getInstance().getBuffTemplateById(100701).animationType = bufftypes[6];
			BuffConfig.getInstance().getBuffTemplateById(100801).animationType = bufftypes[7];
			BuffConfig.getInstance().getBuffTemplateById(100102).animationType = bufftypes[8];
		}
		
		private static function generateFightRound(roundIndex:int, fightStart:FightStartVO):FightRoundVO {
			getBuffEffectType();
			var actions:Array;
			var round:FightRoundVO;
			var actionAttack:ActionAttackVO;
			var actionRevival:ActionRevivalVO;
			var actionUseItem:ActionUseItemVO;
			var actionUseSkill:ActionUseSkillVO;
			var actionEscape:ActionEscapeVO;
			var actionDefend:ActionDefendVO;
			
			var action:FightActionVO;
			var attack:FightAttackVO;
			var miss:FightMissVO;
			var protect:FightProtectVO;
			var changeHp:FightChangeHpVO;
			var changeMp:FightChangeMpVO;
			var useItem:FightUseItemVO;
			var useSkill:FightUseSkillVO;
			var revival:FightRevivalVO;
			var escape:FightEscapeVO;
			var fightcatch:FightCatchVO;
			var addBuff:FightAddBuffVO;
			var removeBuff:FightRemoveBuffVO;
			
			round = new FightRoundVO();
			round.actionList = [];
			
			actionAttack = new ActionAttackVO();
			actionAttack.eventList = new ArrayCollection();
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,1);
			actionAttack.eventList.addItem(action);
			fightcatch = new FightCatchVO();
			fightcatch.objectId = getFighterId(fightStart, 1);
			fightcatch.targetObjectId = getFighterId(fightStart, 16);
			fightcatch.pet = new UserItemVO();
			fightcatch.pet.instance = new PetVO();
			fightcatch.success = true;
			actionAttack.eventList.addItem(fightcatch);
			addBuff = new FightAddBuffVO();
			addBuff.objectId = getFighterId(fightStart, 1);
			addBuff.fightBuff = new FightBuffVO();
			addBuff.fightBuff.id = getBuffId();
			addBuff.fightBuff.releaserId = getFighterId(fightStart, 1);
			addBuff.fightBuff.buffTemplateId = getBuffTemplateId();
			actionAttack.eventList.addItem(addBuff);
			round.actionList.push(actionAttack);
			
			actionAttack = new ActionAttackVO();
			actionAttack.eventList = new ArrayCollection();
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,6);
			actionAttack.eventList.addItem(action);
			fightcatch = new FightCatchVO();
			fightcatch.objectId = getFighterId(fightStart, 6);
			fightcatch.targetObjectId = getFighterId(fightStart, 11);
			fightcatch.pet = new UserItemVO();
			fightcatch.pet.instance = new PetVO();
			fightcatch.success = true;
			actionAttack.eventList.addItem(fightcatch);
			addBuff = new FightAddBuffVO();
			addBuff.objectId = getFighterId(fightStart, 1);
			addBuff.fightBuff = new FightBuffVO();
			addBuff.fightBuff.id = getBuffId();
			addBuff.fightBuff.releaserId = getFighterId(fightStart, 6);
			addBuff.fightBuff.buffTemplateId = getBuffTemplateId();
			actionAttack.eventList.addItem(addBuff);
			round.actionList.push(actionAttack);
			
			actionAttack = new ActionAttackVO();
			actionAttack.eventList = new ArrayCollection();
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,1);
			actionAttack.eventList.addItem(action);
			fightcatch = new FightCatchVO();
			fightcatch.objectId = getFighterId(fightStart, 1);
			fightcatch.targetObjectId = getFighterId(fightStart, 19);
			fightcatch.success = false;
			actionAttack.eventList.addItem(fightcatch);
			addBuff = new FightAddBuffVO();
			addBuff.objectId = getFighterId(fightStart, 1);
			addBuff.fightBuff = new FightBuffVO();
			addBuff.fightBuff.id = getBuffId();
			addBuff.fightBuff.releaserId = getFighterId(fightStart, 1);
			addBuff.fightBuff.buffTemplateId = getBuffTemplateId();
			actionAttack.eventList.addItem(addBuff);
			round.actionList.push(actionAttack);
			
			actionAttack = new ActionAttackVO();
			actionAttack.eventList = new ArrayCollection();
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,7);
			actionAttack.eventList.addItem(action);
			fightcatch = new FightCatchVO();
			fightcatch.objectId = getFighterId(fightStart, 7);
			fightcatch.targetObjectId = getFighterId(fightStart, 1);
			fightcatch.pet = new UserItemVO();
			fightcatch.pet.instance = new PetVO();
			fightcatch.success = false;
			actionAttack.eventList.addItem(fightcatch);
			addBuff = new FightAddBuffVO();
			addBuff.objectId = getFighterId(fightStart, 1);
			addBuff.fightBuff = new FightBuffVO();
			addBuff.fightBuff.id = getBuffId();
			addBuff.fightBuff.releaserId = getFighterId(fightStart, 7);
			addBuff.fightBuff.buffTemplateId = getBuffTemplateId();
			actionAttack.eventList.addItem(addBuff);
			round.actionList.push(actionAttack);
			
			actionEscape = new ActionEscapeVO();
			actionEscape.eventList = new ArrayCollection();
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,13);
			actionEscape.eventList.addItem(action);
			escape = new FightEscapeVO();
			escape.objectId = getFighterId(fightStart,13);
			escape.success = false;
			actionEscape.eventList.addItem(escape);
			removeBuff = new FightRemoveBuffVO();
			removeBuff.objectId = getFighterId(fightStart, 1);
			removeBuff.fightBuff = addBuff.fightBuff;
			actionEscape.eventList.addItem(removeBuff);
			round.actionList.push(actionEscape);
			
			actionEscape = new ActionEscapeVO();
			actionEscape.eventList = new ArrayCollection();
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,13);
			actionEscape.eventList.addItem(action);
			escape = new FightEscapeVO();
			escape.objectId = getFighterId(fightStart,13);
			escape.success = true;
			actionEscape.eventList.addItem(escape);
			round.actionList.push(actionEscape);
			
			actionEscape = new ActionEscapeVO();
			actionEscape.eventList = new ArrayCollection();
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,20);
			actionEscape.eventList.addItem(action);
			escape = new FightEscapeVO();
			escape.objectId = getFighterId(fightStart,20);
			escape.success = false;
			actionEscape.eventList.addItem(escape);
			round.actionList.push(actionEscape);
			
			actionEscape = new ActionEscapeVO();
			actionEscape.eventList = new ArrayCollection();
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,20);
			actionEscape.eventList.addItem(action);
			escape = new FightEscapeVO();
			escape.objectId = getFighterId(fightStart,20);
			escape.success = true;
			actionEscape.eventList.addItem(escape);
			round.actionList.push(actionEscape);
			
			actionAttack = new ActionAttackVO();
			actionAttack.eventList = new ArrayCollection();
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,1);
			actionAttack.eventList.addItem(action);
			attack = new FightAttackVO();
			attack.objectId = getFighterId(fightStart,1);
			attack.targetObjectIdList = new ArrayCollection([getFighterId(fightStart,6),getFighterId(fightStart,7),getFighterId(fightStart,8)]);
			attack.ca = false;
			actionAttack.eventList.addItem(attack);
			changeHp = new FightChangeHpVO();
			changeHp.objectId = getFighterId(fightStart,8);
			changeHp.value = -100;
			actionAttack.eventList.addItem(changeHp);
			changeHp = new FightChangeHpVO();
			changeHp.objectId = getFighterId(fightStart,6);
			changeHp.value = -100;
			actionAttack.eventList.addItem(changeHp);
			miss = new FightMissVO();
			miss.objectId = getFighterId(fightStart,7);
			actionAttack.eventList.addItem(miss);
			changeMp = new FightChangeMpVO();
			changeMp.objectId = getFighterId(fightStart,1);
			changeMp.value = -100;
			actionAttack.eventList.addItem(changeMp);
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,6);
			actionAttack.eventList.addItem(action);
			attack = new FightAttackVO();
			attack.objectId = getFighterId(fightStart,6);
			attack.targetObjectIdList = new ArrayCollection([getFighterId(fightStart,1)]);
			attack.ca = true;
			actionAttack.eventList.addItem(attack);
			changeHp = new FightChangeHpVO();
			changeHp.objectId = getFighterId(fightStart,1);
			changeHp.value = -100;
			actionAttack.eventList.addItem(changeHp);
			round.actionList.push(actionAttack);
			
			actionAttack = new ActionAttackVO();
			actionAttack.eventList = new ArrayCollection();
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,6);
			actionAttack.eventList.addItem(action);
			protect = new FightProtectVO();
			protect.objectId = getFighterId(fightStart,2);
			protect.targetObjectId = getFighterId(fightStart,1);
			actionAttack.eventList.addItem(protect);
			attack = new FightAttackVO();
			attack.objectId = getFighterId(fightStart,6);
			attack.targetObjectIdList = new ArrayCollection([getFighterId(fightStart,2)]);
			actionAttack.eventList.addItem(attack);
			miss = new FightMissVO();
			miss.objectId = getFighterId(fightStart,2);
			actionAttack.eventList.addItem(miss);
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,2);
			actionAttack.eventList.addItem(action);
			attack = new FightAttackVO();
			attack.objectId = getFighterId(fightStart,2);
			attack.targetObjectIdList = new ArrayCollection([getFighterId(fightStart,6)]);
			attack.ca = false;
			actionAttack.eventList.addItem(attack);
			changeHp = new FightChangeHpVO();
			changeHp.objectId = getFighterId(fightStart,6);
			changeHp.value = -100;
			actionAttack.eventList.addItem(changeHp);
			round.actionList.push(actionAttack);
			
			actionDefend = new ActionDefendVO();
			actionDefend.objectId = getFighterId(fightStart,7);
			round.actionList.push(actionDefend);
			
			actionAttack = new ActionAttackVO();
			actionAttack.eventList = new ArrayCollection();
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,8);
			actionAttack.eventList.addItem(action);
			protect = new FightProtectVO();
			protect.objectId = getFighterId(fightStart,4);
			protect.targetObjectId = getFighterId(fightStart,1);
			actionAttack.eventList.addItem(protect);
			attack = new FightAttackVO();
			attack.objectId = getFighterId(fightStart,8);
			attack.targetObjectIdList = new ArrayCollection([getFighterId(fightStart,4)]);
			attack.ca = false;
			actionAttack.eventList.addItem(attack);
			changeHp = new FightChangeHpVO();
			changeHp.objectId = getFighterId(fightStart,4);
			changeHp.value = -100;
			actionAttack.eventList.addItem(changeHp);
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,4);
			actionAttack.eventList.addItem(action);
			attack = new FightAttackVO();
			attack.objectId = getFighterId(fightStart,4);
			attack.targetObjectIdList = new ArrayCollection([getFighterId(fightStart,8), getFighterId(fightStart,6)]);
			attack.ca = true;
			actionAttack.eventList.addItem(attack);
			changeHp = new FightChangeHpVO();
			changeHp.objectId = getFighterId(fightStart,6);
			changeHp.value = -1200;
			actionAttack.eventList.addItem(changeHp);
			changeHp = new FightChangeHpVO();
			changeHp.objectId = getFighterId(fightStart,8);
			changeHp.value = -100;
			actionAttack.eventList.addItem(changeHp);
			round.actionList.push(actionAttack);
			
			actionAttack = new ActionAttackVO();
			actionAttack.eventList = new ArrayCollection();
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,9);
			actionAttack.eventList.addItem(action);
			protect = new FightProtectVO();
			protect.objectId = getFighterId(fightStart,4);
			protect.targetObjectId = getFighterId(fightStart,1);
			actionAttack.eventList.addItem(protect);
			attack = new FightAttackVO();
			attack.objectId = getFighterId(fightStart,9);
			attack.targetObjectIdList = new ArrayCollection([getFighterId(fightStart,4)]);
			attack.ca = false;
			actionAttack.eventList.addItem(attack);
			changeHp = new FightChangeHpVO();
			changeHp.objectId = getFighterId(fightStart,4);
			changeHp.value = -100;
			actionAttack.eventList.addItem(changeHp);
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,4);
			actionAttack.eventList.addItem(action);
			attack = new FightAttackVO();
			attack.objectId = getFighterId(fightStart,4);
			attack.targetObjectIdList = new ArrayCollection([getFighterId(fightStart,9), getFighterId(fightStart,6)]);
			attack.ca = true;
			actionAttack.eventList.addItem(attack);
			changeHp = new FightChangeHpVO();
			changeHp.objectId = getFighterId(fightStart,6);
			changeHp.value = -1200;
			actionAttack.eventList.addItem(changeHp);
			miss = new FightMissVO();
			miss.objectId = getFighterId(fightStart,9);
			actionAttack.eventList.addItem(miss);
			round.actionList.push(actionAttack);
			
			actionAttack = new ActionAttackVO();
			actionAttack.eventList = new ArrayCollection();
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,6);
			actionAttack.eventList.addItem(action);
			protect = new FightProtectVO();
			protect.objectId = getFighterId(fightStart,4);
			protect.targetObjectId = getFighterId(fightStart,1);
			actionAttack.eventList.addItem(protect);
			attack = new FightAttackVO();
			attack.objectId = getFighterId(fightStart,6);
			attack.targetObjectIdList = new ArrayCollection([getFighterId(fightStart,4)]);
			attack.ca = false;
			actionAttack.eventList.addItem(attack);
			changeHp = new FightChangeHpVO();
			changeHp.objectId = getFighterId(fightStart,4);
			changeHp.value = -100;
			actionAttack.eventList.addItem(changeHp);
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,4);
			actionAttack.eventList.addItem(action);
			protect = new FightProtectVO();
			protect.objectId = getFighterId(fightStart, 8);
			protect.targetObjectId = getFighterId(fightStart, 6);
			actionAttack.eventList.addItem(protect);
			protect = new FightProtectVO();
			protect.objectId = getFighterId(fightStart, 9);
			protect.targetObjectId = getFighterId(fightStart, 10);
			actionAttack.eventList.addItem(protect);
			attack = new FightAttackVO();
			attack.objectId = getFighterId(fightStart,4);
			attack.targetObjectIdList = new ArrayCollection([getFighterId(fightStart,8), getFighterId(fightStart,9)]);
			attack.ca = true;
			actionAttack.eventList.addItem(attack);
			changeHp = new FightChangeHpVO();
			changeHp.cr = true;
			changeHp.value = -1200;
			changeHp.objectId = getFighterId(fightStart, 8);
			actionAttack.eventList.addItem(changeHp);
			changeHp = new FightChangeHpVO();
			changeHp.cr = true;
			changeHp.value = -1200;
			changeHp.objectId = getFighterId(fightStart, 9);
			actionAttack.eventList.addItem(changeHp);
			changeMp = new FightChangeMpVO();
			changeMp.value = -100;
			changeMp.objectId = getFighterId(fightStart, 4);
			changeMp.active = true;
			actionAttack.eventList.addItem(changeMp);
			round.actionList.push(actionAttack);
			
			actionUseItem = new ActionUseItemVO();
			actionUseItem.eventList = new ArrayCollection();
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,2);
			actionUseItem.eventList.addItem(action);
			useItem = new FightUseItemVO();
			useItem.objectId = getFighterId(fightStart,2);
			useItem.targetObjectIdList = new ArrayCollection([getFighterId(fightStart,2)]);
			useItem.itemId = 21201;
			useItem.itemTemplateId = 21201;
			actionUseItem.eventList.addItem(useItem);
			changeHp = new FightChangeHpVO();
			changeHp.objectId = getFighterId(fightStart,2);
			changeHp.value = 100;
			actionUseItem.eventList.addItem(changeHp);
			round.actionList.push(actionUseItem);
			
			actionAttack = new ActionAttackVO();
			actionAttack.eventList = new ArrayCollection();
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,3);
			actionAttack.eventList.addItem(action);
			attack = new FightAttackVO();
			attack.objectId = getFighterId(fightStart,3);
			attack.targetObjectIdList = new ArrayCollection([getFighterId(fightStart,6)]);
			attack.ca = false;
			actionAttack.eventList.addItem(attack);
			changeHp = new FightChangeHpVO();
			changeHp.objectId = getFighterId(fightStart,6);
			changeHp.value = -100;
			actionAttack.eventList.addItem(changeHp);
			round.actionList.push(actionAttack);
			
			actionUseItem = new ActionUseItemVO();
			actionUseItem.eventList = new ArrayCollection();
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,6);
			actionAttack.eventList.addItem(action);
			useItem = new FightUseItemVO();
			useItem.objectId = getFighterId(fightStart,6);
			useItem.itemId = 21201;
			useItem.itemTemplateId = 21201;
			useItem.targetObjectIdList = new ArrayCollection([getFighterId(fightStart,7)]);
			actionUseItem.eventList.addItem(useItem);
			revival = new FightRevivalVO();
			revival.objectId = getFighterId(fightStart,7);
			actionUseItem.eventList.addItem(revival);
			round.actionList.push(actionUseItem);
			changeHp = new FightChangeHpVO();
			changeHp.objectId = getFighterId(fightStart,7);
			changeHp.value = 100;
			actionAttack.eventList.addItem(changeHp);

			actionUseSkill = new ActionUseSkillVO();
			actionUseSkill.eventList = new ArrayCollection();
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,8);
			actionUseSkill.eventList.addItem(action);
			useSkill = new FightUseSkillVO();
			useSkill.skillTemplateId = 110101;
			useSkill.objectId = getFighterId(fightStart,8);
			useSkill.targetObjectIdList = new ArrayCollection([getFighterId(fightStart,2), getFighterId(fightStart,4)]);
			actionUseSkill.eventList.addItem(useSkill);
			changeHp = new FightChangeHpVO();
			changeHp.objectId = getFighterId(fightStart,2);
			changeHp.value = -100;
			changeHp.cr = true;
			actionUseSkill.eventList.addItem(changeHp);
			round.actionList.push(actionUseSkill);
			
			actionUseSkill = new ActionUseSkillVO();
			actionUseSkill.eventList = new ArrayCollection();
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,4);
			actionUseSkill.eventList.addItem(action);
			useSkill = new FightUseSkillVO();
			useSkill.objectId = getFighterId(fightStart,4);
			useSkill.skillTemplateId = 110101;
			useSkill.targetObjectIdList = new ArrayCollection([getFighterId(fightStart,6)]);
			actionUseSkill.eventList.addItem(useSkill);
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,6);
			actionUseSkill.eventList.addItem(action);
			attack = new FightAttackVO();
			attack.objectId = getFighterId(fightStart,6);
			attack.targetObjectIdList = new ArrayCollection([getFighterId(fightStart,4)]);
			attack.ca = true;
			actionUseSkill.eventList.addItem(attack);
			miss = new FightMissVO();
			miss.objectId = getFighterId(fightStart,4);
			actionUseSkill.eventList.addItem(miss);
			round.actionList.push(actionUseSkill);
			
			actionUseSkill = new ActionUseSkillVO();
			actionUseSkill.eventList = new ArrayCollection();
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,1);
			actionUseSkill.eventList.addItem(action);
			useSkill = new FightUseSkillVO();
			useSkill.objectId = getFighterId(fightStart,1);
			useSkill.skillTemplateId = 110101;
			useSkill.targetObjectIdList = new ArrayCollection([getFighterId(fightStart,6)]);
			actionUseSkill.eventList.addItem(useSkill);
			action = new FightActionVO();
			action.objectId = getFighterId(fightStart,6);
			actionUseSkill.eventList.addItem(action);
			attack = new FightAttackVO();
			attack.objectId = getFighterId(fightStart,6);
			attack.targetObjectIdList = new ArrayCollection([getFighterId(fightStart,1)]);
			attack.ca = true;
			actionUseSkill.eventList.addItem(attack);
			miss = new FightMissVO();
			miss.objectId = getFighterId(fightStart,1);
			actionUseSkill.eventList.addItem(miss);
			round.actionList.push(actionUseSkill);
			
			round.fightId = 1;
			round.roundIndex = roundIndex;
			return round;
		}
		
	}
}