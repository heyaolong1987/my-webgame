package com.netease.flash.common.net {
	/**
	 * @author: shu
	 * Nov 4, 2011 1:41:15 PM
	 **/
	public class PoolResLoaderConstants {
		
		/**
		 * 缓存类型：lru，按使用次数多少寸；支持设置cache大小，支持设置资源分类
		 */		
		public static const POOL_LRU:int = 1;
		/**
		 * 缓存类型：全部缓存，来者不拒，不设置大小，不设置分类
		 */		
		public static const POOL_HOLD:int = 2;
		
		/**
		 * lru资源分类，默认的资源分类，common，可以在外部自己定义更多的资源分类 
		 */		
		public static const RES_COMMON:int = 0;
	}
}