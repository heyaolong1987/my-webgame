package com.netease.flash.common.log {
		
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;												

	/**
	 * Console use firebug or trace
	 * 
	 * @author bezy
	 */
	public class Console {
		private static var isOpen:Boolean = false;
		private static var isRedirect:Boolean = false;
		private static var timeMap:Dictionary = new Dictionary();
		
		/**
		 * check and redirect log to firebug console
		 * 
		 * @param r
		 * @return Boolean 
		 */
		public static function redirect(r:Boolean):Boolean {
			if(r && detect()) {
				isRedirect = true;
			}else {
				isRedirect = false;
			}
			return isRedirect;
		}
		
		public static function open(r:Boolean):void {
			isOpen = r;
		}

		private static function detect():Boolean {
			try{
				if(ExternalInterface.available) {
					return ExternalInterface.call("console.error.toString") != null;
				}
			}catch(e:Error){
				trace(e);
			}
			return false;
		}

		public static function log(...rest):void {
			send("log", rest);
		}

		public static function debug(...rest):void {
			send("debug", rest);
		}
		
		public static function info(...rest):void {
			send("info", rest);
		}
		
		public static function warn(...rest):void {
			send("warn", rest);
		}
		
		public static function error(...rest):void {
			send("error", rest);
		}
		
		public static function time(name:String):void {
			send("time", [name]);
		}

		public static function timeEnd(name:String):void {
			send("timeEnd", [name]);
		}

		public static function send(level:String,...rest):void {
			if(!isOpen) {
				return;
			}
			if(isRedirect) {
				try{
					ExternalInterface.call("console." + level, rest);
				}catch(e:Error){
					trace(e);
				}
			}else {
				if(level == "time") {
					var start:String = rest[0].toString();
					timeMap[start] = new Date().getTime();
					trace("[TIME] "+start+": start");
				}else if(level == "timeEnd") {
					var end:String = rest[0].toString();
					var before:Number = timeMap[end];
					if(!isNaN(before)) {
						delete timeMap[end];
						trace("[TIME] "+end+": "+(new Date().getTime() - before)+"ms");	
					}
				}else{
					trace(("["+level+"]").toUpperCase(),rest);
				}
			}
		}
	}
}
