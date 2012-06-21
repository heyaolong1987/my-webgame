package com.netease.webgame.bitchwar.view.mediator.login{
	import com.netease.webgame.bitchwar.CallCommandConstants;
	import com.netease.webgame.bitchwar.net.CallPacketHandler;
	import com.netease.webgame.bitchwar.view.vc.panel.login.SelectCharView;
	import com.netease.webgame.core.events.GameEvent;
	import com.netease.webgame.core.model.vo.net.CallVO;
	import com.netease.webgame.core.view.mediator.baseclass.BaseMediator;
	
	/**
	 *
	 *@author heyaolong
	 *
	 *2011-10-19
	 */
	public class SelectCharViewMediator extends BaseMediator {
		public static const NAME:String = "SelectCharViewMediator";
		public function SelectCharViewMediator(viewComponent:Object)
		{
			super(SelectCharViewMediator.NAME,viewComponent);
		}
		
		override public function onRegister():void{
			super.onRegister();
			view.addEventListener(SelectCharView.CREATE_CHAR,createCharHandler);
		}
		override public function onRemove():void{
			super.onRemove();
			view.removeEventListener(SelectCharView.CREATE_CHAR,createCharHandler);
		}
		/**
		 *创建角色 
		 * @param event
		 * 
		 */
		public function createCharHandler(event:GameEvent):void{
			sendNotification(CallCommandConstants.CALL_SERVER,new CallVO(CallPacketHandler.CREATE_CHAR,event.data as Array));
		}
		public function get view():SelectCharView{
			return viewComponent as SelectCharView;
		}
	}
}