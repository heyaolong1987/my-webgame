package com.netease.core.display.cell {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	
	import mx.controls.listClasses.ListItemRenderer;
	import mx.core.IToolTip;
	import mx.core.UIComponent;
	import com.netease.core.display.tooltip.ICToolTipClient;
	import com.netease.core.events.GameEvent;
	
	/**
	 * @author heyaolong
	 * 
	 * 2011-10-29
	 */ 
	public class BaseCell extends UIComponent implements ICToolTipClient{
		public static const CELL_CLICK:String = "CELL_CLICK";
		protected var _cellWidth:int;
		protected var _cellHeight:int;
		
		protected var _iconWidth:int;
		protected var _iconHeight:int;
		
		public var disabledFillData:BitmapData;
		public var normalFillData:BitmapData;
		public var highlightFillData:BitmapData;
		public var selectedFillData:BitmapData;
		
		public var highlight:Boolean=false;
		
		public var selected:Boolean=false;
		public var over:Boolean=false;
		
		
		protected var _data:Object;
		protected var _grid:Bitmap;
		protected var _icon:Bitmap;
		protected var _iconFunction:Function;
		
		protected var _hideNum:Boolean;
		protected var _numTxt:TextField;
		
		protected var _toolTipData:Object;
		protected var _toolTipFunction:Function;
		protected var _toolTipClass:Class;
		
		public var cellIndex:Boolean;
		
		public function BaseCell()
		{
			mouseChildren = false;
			addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			addEventListener(MouseEvent.CLICK,mouseClickHandler);
		}
		override protected function createChildren():void{
			_grid = new Bitmap();
			addChild(_grid);
			_icon = new Bitmap();
			addChild(_icon);
			_numTxt = new TextField();
			addChild(_numTxt);
		}
		
		protected function mouseOverHandler(event:Event):void{
			event.stopImmediatePropagation();
			this.over = true;
			
		}
		protected function mouseOutHandler(event:Event):void{
			event.stopImmediatePropagation();
			this.over = false;
		}
		protected function mouseClickHandler(event:Event):void{
			event.stopImmediatePropagation();
			dispatchEvent(new GameEvent(CELL_CLICK));
		}
		public function set toolTipDataFunction(value:Function):void{
			this._toolTipFunction = value;
		}
		public function registerToolTip(tipData:Object, tipClass:Class=null, tipFunction:Function=null):void {
			/*if(tipData==null && tipFunction==null){
			ProToolTipManager.getInstance().unRegisterToolTip(this);
			} else {
			_toolTipLayoutDirection = layoutDirection;
			_toolTipData = tipData;
			_toolTipClass = tipClass;
			_toolTipDataFunction = tipFunction;
			_toolTipShowDelay = showDelay;
			ProToolTipManager.getInstance().registerToolTip(this);
			}*/
		}
		public function  get hideNum():Boolean{
			return _hideNum;
		}
		public function set hideNum(value:Boolean):void{
			_hideNum = value;
			invalidateDisplayList();
		}
		public function set cellWidth(value:int):void{
			_cellWidth = value;
		}
		public function get cellWidth():int{
			return _cellWidth;
		}
		public function set cellHeight(value:int):void{
			_cellHeight = value;
			invalidateDisplayList();
		}
		public function get cellHeight():int{
			return _cellHeight;
		}
		
		public function set iconWidth(value:int):void{
			_iconWidth = value;
			invalidateDisplayList();
		}
		public function get iconWidth():int{
			return _iconWidth;
		}
		public function set iconHeight(value:int):void{
			_iconHeight = value;
			
			invalidateDisplayList();
		}
		public function get iconHeight():int{
			return _iconHeight;	
		}
		override protected function commitProperties():void{
			
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			var fillData:BitmapData = normalFillData;
			if(enabled){
				if(highlight&&highlightFillData){
					fillData = highlightFillData;
				}
				else if(selected&&selectedFillData) {
					fillData = selectedFillData;
				}
			}
			else{
				if(disabledFillData){
					fillData = disabledFillData;
				}
			}
			if(fillData){
				_grid.bitmapData = fillData;
			}
			loadIcon();
		}
		public function set data(value:Object):void{
			if(_data==value){
				return;
			}
			clearData();
			_data = value;
			
			invalidateProperties();
			invalidateDisplayList();
		}
		public function get data():Object{
			return _data;
		}
		protected function clearData():void{
			_icon.bitmapData = null;
			_numTxt.text = "";
		}
		protected function loadIcon():void{
			
		}
		public function get icon():Bitmap{
			return _icon;
		}
		public function set icon(value:Bitmap):void{
			_icon = value;
			invalidateDisplayList();
		}
	}
}