package com.netease.manager{
	import com.netease.core.events.RouteTweenEvent;
	import com.netease.core.map.moveobj.MoveObjVO;
	import com.netease.flash.common.log.Console;
	import com.netease.model.constants.MapConstants;
	import com.netease.view.map.moveobj.Char;
	import com.netease.view.map.moveobj.OtherPlayer;
	import com.netease.view.map.moveobj.Player;
	
	import flash.utils.Dictionary;

	/**
	 * @author heyaolong
	 * 
	 * 2012-5-23
	 */ 
	public class MoveManager{
		public var charList:Dictionary = new Dictionary();
		public var play:MoveObjVO;
		private static var _instance:MoveManager;
		public function MoveManager()
		{
		}
		public static function getInstance():MoveManager{
			if(_instance == null){
				_instance = new MoveManager();
			}
			return _instance;
		}
		public function addPlayer(player:Player):void{
			
		}
		public function addOtherPalyer(otherPlayer:OtherPlayer):void{
			charList[otherPlayer.moveData.id] = otherPlayer;
			otherPlayer.moveData.route.addEventListener(RouteTweenEvent.ROUTE_UPDATE,onRouteUpdate);
		}
		private function onRouteUpdate(event:RouteTweenEvent):void{
			var moveData:MoveObjVO = event.data.container as MoveObjVO;
			switch(moveData.type){
				case MapConstants.MOVE_OBJ_TYPE_CHAR:
					break;
				case MapConstants.MOVE_OBJ_TYPE_OTHER_PLAYER:
					moveData.x = event.data.x;
					moveData.y = event.data.y;
					if(moveData.container){
						//trace(moveData.x,moveData.y,moveData.x - moveData.container.x,moveData.y - moveData.container.y);
						moveData.container.x = moveData.x;
						moveData.container.y = moveData.y;
					}
					break;
				case MapConstants.MOVE_OBJ_TYPE_PLAYER:
					break;
			}
			
		}
		public function removeOtherPlayer(id:int):void{
			charList[id] = null;
		}
	}
}