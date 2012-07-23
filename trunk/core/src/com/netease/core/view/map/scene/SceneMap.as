package com.netease.core.view.map.scene{
	import com.netease.core.events.RouteTweenEvent;
	import com.netease.core.model.vo.map.moveobj.MoveObjVO;
	import com.netease.model.constants.MapConstants;
	import com.netease.view.map.moveobj.OtherPlayer;
	import com.netease.view.map.moveobj.Player;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;

	/**
	 * @author heyaolong
	 * 
	 * 2012-7-23
	 */ 
	public class SceneMap extends UIComponent{
		
		private var _charDic:Dictionary = new Dictionary();
		private var _player:Player;
		private var _landMoveLayer:Sprite;
		private var _npcLayer:Sprite;
		private var _transportLayer:Sprite;
		private var _cloudLayer:Sprite;
		private var _skyMoveLayer:Sprite;
		public function SceneMap()
		{
			_landMoveLayer = new Sprite();
			_npcLayer = new Sprite();
			_transportLayer = new Sprite();
			_skyMoveLayer = new Sprite();
			addChild(_landMoveLayer);
			addChild(_npcLayer);
			addChild(_transportLayer);
			addChild(_skyMoveLayer);
		}
		/**
		 *添加一个其他玩家 
		 * @param otherPlayerVO
		 * 
		 */
		public function addOtherPlayer(otherPlayer:OtherPlayer):void{
			_landMoveLayer.addChild(otherPlayer);
			_charDic[otherPlayer.moveData.id] = otherPlayer;
			otherPlayer.moveData.movingTween.addEventListener(RouteTweenEvent.POS_UPDATE,onPosUpdate);
		}
		/**
		 *移除一个玩家 
		 * @param id
		 * 
		 */
		public function removeOtherPlayer(id:int):void{
			var otherPlayer:OtherPlayer = _charDic[id];
			if(otherPlayer){
				otherPlayer.moveData.movingTween.removeEventListener(RouteTweenEvent.POS_UPDATE,onPosUpdate);
				otherPlayer.parent.removeChild(otherPlayer);
				_charDic[id] = null;
				otherPlayer.dispose();
				
			}
		}
		
		
		/**
		 *添加自己 
		 * @param player
		 * 
		 */
		public function addPlayer(player:Player):void{
			_landMoveLayer.addChild(player);
			_player = player;
			_player.moveData.movingTween.addEventListener(RouteTweenEvent.POS_UPDATE,onPosUpdate);
		}
		/**
		 *移除自己 
		 * 
		 */
		public function removePlayer():void{
			if(_player){
				_player.moveData.movingTween.removeEventListener(RouteTweenEvent.POS_UPDATE,onPosUpdate);
				_charDic[_player.moveData.id] = null;
				_player.parent.removeChild(_player);
				_player = null;
			}
		}
		
		/**
		 *切换场景 
		 * @param mapId
		 * @param px
		 * @param py
		 * 
		 */
		public function changeScene(mapId:int, px:int, py:int):void{
			
		}
		
		/**
		 *进入地图 
		 * @param mapId
		 * @param px
		 * 
		 */
		public function enterMap(mapId:int, px:int):void{
			
		}
		/**
		 *当位置改变时 
		 * @param event
		 * 
		 */
		private function onPosUpdate(event:RouteTweenEvent):void{
			var moveData:MoveObjVO = event.data.container as MoveObjVO;
			moveData.x = event.data.x;
			moveData.y = event.data.y;
			moveData.dir = event.data.direction;
			switch(moveData.type){
				case MapConstants.MOVE_OBJ_TYPE_CHAR:
					break;
				case MapConstants.MOVE_OBJ_TYPE_OTHER_PLAYER:
					var otherPlayer:OtherPlayer = _charDic[moveData.id];
					if(otherPlayer){
						otherPlayer.x = moveData.x;
						otherPlayer.y = moveData.y;
					}
					break;
				case MapConstants.MOVE_OBJ_TYPE_PLAYER:
					break;
			}
			
		}
	}
}