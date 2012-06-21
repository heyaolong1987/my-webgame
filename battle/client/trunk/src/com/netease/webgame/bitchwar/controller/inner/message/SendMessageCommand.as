package com.netease.webgame.bitchwar.controller.inner.message
{
	import com.netease.webgame.bitchwar.controller.inner.baseClass.BaseInnerCommand;
	
	import org.puremvc.as3.interfaces.INotification;

	public class SendMessageCommand extends BaseInnerCommand
	{
		public function SendMessageCommand()
		{
			
		}
		override public function execute(note:INotification):void{
			var message:Object = note.getBody();
			message.type;
			message.info;
		}
		
	}
}