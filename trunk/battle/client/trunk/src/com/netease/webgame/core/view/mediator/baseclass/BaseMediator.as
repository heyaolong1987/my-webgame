package com.netease.webgame.core.view.mediator.baseclass
{
	import com.netease.webgame.bitchwar.model.proxy.baseclass.BaseProxy;
	
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class BaseMediator extends Mediator
	{
		private var listenerMap:Object = {};
		public function BaseMediator(mediatorName:String,viewComponent:Object){
			super(mediatorName,viewComponent);
			addCommandListeners();
		}
		override public function onRegister():void{
			super.onRegister();
		}
		override public function onRemove():void{
			super.onRemove();
		}
		public function addCommandListeners():void{
			
		}
		public function addCommandListener(type:String,listener:Function):void{
			if(type!=null && listener!=null){
				if(listenerMap[type]==null){
					listenerMap[type] = new Dictionary();
				}
				listenerMap[type][listener] = listener;
			}
		}
		public function removeCommandListener(type:String,listener:Function):void{
			if(type != null && listenerMap[type]!=null && listener!=null){
				listenerMap[type][listener] = null;
			}
		}
		override public function listNotificationInterests():Array{
			
			var t:Array = [];
			for(var command:* in listenerMap){
				t.push(command);
			}
			return t;
		}
		override public function handleNotification(notification:INotification):void{
			var listeners:Dictionary = listenerMap[notification.getName()];
			if(listeners){
				for each(var listener:Function in listeners){
					listener(notification);
				}
			}
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