package com.netease.flash.framework.mvc.observer {
	/**
	 * notify Observer
	 * 
	 * @see com.netease.flash.framework.mvc.observer.Notification Notification
	 *  
	 * @author bezy
	 * 
	 */
	public class Observer {
		private var _notifyMethod:Function;
		private var _notifyContext:Object;

		/**
		 * Constructor. 
		 * 
		 * @param notifyMethod the notification method of the interested object
		 * @param notifyContext the notification context of the interested object
		 * 
		 */
		public function Observer(notifyMethod:Function, notifyContext:Object) {
			this._notifyMethod = notifyMethod;
			this._notifyContext = notifyContext;
		}

		/**
		 * set notify function
		 *  
		 * @param method the notification (callback) method of the interested object.
		 * 
		 */		
		public function set notifyMethod(method:Function):void {
			this._notifyMethod = method;
		}
		
		/**
		 * Set the notification context.
		 * 
		 * @param context the notification context (this) of the interested object.
		 * 
		 */
		public function set notifyContext(context:Object):void {
			this._notifyContext = context;
		}
		
		/**
		 * notify the observer
		 *  
		 * @see com.netease.flash.framework.mvc.observer.Notification Notification
		 * 
		 * @param notification
		 * 
		 */
		public function notifyObserver(notification:Notification):void {
			this._notifyMethod.apply(this._notifyContext, [notification]);
		}
		
		/**
		 * compare notify context
		 *  
		 * @param context
		 * @return 
		 * 
		 */
		public function compareNotifyContext(context:Object):Boolean {
		 	return this._notifyContext == context;
		}
		
		/**
		 *
		 * compare notify method
		 *  
		 * @param method
		 * @return 
		 * 
		 */
		public function compareNotifyMethod(method:Function):Boolean {
			return this._notifyMethod == method;
		}
		
		/**
		 * get signature of observer
		 *  
		 * @return 
		 * 
		 */
		public function getSignature():Object {
			return this._notifyMethod as Object;
		}
		
	}
}