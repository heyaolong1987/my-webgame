package com.netease.webgame.bitchwar.manager {
	import com.adobe.utils.StringUtil;
	import com.netease.webgame.bitchwar.interfaces..IHotkey;
	import com.netease.webgame.bitchwar.component.text.RichText;
	import com.netease.webgame.bitchwar.component.text.TLFText;
	import com.netease.webgame.bitchwar.component.text.TLFTextArea;
	import com.netease.webgame.bitchwar.component.text.TLFTextInput;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.Dictionary;
	
	import mx.controls.Text;
	import mx.controls.TextArea;
	import mx.core.UITextField;
	
	public class HotkeyManager {
		
		private static var instance:HotkeyManager;
		
		private var stage:Stage;
		private var hotkeyHandlerDic:Dictionary = new Dictionary(true);
		private var _activated:Boolean = true;
		
		public function HotkeyManager() {
			if (instance) {
				throw Error("***Only one HotkeyManager can be constructed***");
			}
		}
		
		public static function getInstance():HotkeyManager {
			if (!instance) {
				instance = new HotkeyManager();
			}
			return instance;
		}
		
		public function set activated(value:Boolean):void {
			_activated = value;
		}
		
		public function get activated():Boolean {
			return _activated;
		}
		
		public function initialize(theStage:Stage):void {
			stage = theStage;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onHotkeydown);
		}
		
		public function register(target:IHotkey):void {			
			if(StringUtil.stringHasValue(target.hotkey)){
				hotkeyHandlerDic[target.hotkey.toUpperCase()] = target;					
			}
		}
		
		public function unRegister(target:IHotkey):void {
			if(StringUtil.stringHasValue(target.hotkey) && hotkeyHandlerDic[target.hotkey.toUpperCase()] == target){
				delete hotkeyHandlerDic[target.hotkey.toUpperCase()];
			}
		}
		
		private function onHotkeydown(event:KeyboardEvent):void {
			if(!activated) {
				return;
			}
			if(event.target is TextField) {
				return;
			}
			if(event.target is TextArea) {
				if(TextArea(event.target).editable) {
					return;
				}
			}
			if(event.target is TLFText) {
				if(TLFText(event.target).editable) {
					return;
				}
			}
			var key:String = "";
			if(event.charCode == 0) {
				return;
			}
			if(event.ctrlKey) {
				if(key == "") {
					key = "C";
				}
			}
			if(event.shiftKey) {
				if(key == "") {
					key = "S";
				}else {
					key += "-S"
				}
			}
			if(event.altKey) {
				if(key == "") {
					key = "A";
				}else {
					key += "-A"
				}				
			}
			if(key == ""){
				key = String.fromCharCode(event.keyCode);
				if(key == "\t") {
					key = "\\t";
				}
			}else{
				key += ("-" + String.fromCharCode(event.keyCode));
			}
			if(key != "") {
				var target:IHotkey = hotkeyHandlerDic[key.toUpperCase()];
				if(target != null) {
					if(target is DisplayObject) {
						if(ProPopUpManager.hasModalPopupUpon(DisplayObject(target))){
							return;
						}
					}
					target.onHotkey();
				}
			}
		}
		
	}
}