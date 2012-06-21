package com.netease.webgame.bitchwar.view.mediator.msg
{
	import com.netease.webgame.bitchwar.InnerCommandConstants;
	import com.netease.webgame.bitchwar.model.vo.msg.MsgVO;
	import com.netease.webgame.core.view.mediator.baseclass.BaseMediator;
	import com.netease.webgame.bitchwar.view.vc.msg.ModeLessTipPanel;
	
	import org.puremvc.as3.patterns.observer.Notification;

	public class ModelessTipMediator extends BaseMediator
	{
		public function ModelessTipMediator()
		{
		}
		override public function onRegister():void{
			
		}
		override public function onRemove():void{
			
		}
		override public function addCommandListeners():void{
			addCommandListener(InnerCommandConstants.SHOW_MODELESS_TIP_MSG,onShowModeLessMsgHandler);
		}
		private function onShowModeLessMsg(note:Notification):void{
			var msgVO:MsgVO = note.getBody();
			view.showModelessTip(msgVO);
		}
		public function get view():ModeLessTipPanel{
			viewComponent as ModeLessTipPanel;
		}
	}
}