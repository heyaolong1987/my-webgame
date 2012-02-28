/**
 * Author:  ShenXian
 * Created at: Dec, 16, 2010
 * 
 * 弹出窗口管理，与PopUpManager的管理方式区别
 * 
 * 	1，	支持自定义深度管理，showPopup和addPopup方法，都可以传递自定义childList参数
 * 		childList参数为非负整数，默认值为0
 * 		每一个childList表示一个层次，同层次的PopUpWindow按添加的先后顺序决定显示深度
 * 		不同层次的PopUpWindow按childList的大小排序，大的在上层
 * 		如：childList为1的所有窗口始终都会在childList为0的任何窗口之上
 * 		点击窗口会将被点窗口置于同层次的所有窗口的最上层
 * 		如：A，B都是childList为0的窗口，C，D为childList为1的窗口
 * 			依次创建A，B，C，D，则初始层次关系由底层到上层为A，B，C，D
 * 			点击A的任何位置，则层次关系由底层到上层变为B，A，C，D，因为A，B在同一层，被点击的窗口会置于同层次的所有窗口的最上层
 * 			再点击C的任何位置，则层次关系由底层到上层变为B，A，D，C，原理同上，但C和D始终在A和B的上层（A，B在重叠部分会被C，D遮挡）
 * 	2，支持PopUpWindow缓存机制，只要实现了IPopUpWindow接口，当弹出窗口被移除时，如果cacheSize方法返回值大于0且大于缓冲池当前大小，则弹出窗口会被缓存
 * 	3，舞台（Stage）大小变化感应
 * 		1>.当Flex程序的主内容区域较Stage小时，弹出窗口拖出主内容区域时，这时调整舞台大小可能导致弹出窗口不在显示区域
 * 		ProPopUpManager在这种情况下做了自我调整，保证弹出窗口在多数情况下（Stage比弹出窗口范围大）不会出现此问题
 * 		2>.一些初始化时居中的PopUpWindow，在调整Stage大小时，PopUpWindow会变得不居中显示
 * 		mx.managers.PopUpManager采用的是绝对定位，导致这个问题
 * 		ProPopUpManager目前采用的是居中相对定位，即始终保持PopupWindow的中心点与舞台的中心点相对位置不变，以后会增加配置参数
 * 	4，本组件目前还有待优化，某些实现还不够优美
 *	5，被缓存的窗口位置记忆
 */
