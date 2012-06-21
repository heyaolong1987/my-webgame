package com.netease.flash.framework.ROService
{
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   
   /**
    * Used to manage all services defined on the IServiceLocator instance.
    */
	public class AbstractRemoteService {
		protected var services:Dictionary = new Dictionary();
		
		/**
       	 * Return the service with the given name.
       	 * @param name the name of the service.
       	 * @return the service.
       	 */
		public function getService(name:String):Object {
			var service:Object = services[name];
         
			if (service == null) {
         		throw new Error(name + " service not found.");
			}
			
	        return service;
      	}
      	
      	public function hasService(name:String):Boolean {
      		return services[name] != null;
      	}
      
       	/**
         * Register the services.
         * @param serviceLocator the IServiceLocator isntance.
         */
		public function register(serviceLocator:IServiceLocator):void {
			throw new Error("Abstract method register() can not be called.");
		}
		
      	/**
       	* Return all the accessors on this object.
      	* @param serviceLocator the IServiceLocator instance.
      	* @return this object's accessors.
       	*/
		protected function getAccessors(serviceLocator:IServiceLocator):XMLList {
			var description:XML = describeType(serviceLocator);
			var accessors:XMLList = description.accessor.(@access == "readwrite").@name;
            
			return accessors;
		}
	}
}