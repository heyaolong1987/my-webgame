package com.netease.flash.framework.ROService {
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
   
	public interface Responder {
		function result(event:ResultEvent):void;

		function fault(event:FaultEvent):void;
		
		function get arguments():Object;
		function set arguments(value:Object):void;
   }   
}