package com.netease.webgame.bitchwar.manager {
	
	import com.netease.webgame.core.view.vc.component.RecycableFactory;
	import com.netease.webgame.bitchwar.interfaces.IPopUpWindow;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.core.IInvalidating;
	import mx.core.UIComponent;
	import mx.managers.FocusManager;
	import mx.managers.IFocusManager;
	import mx.managers.IFocusManagerContainer;
	import mx.managers.ISystemManager;
	import mx.managers.SystemManager;
	
	public class ProPopUpManager {
		
		private static var popupLayer:UIComponent;
		
		private static var layerDic:Array;
		
		private static var modalColor:int;
		
		private static var modalAlpha:Number;
		
		private static var stageWidth:int;
		
		private static var stageHeight:int;
		
		private static var topOne:DisplayObject;
		
		private static var lastMouseDownPopup:DisplayObject;
		
		public static function initialize(popupLayer:UIComponent, stage:Stage, modalColor:uint, modalAlpha:Number):void {
			ProPopUpManager.popupLayer = popupLayer;
			ProPopUpManager.layerDic = new Array();
			ProPopUpManager.modalColor = modalColor;
			ProPopUpManager.modalAlpha = modalAlpha;
			stageWidth = stage.stageWidth;
			stageHeight = stage.stageHeight;
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		/**
		 * 按Esc时关闭最上层弹出窗口
		 * NOTE: 受IPopUpWindow的ignoreESC返回值影响，相应窗口可能会忽略此方法
		 */ 
		private static function keyDownHandler(e:KeyboardEvent):void{
			switch(e.keyCode){
				case 27: //esc键
					removeByEscKeyDown();
					break;
			}
		}
		
		private static function stageResizeHandler(event:Event):void {
			var offsetX:int = (popupLayer.stage.stageWidth - stageWidth)/2;
			var offsetY:int = (popupLayer.stage.stageHeight - stageHeight)/2;
			stageWidth = popupLayer.stage.stageWidth;
			stageHeight = popupLayer.stage.stageHeight;
			var i:int;
			var childList:Array;
			var j:int;
			var child:ProPopUpItem;
			for(i=0; i<layerDic.length; i++) {
				childList = layerDic[i];
				if(childList==null) {
					continue;
				}
				for(j=0; j<childList.length; j++) {
					child = childList[j];
					child.instance.x = Math.min(Math.max(0, child.instance.x+offsetX), stageWidth-child.instance.width);
					child.instance.y = Math.min(Math.max(0, child.instance.y+offsetY), stageHeight-child.instance.height);
					if(child.mask!=null) {
						child.mask.width = stageWidth;
						child.mask.height = stageHeight;
						child.mask.graphics.clear();
						child.mask.graphics.beginFill(child.modalColor==-1?modalColor:child.modalColor, child.modalAlpha==-1?modalAlpha:child.modalAlpha);
						child.mask.graphics.drawRect(0, 0, stageWidth, stageHeight);
						child.mask.graphics.endFill();
					}
				}
			}
		}
		
		/**
		 * @param window，要添加的弹出窗口实例
		 * @param parent，父级窗口，此父级只是作为布局的参考，不是显示队列的从属关系
		 * @param modal，是否模态显示，模态显示下下层的不可点
		 * @param childList，在所有弹出窗口中的层级位置，当modal为true时忽略此参数
		 * @param modalColor，模式窗口的背景遮罩颜色，当modal为false时将忽略此参数，默认将使用公共参数
		 * @param modalAlpha，模式窗口的背景遮罩透明度，当modal为false时将忽略此参数，默认将使公共部参数
		 */ 
		public static function addPopup(	window:IFlexDisplayObject, 
											parent:DisplayObject=null, 
											modal:Boolean=false, 
											childList:int=-1, 
											modalColor:int=-1, 
											modalAlpha:Number=-1	):void {
			var childIndex:int = 0;
			var i:int;
			var j:int;
			var itemList:Array;
			var item:ProPopUpItem;
			var mask:ProPopUpMask;
			var length:int;
			if(childList==-1) {
				childList = ProPopUpChildList.COMMON;
			}
			modalColor = modalColor==-1?ProPopUpManager.modalColor:modalColor;
			modalAlpha = modalAlpha==-1?ProPopUpManager.modalAlpha:modalAlpha;
			if(modal) {
				//如果是模式窗口，将忽略childList参数
				childList = Math.max(childList, ProPopUpChildList.MODAL);
			}
			length = Math.min(childList+1, layerDic.length);
			for(i=0; i<length; i++) {
				itemList = layerDic[i];
				if(itemList==null) {
					continue;
				}
				for(j=0; j<itemList.length; j++) {
					item = itemList[j];
					childIndex++;
					if(item.modal) {
						childIndex++;
					}
				}
			}
			if(modal) {
				mask = RecycableFactory.newInstanceDirectly(ProPopUpMask);
				mask.width = stageWidth;
				mask.height = stageHeight;
				mask.graphics.clear();
				mask.graphics.beginFill(modalColor, modalAlpha);
				mask.graphics.drawRect(0, 0, stageWidth, stageHeight);
				mask.graphics.endFill();
				if (childIndex <= popupLayer.numChildren) {
					popupLayer.addChildAt(mask, childIndex);
					popupLayer.addChildAt(DisplayObject(window), childIndex+1);
				}else {
					popupLayer.addChild(mask);
					popupLayer.addChild(DisplayObject(window));
				}
				
			} else {
				if (childIndex <= popupLayer.numChildren) {
					popupLayer.addChildAt(DisplayObject(window), childIndex);
				}else {
					popupLayer.addChild(DisplayObject(window));
				}
				
			}
			item = RecycableFactory.newInstanceDirectly(ProPopUpItem);
			item.modal = modal;
			item.mask = mask;
			item.instance = DisplayObject(window);
			item.childList = childList;
			item.modalAlpha = modalAlpha;
			item.modalColor = modalColor;
			itemList = layerDic[childList];
			addPopupItem(item);
			if(itemList==null) {
				itemList = new Array();
				layerDic[childList] = itemList;
			}
			itemList.push(item);
			topOne = item.instance;
		}
		
		/**
		 * @param cls，要添加的弹出窗口类
		 * @param data，要显示的弹出窗口数据，当弹出窗口实现了IPopUpWindow接口时生效
		 * @param parent，父级窗口，此父级只是作为布局的参考，不是显示队列的从属关系
		 * @param modal，是否模态显示，模态显示下下层的不可点
		 * @param childList，在所有弹出窗口中的层级位置，当modal为true时忽略此参数
		 * @param point，弹出窗口的弹出位置，默认为null，表示居中显示
		 */ 
		public static function createPopup(	cls:Class, 
											data:Object=null, 
											modal:Boolean=false, 
											parent:DisplayObject=null, 
											point:Point=null, 
											childList:int=-1, 
											modalColor:int=-1, 
											modalAlpha:Number=-1	):IFlexDisplayObject {
			var popup:IFlexDisplayObject = RecycableFactory.newInstanceDirectly(cls);
			if(childList==-1) {
				childList = ProPopUpChildList.COMMON;
			}
			addPopup(popup, parent, modal, childList, modalColor, modalAlpha);
			if(point!=null) {
				popup.x = point.x;
				popup.y = point.y;
			} else if(popup.x==0 && popup.y==0) {
				centerPopUp(popup);
				if(popup is IPopUpWindow) {
					popup.y = Math.max(popup.y + IPopUpWindow(popup).offsetTop, 0); 
				}
			}
			if(popup is IPopUpWindow) {
				IPopUpWindow(popup).popUpData = data;
				IPopUpWindow(popup).onCreate();
			}
			return popup;
		}
		
		/**
		 * 创建一个与指定显示对象的相对层次关系固定的弹出窗口
		 * 被创建的弹出窗口始终在指定对象的上一层
		 * NOTE: 当topAt对象是非弹出窗口时，此方法与createPopup()方法等同
		 * @param cls，要添加的弹出窗口类
		 * @param data，要显示的弹出窗口数据，当弹出窗口实现了IPopUpWindow接口时生效
		 * @param top，要创建相对显示层级关系的窗口
		 * @param modal，是否模态显示，模态显示下下层的不可点
		 * @param childList，当topAt是非弹出窗口时，创建目标窗口的默认层级
		 */ 
		public static function createPopupTopAt(	cls:Class, 
													topAt:DisplayObject, 
													data:Object=null, 
													modal:Boolean=false, 
													childList:int=-1,
													modalColor:int=-1, 
													modalAlpha:Number=-1	):IFlexDisplayObject {
			var i:int;
			var j:int;
			var item:ProPopUpItem;
			var list:Array;
			var topAtItem:ProPopUpItem;
			var popup:IFlexDisplayObject;
			if(childList==-1) {
				childList = ProPopUpChildList.COMMON;
			}
			for(i=0; i<layerDic.length; i++) {
				list = layerDic[i];
				if(list==null) {
					continue;
				}
				for(j=list.length-1; j>=0; j--) {
					item = list[j];
					if(item.instance==topAt) {
						topAtItem = item;
						bringToFront(IFlexDisplayObject(topAtItem.instance));
						popup = createPopup(cls, data, modal, topAt, null, topAtItem.childList, modalColor, modalAlpha);
						topAtItem.topElement = popup;
						return popup;
					}
				}
			}
			return createPopup(cls, data, modal, topAt, null, childList, modalColor, modalAlpha);
		}
		
		/**
		 * 将指定弹出窗口置于相应弹出层的最上层
		 * NOTE: 此方法的最上层，只局限于当前窗口所处的弹出层的最上层，不能跨过childList的限制
		 */ 
		public static function bringToFront(popup:IFlexDisplayObject):void {
			var i:int;
			var j:int;
			var item:ProPopUpItem;
			var childList:Array;
			var childIndex:int;
			var targetItem:ProPopUpItem;
			for(i=0; i<layerDic.length; i++) {
				childList = layerDic[i];
				if(childList==null) {
					continue;
				}
				for(j=childList.length-1; j>=0; j--) {
					item = childList[j];
					if(item.instance==popup) {
						targetItem = item;
					}
					childIndex++;
					if(item.modal) {
						childIndex++;
					}
				}
				if(targetItem!=null) {
					topOne = targetItem.instance;
					if(targetItem.modal) {
						popupLayer.setChildIndex(targetItem.mask, Math.min(childIndex-1, popupLayer.numChildren));
					}
					popupLayer.setChildIndex(targetItem.instance, Math.min(childIndex-1, popupLayer.numChildren));
					childList.splice(childList.indexOf(targetItem), 1);
					childList.push(targetItem);
					if(targetItem.topElement) {
						bringToFront(targetItem.topElement);
					}
					return;
				}
			}
		}
		
		/**
		 * 居中显示弹出窗口
		 */ 
		public static function centerPopUp(popup:IFlexDisplayObject):void {
			if (popup is IInvalidating) {
				IInvalidating(popup).validateNow();
			}
			popup.x = int((stageWidth - popup.width)/2);
			popup.y = Math.max(int((stageHeight - popup.height)/2), 0);
		}
		
		/**
		 * 关闭相应的弹出窗口实例
		 */ 
		public static function hidePopup(popup:IFlexDisplayObject):void {
			var i:int;
			var j:int;
			var item:ProPopUpItem;
			var childList:Array;
			for(i=0; i<layerDic.length; i++) {
				childList = layerDic[i];
				if(childList==null) {
					continue;
				}
				for(j=childList.length-1; j>=0; j--) {
					item = childList[j];
					if(item.instance==popup) {
						childList.splice(j, 1);
						popupLayer.removeChild(item.instance);
						if(item.mask!=null) {
							popupLayer.removeChild(item.mask);
							RecycableFactory.recycleDirectly(item.mask);
						}
						if(item.instance is IPopUpWindow) {
							IPopUpWindow(item.instance).onRemove();
						}
						recyclePopupItem(item);
						return;
					}
				}
			}
		}
		
		/**
		 * 关闭由childList参数指定的弹出窗口层级的所有弹出窗口
		 */ 
		public static function hidePopupInChildList(childList:int):void {
			var itemList:Array = layerDic[childList];
			if(itemList!=null) {
				while (itemList.length>0) {
					hidePopup(IFlexDisplayObject(ProPopUpItem(itemList[0]).instance));
				}
			}
		}
		
		/**
		 *关闭所有弹出窗口 
		 */		
		public static function hideAllPopup():void {
			for each(var itemList:Array in layerDic) {
				if(itemList!=null) {
					while (itemList.length>0) {
						hidePopup(IFlexDisplayObject(ProPopUpItem(itemList[0]).instance));
					}
				}
			}
		}
		
		/**
		 * 关闭指定类的弹出窗口实例
		 */ 
		public static function hidePopupByClass(cls:Class):void {
			var i:int;
			var j:int;
			var item:ProPopUpItem;
			var childList:Array;
			for(i=0; i<layerDic.length; i++) {
				childList = layerDic[i];
				if(childList==null) {
					continue;
				}
				for(j=childList.length-1; j>=0; j--) {
					item = childList[j];
					if(item && item.instance is cls) {
						childList.splice(j, 1);
						popupLayer.removeChild(item.instance);
						if(item.mask!=null) {
							popupLayer.removeChild(item.mask);
							RecycableFactory.recycleDirectly(item.mask);
						}
						if(item.instance is IPopUpWindow) {
							IPopUpWindow(item.instance).onRemove();
						}
						recyclePopupItem(item);
					}
				}
			}
		}
		
		/**
		 * 指定显示对象的显示列表上层是否有模式窗口
		 * 主要用于在有模式窗口的情况下，对下层显示对象的一些快捷键功能的屏蔽，其他类似需求也可以通过此方法判断
		 */ 
		public static function hasModalPopupUpon(target:DisplayObject):Boolean {
			var i:int;
			var j:int;
			var item:ProPopUpItem;
			var childList:Array;
			for(i=layerDic.length-1; i>=0; i--) {
				childList = layerDic[i];
				if(childList==null) {
					continue;
				}
				for(j=childList.length-1; j>=0; j--) {
					item = childList[j];
					if(item.modal) {
						return true;
					}
				}
			}
			return false;
		}
		
		public static function getPopupsByTyep(cls:Class):Array {
			var arr:Array = [];
			for (var i:int = 0; i < popupLayer.numChildren; i++) {
				var child:DisplayObject = popupLayer.getChildAt(i);
				if (child is cls) {
					arr.push(child);
				}
			}
			return arr;
		}
		
		private static function popupUpHandler(event:MouseEvent):void {
			var popup:DisplayObject = DisplayObject(event.currentTarget);
			if(lastMouseDownPopup==popup) {
				if(topOne!=popup) {
					bringToFront(IFlexDisplayObject(popup));
				}
				lastMouseDownPopup = null;
			} else {
				lastMouseDownPopup = null;
			}
		}
		
		private static function popupDownHandler(event:MouseEvent):void {
			var popup:DisplayObject = DisplayObject(event.currentTarget);
			lastMouseDownPopup = popup;
		}
		
		private static function recyclePopupItem(item:ProPopUpItem):void {
			item.instance.removeEventListener(MouseEvent.MOUSE_DOWN, popupDownHandler);
			item.instance.removeEventListener(MouseEvent.MOUSE_UP, popupUpHandler);
			if(item.instance is IPopUpWindow && IPopUpWindow(item.instance).cacheSize>0) {
				if(RecycableFactory.getCacheSizeDirectly(item.instance)<IPopUpWindow(item.instance).cacheSize) {
					RecycableFactory.recycleDirectly(item.instance);
				}
			}
			item.instance = null;
			item.modal = false;
			item.mask = null;
			item.modalAlpha = -1;
			item.modalColor = -1;
			item.topElement = null;
			RecycableFactory.recycleDirectly(item);
		}
		
		private static function addPopupItem(item:ProPopUpItem):void {
			if(item.instance is UIComponent) {
				UIComponent(item.instance).isPopUp = true;
			}
			item.instance.addEventListener(MouseEvent.MOUSE_UP, popupUpHandler);
			item.instance.addEventListener(MouseEvent.MOUSE_DOWN, popupDownHandler);
		}
		
		/**
		 * remove the top poup by ESC.
		 * if top popup is model window, break;
		 * if top popup is ignore ESC, continue;
		 */ 
		private static function removeByEscKeyDown():void {
			var i:int;
			var j:int;
			var item:ProPopUpItem;
			var childList:Array;
			for(i=layerDic.length-1; i>=0; i--) {
				childList = layerDic[i];
				if(childList==null) {
					continue;
				}
				for(j=childList.length-1; j>=0; j--) {
					item = childList[j];
					if(item.instance is IPopUpWindow) {
						if(IPopUpWindow(item.instance).ignoreESC) {
							if(IPopUpWindow(item.instance).ignoreESCImmediately) {
								return;
							}
							continue;
						} else {
							childList.splice(j, 1);
							popupLayer.removeChild(item.instance);
							if(item.mask) {
								popupLayer.removeChild(item.mask);
								RecycableFactory.recycleDirectly(item.mask);
							}
							IPopUpWindow(item.instance).onRemove(true);
							recyclePopupItem(item);
						}
						return;
					} 
				}
			}
		}
		
	}
}