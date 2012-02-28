package test {
	
	import com.netease.webgame.bitchwar.interfaces.IPopUpWindow;
	import com.netease.webgame.bitchwar.util.AssetUtil;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.core.UIComponent;
	
	public class ChatEffectTest extends UIComponent implements IPopUpWindow {
		
		public function ChatEffectTest(){
			var chatMc:Sprite = AssetUtil.getFightMc("FightChatBg");
			var text:TextField = new TextField();
				text.width = 200;
				text.wordWrap = true;
				text.autoSize = TextFieldAutoSize.LEFT;
				text.defaultTextFormat = new TextFormat(null, 12, 0xFFFFFF);
				text.text = "这是测试相对层次弹出窗口的一个测试用例，看到了别觉得奇怪哦";
				text.x = 24;
				text.y = 2;
			chatMc.width = 228;
			chatMc.height = 64;
			addChild(chatMc);
			addChild(text);
		}
		
		public function get popUpData():* {
			
		}
		
		public function set popUpData(value:*):void {
			
		}
		
		public function get cacheSize():int {
			return 2;
		}
		
		public function onCreate():void {
			
		}
		
		public function modalAreaClick():void {
			
		}
		
		public function onRemove(byESC:Boolean = false):void {
			
		}
		
		public function get ignoreESC():Boolean {
			return false;
		}
		
		public function set ignoreESC(value:Boolean):void {
			
		}
		
		public function get ignoreESCImmediately():Boolean {
			return false;
		}
		
		public function set ignoreESCImmediately(value:Boolean):void {
			
		}
		
	}
}