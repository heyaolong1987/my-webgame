package com.netease.core.view.map.scene{
	import com.netease.core.algorithm.astar.AStar;
	import com.netease.core.algorithm.astar.NavMeshAStar;
	import com.netease.core.component.layer.PreciseClickLayer;
	import com.netease.core.events.PreciseClickEvent;
	import com.netease.core.events.RouteTweenEvent;
	import com.netease.core.model.vo.map.moveobj.MoveObjVO;
	import com.netease.core.res.ByteLoader;
	import com.netease.core.res.ResLoader;
	import com.netease.core.view.map.layer.TileLayer;
	import com.netease.core.view.map.moveobj.MoveObj;
	import com.netease.model.constants.MapConstants;
	import com.netease.view.map.moveobj.Char;
	import com.netease.view.map.moveobj.OtherPlayer;
	import com.netease.view.map.moveobj.Player;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
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
		private var _preciseClickLayer:PreciseClickLayer;
		private var _wall:NavMeshWall;
		private var _player:Player;
		private var _tileLayer:TileLayer;
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
		public var tileWidth:int = 200;
		public var tileHeight:int = 120;
		private var _byteLoader:ByteLoader = new ByteLoader();
		
		public function SceneMap(stage:Stage)
		{
			_wall = new NavMeshWall();
			_preciseClickLayer = new PreciseClickLayer();
			addChild(_preciseClickLayer);
			_landContainer = new Sprite();
			_tileLayer = new TileLayer(tileWidth,tileHeight,5,5,1,loadTileFunc);
			_landMoveLayer = new Sprite();
			_npcLayer = new Sprite();
			_transportLayer = new Sprite();
			_skyMoveLayer = new Sprite();
			
			_landContainer.addChild(_landMoveLayer);
			_landContainer.addChild(_npcLayer);
			_landContainer.addChild(_transportLayer);
			
			_preciseClickLayer.addChild(_tileLayer);
			_preciseClickLayer.addChild(_landContainer);
			_preciseClickLayer.addChild(_skyMoveLayer);
			stage.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			
			//Mediator
			_preciseClickLayer.addEventListener(PreciseClickEvent.ITEM_CLICK,itemClick);
			_preciseClickLayer.addEventListener(PreciseClickEvent.ITEM_OVER,itemOver);
			_preciseClickLayer.addEventListener(PreciseClickEvent.ITEM_OUT,itemOut);
		}
		//Mediator start 
		private function itemClick(event:PreciseClickEvent):void{
			var item:InteractiveObject = event.item;
			var localX:int = event.localX;
			var localY:int = event.localY;
			if(item is TileLayer){
				var startPoint:Point = (item as TileLayer).startPoint;
				walkTo(localX+startPoint.x,localY+startPoint.y);
			}
			else if(item is OtherPlayer){
				
			}
			else if(item is Player){
				
			}
			
		}
		private function itemOver(event:PreciseClickEvent):void{
			
		}
		private function itemOut(event:PreciseClickEvent):void{
			
		}
		private function walkTo(ex:int,ey:int):void{
			var path:Array = NavMeshAStar.find(_wall.nodeList,_player.moveData.x,_player.moveData.y,ex,ey);
			if(path){
				_player.moveData.route = path;
			}
		}
		//Mediator  end
		
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
			_tileLayer.startPoint = new Point(_centerX-_viewWidth/2,_centerY-_viewHeight/2);
			//设置tileLayer中心点属性
		}
		private function onEnterFrame(event:Event):void{
			run();
		}
		public function run():void{
			for each(var char:Char in charDic){
				char.run();
				char.x = Math.round(char.moveData.x);
				char.y = Math.round(char.moveData.y);
				//trace(char.x,char.y,char.moveData.type);
			}
			adjuestCenterPos();
			
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
		public function enterMap(mapId:int, px:int,py:int):void{
			_objMapArr = [];
			_mapWidth = 5000;
			_mapHeight = 5000;
			_viewWidth = 1000;
			_viewHeight = 600;
			_byteLoader.load("../res/stage/map/1001/triangle.dat",onWallLoadComplete);
			
		}
		private function onWallLoadComplete(byte:ByteArray,args:Array):void{
			_wall.setData(byte);
		}
		private function loadTileFunc(row:int,col:int,loadFinishFunc:Function):void{
			ResLoader.getInstance().load("../res/stage/map/1001/"+row+"/"+col+".jpg",onLoadTileFinished,[row,col,loadFinishFunc],true);
		}
		private function onLoadTileFinished(bmp:Bitmap,args:Array){
			(args[2] as Function).apply(null,[args[0],args[1],bmp]);
		}
	}
}