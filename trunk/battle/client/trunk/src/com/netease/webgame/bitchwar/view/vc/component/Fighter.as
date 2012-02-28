package com.netease.webgame.bitchwar.view.vc.component
{
	import com.netease.webgame.bitchwar.model.vo.fight.FighterVO;
	import com.netease.webgame.core.view.vc.component.bassclass.BaseItem;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	public class Fighter extends BaseItem
	{
		/**
		 *名字字段 
		 */
		private var _tfName:TextField = new TextField();
		
		/**
		 *背景层 
		 */
		protected var _backLayer:Sprite = new Sprite();
		
		/**
		 *前景层
		 */
		protected var _frontLayer:Sprite = new Sprite();
		
		/**
		 *血条 
		 */
		private var _hpBar:HPBar = new HPBar();
		
		/**
		 *血条 
		 */
		private var _mpBar:MPBar = new MPBar();
		
		public function Fighter(fighterVO:FighterVO)
		{
			super(fighterVO);
		}
		override protected function initComponent():void{
			super.initComponent();
			
			addChild(_backLayer);
			addChild(_frontLayer);
			
			addChild(_hpBar);
			_hpBar.x = 0;
			_hpBar.y = 0;
			addChild(_mpBar);
			_mpBar.x = 0;
			_mpBar.y = 10;
			_tfName.type = TextFieldType.DYNAMIC;
			_tfName.autoSize = TextFieldAutoSize.LEFT;
			_tfName.mouseEnabled = false;
			_tfName.textColor = 0xFFFFFF;
			_tfName.x = 0;
			_tfName.y = 20;
			
			_frontLayer.addChild(_tfName);
			
		}
		/*设置对象数据 
		* @param value
		* 
		*/
		override public function set data(value:*):void{
			if(value!=null&&value is FighterVO){
				super.data = value;
				if(FighterVO){
					_tfName.text = fighterVO.name;
					_hpBar.hpMax = 1000;
					_hpBar.hp = 500;
					_mpBar.mpMax = 1000;
					_mpBar.mp = 100;
				}
			}
		}
		public function get fighterVO():FighterVO{
			return _data as FighterVO;
		}
		public function set fighterVO(value:FighterVO):void{
			_data = value;
			
		}
	}
}