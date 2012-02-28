package com.netease.webgame.bitchwar.manager {
	
	
	public class ProPopUpChildList {
		
		public static const BOTTOM:int = 0;
		public static const MINIQUESTS:int = 1;//任务追踪
		public static const COMMON:int = 2;//普通窗口 ,这个层可能会被别的逻辑关闭
		public static const HOTBAR:int = 3;//快捷栏窗口
		public static const MODAL:int = 4;//模态显示层
		public static const TOP:int = 5;//最頂层，如果增加新的层级，请保证该值是最大的，如CommonAlert等通用组件使用
		public static const MODELESS:int = 6;//非模态窗口，特殊情况，始终在最上层显示
		
	}
}