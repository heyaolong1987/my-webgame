package com.netease.flash.framework.mvc.observer
{
	import com.netease.flash.framework.mvc.facade.Facade;
	
	/**
	 * notifier
	 * 
	 * @see com.netease.flash.framework.mvc.observer.Notification Notification
	 * 
	 * @author bezy
	 */	
	public class Notifier {
		protected var facade:Facade = Facade.getInstance();
		
		public function sendRawNotification(notification:Notification):void {
			facade.notifyObserver(notification);
		}
		
		public function sendNotification(type:String, body:*):void {
			facade.sendNotification(type, body);
		}
		 
		public function addNotificationListener(type:String, listener:Function):void {
			facade.addNotificationObserver(type, new Observer(listener, this));
		}
	}
}