package com.netease.webgame.bitchwar.model.proxy.login{
	import com.netease.webgame.bitchwar.InnerCommandConstants;
	import com.netease.webgame.bitchwar.constants.login.LoginViewConstants;
	import com.netease.webgame.bitchwar.model.proxy.baseclass.BaseProxy;
	import mx.collections.ArrayCollection;
	
	/**
	 *
	 *@author heyaolong
	 *
	 *2011-10-12
	 */
	public class LoginProxy extends BaseProxy{
		public static const NAME:String = "LOGIN_PROXY";
		private var _charList:ArrayCollection;
		public function LoginProxy()
		{
			super(NAME);
		}
		public function loginSuccess(charList:ArrayCollection):void{
			_charList = charList;
			sendNotification(InnerCommandConstants.LOGIN_SUCCESS,_charList);	
		}
		private function hasChar():Boolean{
			return _charList!=null&&_charList.length>0;
		}
		public function get charList():ArrayCollection{
			return _charList;
		}
	}
}