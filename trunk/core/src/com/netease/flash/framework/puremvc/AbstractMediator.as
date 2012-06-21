package com.netease.flash.framework.puremvc {
	
	import com.netease.flash.common.utils.setSimpleTimeout;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * abstract mediator
	 * extend puremvc Mediator
	 * 
	 * @see org.puremvc.as3.patterns.mediator.Mediator Mediator
	 * @author bezy
	 * 
	 */	
	public class AbstractMediator extends Mediator{
		private var listenerFactory:ListenerFactory;
		
		public function AbstractMediator(viewComponent:Object) {
			super(null,viewComponent);
		}
		
		internal function setMediatorName(mediatorName:String):void {
			this.mediatorName = mediatorName;
		}
		
		/**
		 * list notification listeners
		 * 
		 * need to be override
		 *  
		 * @param listenerMap
		 * 
		 */
		public function listNotificationListeners(factory:ListenerFactory):void {			
		}
		
		public final override function listNotificationInterests():Array {
			if(listenerFactory == null){
				listenerFactory = new ListenerFactory();
				listNotificationListeners(listenerFactory);
			}
			return listenerFactory.keys();
		}
		
		public final override function handleNotification(notification:INotification):void {
			if(notification == null){
				return;
			}
			var listener:Function = listenerFactory.getListener(notification.getName());
			if(listener != null){
				listener.apply(null,[notification]);
			}
		}
		
		public override function onRemove():void {
			super.onRemove();
			listenerFactory.clear();
		}
				
		protected function get simpleFacade():SimpleFacade {
			var r:SimpleFacade = facade as SimpleFacade;
			if(r == null){
				throw Error(SimpleFacade.FACADE_ERROR);
			}
			return r;
		}
		
		protected function getServiceByName(serviceName:String):AbstractService {
			return simpleFacade.retrieveServiceByName(serviceName);
		}
		
		protected function getServiceByType(clazz:Class):AbstractService {
			return simpleFacade.retrieveServiceByType(clazz);
		}
		
		public function sendRawNotification(notification:INotification):void {
			facade.notifyObservers(notification);
		}
		
		public function sendTimeoutNotification(delay:Number, notificationName:String, body:Object=null, type:String=null):void {
			setSimpleTimeout(sendNotification, delay, notificationName, body, type);
		}

	}
}