package com.netease.webgame.bitchwar.interfaces. {
	
	import com.netease.webgame.bitchwar.model.vo.newbie.NewbieVO;
	
	import flash.geom.Rectangle;

	/**
	 * 需要被新手引导的view统一接口
	 * @author User
	 */	
	public interface INewBieView {
		
		/**传递该view可能需要引导的对应步骤id获取相应target元件的全局坐标区块，用于引导显示**/
		function getNewbieHotRect(newbie:NewbieVO):Rectangle;
		
	}
}