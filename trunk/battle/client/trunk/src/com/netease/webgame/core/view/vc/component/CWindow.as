package com.netease.webgame.core.view.vc.component{
	import com.netease.webgame.bitchwar.interfaces..IPopUpWindow;
	import com.netease.webgame.core.interfaces.ICSnapWindow;
	import com.netease.webgame.core.manager.CPopUpManager;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mx.containers.TitleWindow;
	import mx.controls.Button;
	import mx.core.Application;
	import mx.core.mx_internal;
	import mx.events.CloseEvent;
	use namespace mx_internal;
	/**
	 *
	 *@author heyaolong
	 *
	 *2011-10-15
	 */
	
		public class CWindow extends TitleWindow implements IPopUpWindow, ICSnapWindow {
			
			public static const REMOVE:int = -2;
			
			protected var _popupData:Object;
			protected var _ignoreEsc:Boolean = false;
			protected var _ignoreESCImmediately:Boolean = false;
			
			protected var _snapWindowList:Array;
			protected var _snapParent:ICSnapWindow;
			protected var _snapDirection:String = "horizontal";
			
			protected var _offsetTop:int;
			protected var _closeButtonTop:int;	//离顶部
			protected var _closeButtonRight:int	;//离右边
			protected var _closeButtonWidth:int;
			protected var _closeButtonHeight:int;
			protected var _closeButtonPositionChanged:Boolean = false;
			protected var _closeButtonSizeChanged:Boolean = false;
			
			public function BaseWindow() {
				super();
				this.layout = "absolute";
				this.verticalScrollPolicy = "off";
				this.horizontalScrollPolicy = "off";
				this.showCloseButton = true;
				this.setStyle('borderAlpha', 0.9);
				this.addEventListener(CloseEvent.CLOSE, closeHandler);
				this.offsetTop = 0;
				closeButtonHeight = 20;
				closeButtonWidth = 20;
				closeButtonRight = 4;
				closeButtonTop = 2;
			}
			
			public function get offsetTop():int {
				return _offsetTop;
			}
			
			public function set offsetTop(v:int):void {
				_offsetTop = v;
			}
			
			public function get closeButtonWidth():int {
				return _closeButtonWidth;
			}
			
			public function set closeButtonWidth(value:int):void {
				_closeButtonWidth = value;
				_closeButtonSizeChanged = true;
				invalidateProperties();
			}
			
			public function get closeButtonHeight():int {
				return _closeButtonHeight;
			}
			
			public function set closeButtonHeight(value:int):void {
				_closeButtonHeight = value;
				_closeButtonSizeChanged = true;
				invalidateProperties();
			}
			
			public function set closeButtonTop(value:int):void {
				_closeButtonTop = value;
				_closeButtonPositionChanged = true;
				invalidateProperties();
			}
			
			public function set closeButtonRight(value:int):void {
				_closeButtonRight = value;
				_closeButtonPositionChanged = true;
				invalidateProperties();
			}
			
			[Inspectable(category="General", enumeration="vertical,horizontal", defaultValue="horizontal")]
			public function set snapDirection(value:String):void {
				_snapDirection = value;
			}
			
			public function get snapDirection():String {
				return _snapDirection;
			}
			
			override protected function layoutChrome(unscaleWidth:Number, unscaledHeight:Number):void {
				super.layoutChrome(unscaleWidth, unscaledHeight);
				var closeButton:Button = mx_internal::closeButton;
				if (_closeButtonSizeChanged && closeButton!=null && showCloseButton) {
					_closeButtonSizeChanged = false;
					closeButton.width = _closeButtonWidth;
					closeButton.height = _closeButtonHeight;
				}
				
				if(closeButton){
					_closeButtonPositionChanged = false;
					closeButton.move(unscaleWidth - _closeButtonRight - closeButtonWidth, _closeButtonTop);
				}
			}
			
			protected function closeHandler(e:CloseEvent=null):void {
				if(e!=null&&e.detail==REMOVE){
					return;
				}
				ProPopUpManager.hidePopup(this);
			}
			
			/**
			 * @comment zb
			 * 对于自定义的关闭按钮，调用此方法...
			 */ 
			protected function onClose():void {
				ProPopUpManager.hidePopup(this);
			}
			
			public function setSnapParent(parent:ICSnapWindow):void {
				_snapParent = parent;
			}
			
			public function addSnap(child:ICSnapWindow):void {
				if(_snapWindowList==null){
					_snapWindowList = new Array();
				}
				if(_snapWindowList.indexOf(child)==-1) {
					child.setSnapParent(this);
					_snapWindowList.push(child);
					layoutSnapWindows();
				}
			}
			
			public function snapClose(child:ICSnapWindow):void {
				if(_snapWindowList!=null) {
					var snap:ICSnapWindow;
					var i:int;
					for(i=0; i<_snapWindowList.length; i++) {
						snap = _snapWindowList[i];
						if(snap==child) {
							_snapWindowList.splice(i, 1);
							layoutSnapWindows();
							break;
						}
					}
				}
			}
			
			public function snapMove(child:ICSnapWindow, xoffset:int, yoffset:int):void {
				move(this.x+xoffset, this.y+yoffset);
			}
			
			public function moveSnap(x:int, y:int):void {
				super.move(x, y);
				if(_snapWindowList!=null && _snapWindowList.length>0) {
					layoutSnapWindows();
				}
			}
			
			public function get snapWidth():int {
				return unscaledWidth;
			}
			
			public function get snapHeight():int {
				return unscaledHeight;
			}
			
			protected function clearSnapWindow():void {
				if(_snapParent) {
					_snapParent.snapClose(this);
					_snapParent = null;
				} 
				if(_snapWindowList!=null) {
					for each(var snap:ICSnapWindow in _snapWindowList) {
						snap.setSnapParent(null);
					}
					_snapWindowList = [];
				}
			}
			
			protected function layoutSnapWindows():void {
				var i:int;
				var child:ICSnapWindow;
				var xoffset:int = this.x + width;
				var yoffset:int = this.y;
				var childIndex:int;
				var selfIndex:int;
				if(_snapWindowList!=null){
					for(i=0; i<_snapWindowList.length; i++){
						child = _snapWindowList[i];
						if(parent!=null && parent==DisplayObject(child).parent) {
							//统一将snap放于Parent的上面
							selfIndex = parent.getChildIndex(this);
							childIndex = parent.getChildIndex(DisplayObject(child));
							if(childIndex-selfIndex>1) {
								parent.setChildIndex(this, childIndex);
							} else if(childIndex-selfIndex<-1) {
								parent.setChildIndex(DisplayObject(child), selfIndex);
							}
						}
						child.moveSnap(xoffset, yoffset);
						if(_snapDirection=="vertical") {
							yoffset += child.snapHeight;
						} else {
							xoffset += child.snapWidth;
						}
					}
				}
			}
			
			/**
			 * @comment zb
			 * 通过ProPopupManager关闭（程序关闭，或者esc关闭）
			 * 这时不需要再调用closeHandler，但仍然需要发出Close事件通知外层（一般是Mediator）
			 */ 
			public function onRemove(byESC:Boolean = false):void {
				clearSnapWindow();
				var event:CloseEvent = new CloseEvent(CloseEvent.CLOSE);
				event.detail = REMOVE;
				dispatchEvent(event);
			}
			
			public function onCreate():void {
				
			}
			
			override public function move(x:Number, y:Number):void {
				var width:int = getWidthWithSnaps();
				var height:int = getHeightWithSnaps();
				var minX:int = 0;
				var maxX:int = stage?(stage.stageWidth-width):(Application.application.width-width);
				var minY:int = 0;
				var maxY:int = stage?(stage.stageHeight-height):(Application.application.height-height);
				if(x<minX){
					x = minX;
				} else if(x>maxX) {
					x = maxX;
				}
				if(y<minY){
					y = minY;
				} else if(y>maxY){
					y = maxY;
				}
				if(_snapParent!=null) {
					_snapParent.snapMove(this, x-this.x, y-this.y);
				} else {
					super.move(x, y);
					if(_snapWindowList!=null && _snapWindowList.length>0) {
						layoutSnapWindows();
					}
				}
			}
			
			protected function getWidthWithSnaps():int {
				if(_snapWindowList) {
					var i:int;
					var width:int = snapWidth;
					if(snapDirection=="vertical") {
						for(i=0; i<_snapWindowList.length; i++) {
							width = Math.max(width, snapWidth + ICSnapWindow(_snapWindowList[i]).snapWidth);
						} 
					} else {
						for(i=0; i<_snapWindowList.length; i++) {
							width += ICSnapWindow(_snapWindowList[i]).snapWidth;
						}
					}
					return width;
				}
				return snapWidth;
			}
			
			protected function getHeightWithSnaps():int {
				if(_snapWindowList) {
					var height:int = 0;
					var i:int;
					if(snapDirection=="vertical") {
						for(i=0; i<_snapWindowList.length; i++) {
							height += ICSnapWindow(_snapWindowList[i]).snapHeight;
						}
						height = Math.max(height, snapHeight);
					} else {
						for(i=0; i<_snapWindowList.length; i++) {
							height = Math.max(ICSnapWindow(_snapWindowList[i]).snapHeight, snapHeight);
						}
					}
					return height;
				}
				return snapHeight;
			}
			
			public function get popUpData():* {
				return _popupData;
			}
			
			public function set popUpData(value:*):void {
				_popupData = value;
			}
			
			public function get cacheSize():int {
				return 0;
			}
			
			public function get ignoreESC():Boolean {
				return _ignoreEsc;
			}
			
			public function set ignoreESC(value:Boolean):void {
				_ignoreEsc = value;
			}
			
			public function get ignoreESCImmediately():Boolean {
				return _ignoreESCImmediately;
			}
			
			public function set ignoreESCImmediately(value:Boolean):void {
				_ignoreESCImmediately = value;
			}
			
			public function modalAreaClick():void {
				
			}
			
		}
	}