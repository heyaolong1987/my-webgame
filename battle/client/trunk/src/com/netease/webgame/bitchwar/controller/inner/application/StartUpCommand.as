package com.netease.webgame.bitchwar.controller.inner.application
{
	import com.netease.webgame.bitchwar.controller.inner.baseClass.BaseInnerCommand;
	import com.netease.webgame.bitchwar.manager.MouseManager;
	import com.netease.webgame.bitchwar.model.proxy.ApplicationProxy;
	import com.netease.webgame.bitchwar.view.mediator.ApplicationMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class StartUpCommand extends BaseInnerCommand
	{
		public function StartUpCommand(){
			
		}
		override public function execute(note:INotification):void{ 
			registerProxy(new ApplicationProxy(ApplicationProxy.NAME));
			registerMediator(new ApplicationMediator(note.getBody()));
		}
		
	}
}