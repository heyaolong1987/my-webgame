package com.netease.webgame.bitchwar.view.vc.layer
{
	import com.netease.webgame.bitchwar.constants.Config;
	import com.netease.webgame.bitchwar.constants.gameview.GameViewConstants;
	import com.netease.webgame.bitchwar.model.Model;
	import com.netease.webgame.bitchwar.view.vc.panel.login.SelectCharView;
	import com.netease.webgame.core.view.vc.component.bassclass.BaseLayer;
	
	import flash.display.Scene;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.BackgroundColor;
	
	public class GameViewLayer extends BaseLayer
	{
		private var _currentGameView:String;
		private var _sceneLayer:SceneLayer;
		private var _fightLayer:FightLayer;
		private var _selectCharLayer:SelectCharView;
		private var _msgLayer:MsgLayer=new MsgLayer();
		public function GameViewLayer()
		{
			width = Config.WIDTH;
			height = Config.HEIGHT;
		}
		public function set currentGameView(value:String){
			_currentGameView = value;
			if(sceneLayer&&sceneLayer.parent){
				sceneLayer.parent.removeChild(sceneLayer);
			}
			sceneLayer = null;
			if(fightLayer&&fightLayer.parent){
				fightLayer.parent.removeChild(fightLayer);
			}
			fightLayer = null;
			if(selectCharLayer&&selectCharLayer.parent){
				selectCharLayer = null;
			}
			switch(currentGameView){
				case GameViewConstants.FIGHT_VIEW:
					_fightLayer = new FightLayer();
					addChild(_fightLayer);
					break;
				case GameViewConstants.SCENE_VIEW:
					_fightLayer = new FightLayer();
					addChild(_fightLayer);
					break;
				case GameViewConstants.SELECT_CHAR_VIEW:
					_selectCharLayer = new SelectCharView();
					addChild(_selectCharLayer);
					break;
			}
			if(msgLayer&&msgLayer.parent==null){
				addChild(msgLayer);
			}
		}
		public function get currentGameView():String{
			return _currentGameView;
		}
		public function set sceneLayer(value:SceneLayer):void{
			_sceneLayer = value;
		}
		public function get sceneLayer():SceneLayer{
			return _sceneLayer;
		}
		public function set fightLayer(value:FightLayer):void{
			_fightLayer = value;
		}
		public function get fightLayer():FightLayer{
			return _fightLayer;
		}
		public function get selectCharLayer():SelectCharView{
			return _selectCharLayer;
		}
		public function set selectCharLayer(value:SelectCharView):void{
			_selectCharLayer = value;
		}
		public function set msgLayer(value:MsgLayer):void{
			_msgLayer = value;
		}
		public function get msgLayer():MsgLayer{
			return _msgLayer;
		}
	}
}