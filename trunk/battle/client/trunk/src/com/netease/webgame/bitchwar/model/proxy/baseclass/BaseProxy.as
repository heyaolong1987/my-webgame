package com.netease.webgame.bitchwar.model.proxy.baseclass
{
	import com.netease.webgame.core.view.mediator.baseclass.BaseMediator;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class BaseProxy extends Proxy
	{
		public function BaseProxy(proxyName:String)
		{
			super(proxyName,null);
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
			return facade.hasMediator(mediatorName) ;
		}
	
	}
}