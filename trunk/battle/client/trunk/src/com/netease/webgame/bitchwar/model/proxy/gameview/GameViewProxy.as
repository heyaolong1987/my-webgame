package com.netease.webgame.bitchwar.model.proxy.gameview
{
	import com.netease.webgame.bitchwar.InnerCommandConstants;
	import com.netease.webgame.bitchwar.constants.gameview.GameViewConstants;
	import com.netease.webgame.bitchwar.model.proxy.baseclass.BaseProxy;

	/**
	 *游戏视图管理 
	 * @author Administrator
	 * 
	 */
	public class GameViewProxy extends BaseProxy
	{
		public static const NAME:String = "GameViewProxy";
		private var _currentGameView:String=GameViewConstants.NONE;
		public function GameViewProxy()
		{
			super(GameViewProxy.NAME);
		}
		public function setCurrentGameView(value:String):Boolean{
			if(_currentGameView == value){
				sendNotification(InnerCommandConstants.CHANGE_GAME_VIEW_FAIL,value);
				return false;
			}
			_currentGameView = value;
			trace("switch to "+_currentGameView);
			sendNotification(InnerCommandConstants.GAME_VIEW_CHANGED,_currentGameView);
			return true;
		}
		public function getCurrentGameView():String{
			return _currentGameView;
		}
	}
}