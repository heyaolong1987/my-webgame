package com.netease.flash.framework.mvc.facade {
	import com.netease.flash.common.lang.Map;
	import com.netease.flash.framework.mvc.observer.Notification;
	import com.netease.flash.framework.mvc.observer.Observer;
	
	import flash.utils.Dictionary;
	
	/**
	 * mvc facade
	 *  
	 * @author bezy
	 * 
	 */
	public class Facade {
		private static var instance:Facade = null;
		private static var listeners:Dictionary = new Dictionary();
		
		private const SINGLETON_MSG	: String = "Facade Singleton already constructed!";

		public function Facade(){
			if(instance != null){
				throw Error(SINGLETON_MSG);
			}
		}
		
		public static function getInstance():Facade {
			if(instance == null){
				instance = new Facade();
			}
			return instance;
		}
		
		public function addNotificationObserver(name:String, observer:Observer):void {
			var observers:Map = listeners[name] as Map;
			if(observers == null){
				observers = new Map();
				listeners[name] = observers;
			}
			observers.putValue(observer.getSignature(), observer);
		}
		
		public function removeNotificationObserver(name:String, observer:Observer):void {
			var observers:Map = listeners[name] as Map;
			if(observers != null){
				observers.remove(observer.getSignature());
				if(observers.isEmpty()){
					delete listeners[name];
				}
			}
		}
		
		public function sendNotification(name:String, body:*):void {
			var notification:Notification = new Notification(name, body);
			notifyObserver(notification);
		}
		
		public function notifyObserver(notification:Notification):void {
			var observers:Map = notification[notification.name] as Map;
			if(observers!=null){
				var values:Array = observers.values();
				for each(var v:Observer in values){
					v.notifyObserver(notification);
				}
			}
		}

	}
}