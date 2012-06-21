package com.netease.webgame.bitchwar.controller.incept
{
	import com.netease.webgame.bitchwar.model.proxy.baseclass.BaseProxy;
	
	import flash.utils.Proxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class BaseInceptCommand extends SimpleCommand
	{
		public function BaseInceptCommand()
		{
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
	
	}
}