package com.netease.webgame.bitchwar.view.vc.layer
{
	import com.netease.webgame.bitchwar.constants.Config;
	import com.netease.webgame.bitchwar.model.vo.msg.MsgVO;
	import com.netease.webgame.core.view.vc.component.bassclass.BaseLayer;
	import com.netease.webgame.bitchwar.view.vc.panel.msg.ModelessTipPanel;
	import com.netease.webgame.bitchwar.view.vc.panel.msg.TipMsg;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.utils.Timer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	public class MsgLayer extends BaseLayer
	{
		private var _modelessTip:ModelessTipPanel = new ModelessTipPanel();
		public function MsgLayer()
		{
			
		}
		public function get modelessTipPanel():ModelessTipPanel{
			return _modelessTip;
		}
		public function set modelessTipPanel(value:ModelessTipPanel):void{
			_modelessTip = value;
		}
	}
}