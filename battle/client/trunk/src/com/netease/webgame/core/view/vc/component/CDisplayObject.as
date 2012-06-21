package com.netease.webgame.core.view.vc.component {
	
	import com.netease.flash.common.net.PoolResLoader;
	import com.netease.flash.common.net.ResLoaderEvent;
	import com.netease.webgame.core.interfaces.ICToolTip;
	import com.netease.webgame.core.manager.CBitmapDataManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Matrix;
	
	import mx.managers.ToolTipManager;

	/**
	 * 基于flex框架的显示对象
	 * source对象支持bitmap,bitmapData,sprite,url
	 * bitmapData绘制时布局说明：
	 * 		如果显式地设定了contentWidth和contentHeight时，绘制大小根据指定数值绘制
	 * 		否则，按组件大小绘制，如果未显式设定组件大小，则按实际大小绘制
	 * 		现在只支持居中对齐，如果显式设置了组件大小，则根据组件大小布局，否则与左上角对齐
	 * @author zhp
	 */	
	public class CDisplayObject extends DisplayObject implements ICToolTip{
		
		/**
		 * 注册点 左上角
		 */
		public static const TOP_LEFT:int = 0;
		/**
		 * 注册点 底部中心
		 */
		public static const BOTTOM_MIDDLE:int = 1;
		
		protected var _source:Object;
		protected var _sourceLoader:PoolResLoader;
		protected var _sourceClassName:String;
		
		/**
		 * source如果是url，加载完成后更新为对应的bitmapdata 
		 */		
		protected var _sourceUrlBitmapData:BitmapData;
		
		/**
		 * 默认的图片.主要用于:如果资源是URL,则在URL加载完成前,加载失败后,显示此图片
		 * 支持的类型为:BitmapData, DisplayObject
		 */		
		protected var _defaultSource:Object;
		
		protected var _contentWidth:int;
		protected var _contentHeight:int;
		
		protected var _contentRevertX:int = 1;
		protected var _contentRevertY:int = 1;
		
		/**
		 * 是否启用自动缩放，当图片大小与组件大小不一致时生效
		 */ 
		protected var _scaleContent:Boolean = true;
		
		/**
		 * 是否保持高宽比，当scaleContent为true时生效，否则忽略此参数
		 */ 
		protected var _maintainAspectRatio:Boolean = true;
		
		/**
		 * 垂直对齐方式
		 */ 
		protected var _verticalAlign:String;
		
		/**
		 * 水平对齐方式
		 */ 
		protected var _horizontalAlign:String;
		
		protected var _regPointType:int = 0;
		
		protected var _sourceChild:DisplayObject;
		
		public function CDisplayObject(){
			super();
		}
		
		/**
		 * 当由数据提供源提供的显示资源不存在或者加载失败的情况下，使用的默认资源
		 */ 
		public function set defaultSource(value:Object):void {
			_defaultSource = value;
		}
		
		public function get contentWidth():int {
			return _contentWidth;
		}
		
		public function set contentWidth(value:int):void {
			_contentWidth = value;
			invalidateDisplayList();
		}
		
		public function get contentHeight():int {
			return _contentHeight;
		}
		
		public function set scaleContent(value:Boolean):void {
			_scaleContent = value;
			invalidateDisplayList();
		}
		
		public function get scaleContent():Boolean {
			return _scaleContent;
		}
		
		public function set contentRevertX(value:int):void {
			_contentRevertX = value;
			invalidateDisplayList();
		}
		
		public function set contentRevertY(value:int):void {
			_contentRevertY = value;
			invalidateDisplayList();
		}

		public function set contentHeight(value:int):void {
			_contentHeight = value;
			invalidateDisplayList();
		}
		
		public function set toolTipData(value:Object):void {
			_toolTipData = value;
			invalidateProperties();
		}
		public function get toolTipData():Object {
			return _toolTipData;
		}
		public function set toolTipDataFunction(value:Function):void {
			_toolTipDataFunction = value;
			invalidateProperties();
		}
		
		public function get toolTipDataFunction():Function {
			return _toolTipDataFunction;
		}
		public function registerToolTip(tipData:Object, tipClass:Class=null, tipFunction:Function=null, layoutDirection:int=0, showDelay:int=200):void {
			_toolTipData = tipData;
			_toolTipClass = tipClass;
			_toolTipDataFunction = tipFunction;
			_toolTipShowDelay = showDelay;
			_toolTipLayoutDirection = layoutDirection;
			invalidateProperties();
		}
		
		public function set source(value:Object):void {
			_source = value;
			_sourceUrlBitmapData = null;
			invalidateSize();
			invalidateDisplayList();
		}
		
		public function get source():Object {
			return _source;
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			if(_toolTipData==null && _toolTipDataFunction==null){
				CToolTipManager.getInstance().unRegisterToolTip(this);
			} else{
				CToolTipManager.getInstance().registerToolTip(this);
			}
		}
		
		override protected function measure():void {
			if (contentHeight > 0 && contentWidth > 0) {
				measuredHeight = measuredMinHeight = contentHeight;
				measuredWidth = measuredMinWidth = contentWidth;
			}else if (_source is BitmapData) {
				measuredHeight = measuredMinHeight = BitmapData(_source).height;
				measuredWidth = measuredMinWidth = BitmapData(_source).width;
			}else if (_source is DisplayObject) {
				measuredHeight = measuredMinHeight = DisplayObject(_source).height;
				measuredWidth = measuredMinWidth = DisplayObject(_source).width;
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var bitmapData:BitmapData;
			graphics.clear();
			if(_sourceLoader!=null) {
				_sourceLoader.removeEventListener(ResLoaderEvent.RES_LOADED, resLoadComplete);
				_sourceLoader.close();
				_sourceLoader = null;
			}
			if(_sourceChild!=null) {
				removeChild(_sourceChild);
				if(_sourceChild is MovieClip) {
					MovieClip(_sourceChild).stop();
				}
				_sourceChild = null;
			}
			if(_source is BitmapData) {
				bitmapData = BitmapData(_source);
			} else if(_source is String) {
				bitmapData = _sourceUrlBitmapData;//BitmapDataManager.getInstance().getBitmap(_source);
				if(bitmapData==null) {
					//如果资源是图片,在加载前显示默认的图;在加载完成后显示为原图片,
					//若加载失败则一直显示此图
					_sourceLoader = new PoolResLoader(String(_source), false);
					_sourceLoader.addEventListener(ResLoaderEvent.RES_LOADED, resLoadComplete);
					_sourceLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, resLoadError);
					_sourceLoader.addEventListener(IOErrorEvent.IO_ERROR, resLoadError);
					_sourceLoader.load();
					
					if (_defaultSource) {
						if (_defaultSource is BitmapData) {
							bitmapData = BitmapData(_defaultSource);
						}else if (_defaultSource is DisplayObject) {
							_sourceChild = DisplayObject(_source);
							if(_regPointType==TOP_LEFT) {
								_sourceChild.x = 0;
								_sourceChild.y = 0;
							} else if(_regPointType==BOTTOM_MIDDLE) {
								_sourceChild.x = _sourceChild.width/2;
								_sourceChild.y = _sourceChild.height;
							}
							addChild(_sourceChild);
							setActualSize(_sourceChild.width, _sourceChild.height);
							return;
						}
					}
				} 
			} else if(_source is DisplayObject) {
				_sourceChild = DisplayObject(_source);
				if(_regPointType==TOP_LEFT) {
					_sourceChild.x = 0;
					_sourceChild.y = 0;
				} else if(_regPointType==BOTTOM_MIDDLE) {
					_sourceChild.x = _sourceChild.width/2;
					_sourceChild.y = _sourceChild.height;
				}
				if (contentHeight > 0 && contentWidth > 0) {
					_sourceChild.height = contentHeight;
					_sourceChild.width = contentWidth;
				}
				addChild(_sourceChild);
				setActualSize(_sourceChild.width, _sourceChild.height);
				return;
			} else if(_source is Class) {
				_sourceChild = new _source();
				if(_regPointType==TOP_LEFT) {
					_sourceChild.x = 0;
					_sourceChild.y = 0;
				} else if(_regPointType==BOTTOM_MIDDLE) {
					_sourceChild.x = _sourceChild.width/2;
					_sourceChild.y = _sourceChild.height;
				}
				if (contentHeight > 0 && contentWidth > 0) {
					_sourceChild.height = contentHeight;
					_sourceChild.width = contentWidth;
				}
				addChild(_sourceChild);
				return;
			}
			if(bitmapData!=null) {
				var matrix:Matrix = new Matrix();;
				if(_scaleContent) {
					if(contentWidth>0 && contentHeight>0) {
						matrix.a = contentWidth/bitmapData.width;
						matrix.d = contentHeight/bitmapData.height;
						if(_maintainAspectRatio) {
							matrix.a = Math.min(matrix.a, matrix.d, 1);
							matrix.d = matrix.a;
						}
						if(unscaledWidth>0 && unscaledHeight>0) {
							matrix.tx = (unscaledWidth - bitmapData.width * matrix.a) / 2;
							matrix.ty = (unscaledHeight - bitmapData.height * matrix.d) / 2;
						} else {
							matrix.tx = 0;
							matrix.ty = 0;
						}
					} else if(unscaledWidth>0 && unscaledHeight>0) {
						matrix.a = unscaledWidth/bitmapData.width;
						matrix.d = unscaledHeight/bitmapData.height;
						if(_maintainAspectRatio) {
							matrix.a = Math.min(matrix.a, matrix.d, 1);
							matrix.d = matrix.a;
						}
						matrix.tx = (unscaledWidth - bitmapData.width * matrix.a) / 2;
						matrix.ty = (unscaledHeight - bitmapData.height * matrix.d) / 2;
					} else {
						matrix.a = 1;
						matrix.d = 1;
						matrix.tx = 0;
						matrix.ty = 0;
					}
					matrix.a *= _contentRevertX;
					matrix.d *= _contentRevertY;
					graphics.beginBitmapFill(bitmapData, matrix, true, true);
					graphics.drawRect(matrix.tx, matrix.ty, Math.abs(bitmapData.width*matrix.a), Math.abs(bitmapData.height*matrix.d));
					graphics.endFill();
				} else {
					matrix.a = 1;
					matrix.d = 1;
					if(contentWidth>0 && contentHeight>0) {
						if(unscaledWidth>0 && unscaledHeight>0) {
							matrix.tx = (unscaledWidth-contentWidth)/2;
							matrix.ty = (unscaledHeight-contentHeight)/2;
						} else {
							matrix.tx = 0;
							matrix.ty = 0;
						}
					} else if(unscaledWidth>0 && unscaledHeight>0) {
						matrix.tx = (unscaledWidth-bitmapData.width)/2;;
						matrix.ty = (unscaledHeight-bitmapData.height)/2;
					} else {
						matrix.tx = 0;
						matrix.ty = 0;
					}
					matrix.a *= _contentRevertX;
					matrix.d *= _contentRevertY;
					graphics.beginBitmapFill(bitmapData, null, true, true);
					graphics.drawRect(0, 0, Math.abs(bitmapData.width*matrix.a), Math.abs(bitmapData.height*matrix.d));
					graphics.endFill();
					setActualSize(bitmapData.width, bitmapData.height);
				}
			}
		}
		
		protected function resLoadComplete(event:ResLoaderEvent):void {
			event.target.removeEventListener(ResLoaderEvent.RES_LOADED, resLoadComplete);
			event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, resLoadError);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, resLoadError);
			if(event.loaderinfo.content is Bitmap) {
				_sourceUrlBitmapData = Bitmap(event.loaderinfo.content).bitmapData;
//				BitmapDataManager.getInstance().registerBitmap(event.url, Bitmap(event.loaderinfo.content).bitmapData);
				invalidateDisplayList();
			} else {
				if (_sourceClassName) {
					//如果加载的是SWF,同是链接标记符有的话则从SWF中读取元件
					source = PoolResLoader(event.target).getClass(_sourceClassName);
					invalidateDisplayList();
				}
				Console.info("Load content No Cache:" + event.url);
			}
		}
		
		protected function resLoadError(event:Event):void {
			event.target.removeEventListener(ResLoaderEvent.RES_LOADED, resLoadComplete);
			event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, resLoadError);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, resLoadError);
		}
	}
}