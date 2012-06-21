package com.netease.webgame.core.constants{
	
	/**
	 *
	 *@author heyaolong
	 *
	 *2011-10-14
	 */
	public class CacheMode{
		public static const NOT_CACHE_ON_FULL:int = 0;
		public static const CACHE_DELETE_MIN_FRE_ON_FULL:int=1;
		public static const CACHE_DELETE_FIRST_ON_FULL:int=2;
		public static const CACHE_DELETE_MIN_TIMES_ON_FULL:int=3;
		public function CacheMode()
		{
		}
	}
}