package com.netease.webgame.bitchwar.controller.call{
	import com.netease.webgame.bitchwar.ApplicationFacade;
	import com.netease.webgame.bitchwar.InceptCommandConstants;
	import com.netease.webgame.bitchwar.model.Model;
	import com.netease.webgame.core.events.NetEvent;
	import com.netease.webgame.core.model.vo.net.CallVO;
	import com.netease.webgame.core.net.NetEngine;
	
	import org.puremvc.as3.interfaces.INotification;

	public class CallServerCommand extends BaseCallCommand{
		private static  var net:NetEngine =  Model.getInstance().net;
		private static var call:CallVO;
		public function CallServerCommand()
		{
			
		}
		override public function execute(note:INotification):void{
			var callVO:CallVO = note.getBody() as CallVO;
			if(net.connected){
				net.call(callVO);
			}
			else{
				if(net.connecting==false){
					call = callVO;
					net.addEventListener(NetEvent.ON_CONNECT,onConnected);
					net.addEventListener(NetEvent.ON_CONNECT_ERROR,onConnectError);
					net.connect("localhost",20121);
				}
			}
		}
	
		/**
		 *连接成功 
		 * @param event
		 * 
		 */
		private function onConnected(event:NetEvent):void{
			ApplicationFacade.getInstance().sendNotification(InceptCommandConstants.SOCKET_CONNECT_SUCCESS);
			if(call!=null){
				net.call(call);
				call = null;
			}
		}
		/**
		 *连接失败 
		 * @param event
		 * 
		 */
		private function onConnectError(event:NetEvent):void{
			ApplicationFacade.getInstance().sendNotification(InceptCommandConstants.SOCKET_CONNECT_ERROR);
		}
		
	}
}