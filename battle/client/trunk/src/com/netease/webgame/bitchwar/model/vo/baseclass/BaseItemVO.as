package com.netease.webgame.bitchwar.model.vo.baseclass
{
	import com.netease.webgame.core.view.vc.component.bassclass.BaseItem;

	/**
	 *宠物，人物，物品，装备，怪物的基类 
	 * @author hyl
	 * 
	 */
	[RemoteClass(alias="com.netease.webgame.bitchwar.model.vo.baseclass.BaseItem")]
	public class BaseItemVO
	{
		
		/**
		 *ID 
		 */
		public var id:int;
		
		/**
		 *名称 
		 */
		public var name:String;

		/**
		 * 物品模板ID
		 */
		public var tempId:int;
	
		/**
		 * 创建时间
		 */
		public var createTime:Number;
		
		/**
		 *资源url 
		 */
		public var resName:String;
		
		
		public function BaseItemVO()
		{
		}
	}
}