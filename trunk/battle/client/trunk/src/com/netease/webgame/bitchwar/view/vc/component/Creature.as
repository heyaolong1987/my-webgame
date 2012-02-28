package com.netease.webgame.bitchwar.view.vc.component
{
	import com.netease.webgame.bitchwar.model.vo.pet.CreatureVO;
	import com.netease.webgame.core.view.vc.component.bassclass.BaseItem;
	import com.netease.webgame.core.cacher.ResCacher;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	public class Creature extends BaseItem
	{
		
		public static var DEFAULT_RES_URL:String;
		
		public static var RES_URL_PREFIX:String;
		
		public static var RES_URL_POSTFIX:String;
		
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
		
		public function Creature(obj:CreatureVO)
		{
			super(obj);
		}
		/*设置对象数据 
		* @param value
		* 
		*/
		override public function set data(value:*):void{
			super.data = value;
			_tfName.text = creatureVO.name;
		}
		
		/**
		 *获取怪物对象数据 
		 * @param value
		 * 
		 */
		private function get creatureVO():CreatureVO{
			return data as CreatureVO;
		}
		
		override protected function addListeners():void{
			super.addListeners();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			_tfName.x = -_tfName.textWidth/2;
			_tfName.y = _tfName.textHeight;
		}
		override protected function initComponent():void{
			super.initComponent();
			
			addChild(_backLayer);
			addChild(_frontLayer);
			
			_tfName.type = TextFieldType.DYNAMIC;
			_tfName.autoSize = TextFieldAutoSize.LEFT;
			_tfName.mouseEnabled = false;
			_tfName.textColor = 0xFFFFFF;
			_frontLayer.addChild(_tfName);
			
		}
		override protected function loadDefaultRes():void{
			ResCacher.getInstance().loadRes(DEFAULT_RES_URL,defaultResLoadCompleteHandler);
		}
		
		override protected function setRes(value:Object):void{
			super.setRes(value);
		}
		/**
		 *设置资源url 
		 * 
		 */
		override protected function setResUrl():void{
			_resUrl = RES_URL_PREFIX+creatureVO.resName+RES_URL_POSTFIX;
		}
		/**
		 *获取名称TextField 
		 * @return 
		 * 
		 */
		public function get tfName():TextField{
			return _tfName;
		}
		
	}
}