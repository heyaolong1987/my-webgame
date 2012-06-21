package com.netease.flash.framework.puremvc.manager {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import com.netease.flash.common.utils.setSimpleInterval;

	[Event(name="hideLoading", type="flash.events.Event")]
	[Event(name="showLoading", type="flash.events.Event")]
	public class LoadingManager extends EventDispatcher {
		public static const SHOW_LOADING_INTERVAL:int = 5000;
		public static const HIDE_LOADING:String = "hideLoading";
		public static const SHOW_LOADING:String = "showLoading";
		
		public function LoadingManager() {
			if (instance) {
				throw new Error("Please use getInstance() method to get the instance.");
			}
			
			_loadingCommands = new Dictionary();
			_commandKeys = [];
			setSimpleInterval(validateLoadingPopup, 1000);
		}
		
		private var _showLoadingNow:Boolean = false;
		
		private var initialized:Boolean;
		private var _stage:Stage;
		public function initialize(stage:Stage):void {
			initialized = true;
			_stage = stage;
			
//			_loadingPopop = new RemoteCallLoadingPopup();
//			_loadingPopop.visible = false;
//			_loadingPopop.x = (_stage.width - _loadingPopop.width) / 2;
//			_loadingPopop.y = (_stage.height - _loadingPopop.height) / 2;
//			_stage.addChild(_loadingPopop);
		}
		
		private static var instance:LoadingManager = new LoadingManager();
		
		public static function getInstance():LoadingManager {
			return instance;
		}
		
//		private var _loadingPopop:RemoteCallLoadingPopup;
		private var _loadingCommands:Dictionary;
		private var _commandKeys:Array;
		public function show(commandKey:Object):void {
			_loadingCommands[commandKey] = new Date().getTime() + SHOW_LOADING_INTERVAL;
			_commandKeys.push(commandKey);
		}
		
		public function hide(commandKey:Object):void {
			_loadingCommands[commandKey] = null;
			delete _loadingCommands[commandKey];
			var index:int = _commandKeys.indexOf(commandKey);
			if (-1 != index) {
				_commandKeys.splice(index, 1);
			}
		}
		
		public function validateLoadingPopup():void {
			if (_commandKeys.length > 0) {
				var show:Boolean = false;
				var now:Number = new Date().getTime();
				for (var i:int = _commandKeys.length - 1; i >= 0; i--) {
					if (_loadingCommands[_commandKeys[i]] <= now) {
						show = true;
						break;
					}
				}
				
				if (show && !_showLoadingNow) {
					this.dispatchEvent(new Event(SHOW_LOADING));
					_showLoadingNow = true;
//					_loadingPopop.visible = true;
				} else if (!show && _showLoadingNow) {
					_showLoadingNow = false;
					this.dispatchEvent(new Event(HIDE_LOADING));
//					_loadingPopop.visible = false;
				}
			} else if (_showLoadingNow) {
				_showLoadingNow = false;
				this.dispatchEvent(new Event(HIDE_LOADING));
			}
		}
	}
	
	
}