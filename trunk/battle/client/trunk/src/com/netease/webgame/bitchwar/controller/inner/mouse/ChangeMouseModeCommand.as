package com.netease.webgame.bitchwar.controller.inner.mouse
{
	import com.netease.webgame.bitchwar.controller.inner.baseClass.BaseInnerCommand;
	import com.netease.webgame.bitchwar.manager.MouseManager;
	import com.netease.webgame.bitchwar.model.proxy.mouse.MouseProxy;
	
	import org.puremvc.as3.interfaces.INotification;

	public class ChangeMouseModeCommand extends BaseInnerCommand
	{
		public function ChangeMouseModeCommand()
		{
		}
		override public function execute(note:INotification):void{
			var mouseMode:int = note.getBody() as int;
			var mouseProxy:MouseProxy = retrieveProxy(MouseProxy.NAME) as MouseProxy;
			mouseProxy.changeMouseMode(mouseMode);
		}
	}
}