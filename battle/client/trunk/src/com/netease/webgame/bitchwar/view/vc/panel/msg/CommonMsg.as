package com.netease.webgame.bitchwar.view.vc.panel.msg
{
	import com.netease.webgame.bitchwar.model.vo.msg.MsgVO;
	
	import mx.controls.Text;

	public class CommonMsg extends Text
	{
		private var _msgVO:MsgVO;
		
		public function CommonMsg()
		{
		}
		public function set msgVO(value:MsgVO):void{
			_msgVO = value;
			this.htmlText = _msgVO.msg;	
			styleName = 'modelessTipBad';
		}
		public function get msgVO():MsgVO{
			return _msgVO;
			
		}
	}
}