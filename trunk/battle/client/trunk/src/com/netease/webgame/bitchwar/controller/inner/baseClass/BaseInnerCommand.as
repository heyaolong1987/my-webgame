package com.netease.webgame.bitchwar.controller.inner.baseClass
{
	import com.netease.webgame.bitchwar.model.proxy.baseclass.BaseProxy;
	import com.netease.webgame.core.view.mediator.baseclass.BaseMediator;
	
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class BaseInnerCommand extends SimpleCommand
	{
		public function BaseInnerCommand()
		{
		}
		protected function registerCommand(noteName:String,commandClassRef:Class):void{
			facade.registerCommand(noteName,commandClassRef);
		}
		protected function removeCommand(noteName:String):void{
			facade.removeCommand(noteName);
		}
		
		protected function hasCommand(commandName:String):Boolean{
			return facade.hasCommand(commandName);
		}
		
		protected function registerProxy(proxy:BaseProxy):void{
			facade.registerProxy(proxy);
		}
		protected function removeProxy(proxyName:String):BaseProxy{
			return facade.removeProxy(proxyName) as BaseProxy;
		}
		protected function retrieveProxy(proxyName:String):BaseProxy{
			return facade.retrieveProxy(proxyName) as BaseProxy;
		}
		
		protected function hasProxy(proxyName:String):Boolean{
			return facade.hasProxy(proxyName);
		}
		
		protected function registerMediator(mediator:BaseMediator):void{
			facade.registerMediator(mediator);
		}
		
		protected function removeMediator(mediatorName:String):BaseMediator{
			return facade.removeMediator(mediatorName) as BaseMediator;
		}
		protected function retrieveMediator(mediatorName:String):BaseMediator{
			return facade.retrieveMediator(mediatorName) as BaseMediator;
		}
		protected function hasMediator(mediatorName:String):Boolean{
			return facade.hasMediator(mediatorName);
		}
	}
}