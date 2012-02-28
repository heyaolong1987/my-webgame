package com.netease.webgame.bitchwar.constants
{
	public class Config
	{
		
		public static const WIDTH:int=1000;
		public static const HEIGHT:int=600;
		
		public static var resUrl:String = "";
		
		public static const version:String;// = CONFIG::version;	
		
		public static var swfVersion:String = "01.0001";
		public static var imgVersion:String = "01.0001";		
		public static var configUrl:String = "\Config.xml";
		
		public static var serverIp:String;
		public static var port:int;
		public static var isTest:Boolean = true;
		public static function load(xml:XML):void {
				serverIp = xml.server;
				port = xml.port;
				resUrl = xml.resUrl;
		}
	}
}