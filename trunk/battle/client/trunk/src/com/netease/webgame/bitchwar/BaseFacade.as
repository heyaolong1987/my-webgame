package com.netease.webgame.bitchwar
{
	
	import org.puremvc.as3.core.*;
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class BaseFacade extends Facade
	{
		public function BaseFacade( ) {
			super();
			
		}
		public static function getInstance():BaseFacade {
			if (instance == null) instance = new BaseFacade( );
			return instance as BaseFacade;
		}
		
		
	}
}