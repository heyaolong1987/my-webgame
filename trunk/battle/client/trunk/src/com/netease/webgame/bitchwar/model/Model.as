package com.netease.webgame.bitchwar.model
{
	import com.netease.webgame.bitchwar.model.vo.charactor.AccountVO;
	import com.netease.webgame.bitchwar.model.vo.fight.FightViewVO;
	import com.netease.webgame.bitchwar.net.InceptPacketProgresser;
	import com.netease.webgame.core.net.NetEngine;

	public class Model
	{
		private static var _instance:Model;
		/**
		 *登陆或游戏视图 
		 */
		public var applicationView:String;
		
		/**
		 * 场景，战斗等视图
		 */
		public var gameView:String; 
		
		/**
		 *网络连接 
		 */
		public var net:NetEngine;
		/**
		 *玩家自身数据 
		 */
		public var playerVO:AccountVO;
		/**
		 *战场数据 
		 */
		public var fightViewVO:FightViewVO;
		
		public function Model()
		{
			net = new NetEngine(InceptPacketProgresser.getInstance());
		}
		public static function getInstance():Model{
			if(_instance==null){
				_instance = new Model();
			}
			return _instance;
		}
	}
}