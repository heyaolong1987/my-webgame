package com.netease.core.view.map.scene{
	import com.netease.core.events.RouteTweenEvent;
	import com.netease.core.model.vo.map.moveobj.MoveObjVO;
	import com.netease.model.constants.MapConstants;
	import com.netease.view.map.moveobj.Char;
	import com.netease.view.map.moveobj.OtherPlayer;
	import com.netease.view.map.moveobj.Player;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import mx.containers.Grid;
	import mx.core.UIComponent;

	/**
	 * @author heyaolong
	 * 
	 * 2012-7-23
	 */ 
	public class SceneMap extends UIComponent{
		public var  charDic:Dictionary = new Dictionary();
		private var _player:Player;
		private var _landMoveLayer:Sprite;
		private var _npcLayer:Sprite;
		private var _transportLayer:Sprite;
		private var _cloudLayer:Sprite;
		private var _skyMoveLayer:Sprite;
		private var _landContainer:Sprite;
		private var _centerX:int; //中心点位置X
		private var _centerY:int; //中心点位置Y
		private var _mapWidth:int; //地图宽
		private var _mapHeight:int;//地图高
		private var _viewWidth:int; //可视区域宽度
		private var _viewHeight:int; //可视区域高度
		private var _objMapArr:Array;

		public function SceneMap(stage:Stage)
		{
			_landContainer = new Sprite();
			addChild(_landContainer);
			_landMoveLayer = new Sprite();
			_npcLayer = new Sprite();
			_transportLayer = new Sprite();
			_skyMoveLayer = new Sprite();
			_landContainer.addChild(_landMoveLayer);
			_landContainer.addChild(_npcLayer);
			_landContainer.addChild(_transportLayer);
			addChild(_skyMoveLayer);
			stage.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			
		}
		/**
		 *添加一个其他玩家 
		 * @param otherPlayerVO
		 * 
		 */
		public function addOtherPlayer(otherPlayer:OtherPlayer):void{
			charDic[otherPlayer.moveData.id] = otherPlayer;
			otherPlayer.x = Math.round(otherPlayer.moveData.x);
			otherPlayer.y = Math.round(otherPlayer.moveData.y);
			_landMoveLayer.addChild(otherPlayer);
			
		}
		/**
		 *移除一个玩家 
		 * @param id
		 * 
		 */
		public function removeOtherPlayer(id:int):void{
			var otherPlayer:OtherPlayer = charDic[id];
			if(otherPlayer){
				charDic[id] = null;
				otherPlayer.dispose();
			}
		}
		
		/**
		 *添加自己 
		 * @param player
		 * 
		 */
		public function addPlayer(player:Player):void{
			charDic[player.moveData.id] = player;
			player.x = Math.round(player.moveData.x);
			player.y = Math.round(player.moveData.y);
			_landMoveLayer.addChild(player);
			_player = player;
		}
		/**
		 *移除自己 
		 * 
		 */
		public function removePlayer():void{
			if(_player){
				charDic[_player.moveData.id] = null;
				_player.parent.removeChild(_player);
				_player = null;
			}
		}
		/**
		 *可视区域宽 
		 * @param value
		 * 
		 */
		public function set viewWidth(value:int):void{
			_viewWidth = value;
		}
		/**
		 *可视区域高 
		 * @param value
		 * 
		 */
		public function set viewHeight(value:int):void{
			_viewHeight = value;
		}
		private function adjuestCenterPos():void{
			_centerX = Math.round(_player.moveData.x);
			_centerY = Math.round(_player.moveData.y);
			var left:int = _viewWidth/2;
			var right:int = _mapWidth-_viewWidth/2;
			var top:int = _viewHeight/2;
			var bottom:int = _mapHeight-_viewHeight/2;
			if(_centerX<left){
				_centerX = left;
			}
			if(_centerX>right){
				_centerX = right;
			}
			if(_centerY<top){
				_centerY = top;
			}
			if(_centerY>bottom){
				_centerY = bottom;
			}
			onCenterPosChanged();
			
		}
		/**
		 *当中心点改变时
		 * @return 
		 * 
		 */
		private function onCenterPosChanged(){
			//移动地图容器位置
			_landContainer.x = -_centerX+_viewWidth/2;
			_landContainer.y = -_centerY+_viewHeight/2;
			//设置tileLayer中心点属性
		}
		private function onEnterFrame(event:Event):void{
			run();
		}
		public function run():void{
			var time:int = getTimer();
			for each(var char:Char in charDic){
				char.run();
				char.x = Math.round(char.moveData.x);
				char.y = Math.round(char.moveData.y);
				//trace(char.x,char.y,char.moveData.type);
			}
			adjuestCenterPos();
			trace(getTimer()-time);
			
		}
		
		/**
		 *切换场景
		 * @param mapId
		 * @param px
		 * @param py
		 * 
		 */
		public function changeScene(mapId:int, px:int, py:int):void{
			_objMapArr = [];
			var i:int,j:int;
			
		}
		
		/**
		 *进入地图 
		 * @param mapId
		 * @param px
		 * 
		 */
		public function enterMap(mapId:int, px:int,py:int):void{
			_mapWidth = 5000;
			_mapHeight = 5000;
			_viewWidth = 1000;
			_viewHeight = 600;
			
		}
		
	}
}