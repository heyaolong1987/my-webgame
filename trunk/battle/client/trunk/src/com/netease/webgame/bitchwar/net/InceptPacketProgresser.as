package com.netease.webgame.bitchwar.net{
	import com.netease.webgame.bitchwar.ApplicationFacade;
	import com.netease.webgame.core.interfaces.ICPacketProgresser;
	import com.netease.webgame.core.model.vo.net.CallVO;
	import com.netease.webgame.core.model.vo.net.InceptVO;
	
	/**
	 *
	 *@author heyaolong
	 *
	 *2011-10-10
	 */
	public class InceptPacketProgresser implements ICPacketProgresser{
		public static var _instance:InceptPacketProgresser;
		public function InceptPacketProgresser(){
		}
		public function progress(inceptVO:InceptVO):void{
			ApplicationFacade.getInstance().sendNotification(inceptVO.funcName,inceptVO);
		}
		public static function getInstance():InceptPacketProgresser{
			if(_instance == null){
				_instance = new InceptPacketProgresser();
			}
			return _instance;
		}
	}
}