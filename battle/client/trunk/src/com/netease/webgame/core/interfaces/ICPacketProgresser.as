package com.netease.webgame.core.interfaces{
	import com.netease.webgame.core.model.vo.net.InceptVO;

	public interface ICPacketProgresser{
		/**
		 *远程函数处理
		 * @param funcName
		 * @param args
		 * 
		 */
		function progress(inceptVO:InceptVO):void;
	}
}