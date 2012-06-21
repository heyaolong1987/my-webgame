package com.netease.core.map.cloud{
		import flash.display.Bitmap;
		import flash.display.BitmapData;
		import flash.display.Sprite;
		import flash.events.Event;
		import flash.geom.Point;
		import flash.geom.Rectangle;
		
		/**
		 * @author heyaolong
		 * 
		 * 2011-12-31
		 */ 
		public class CloudLayer extends Sprite{
			
			/**正在刷新viewrect并渲染**/
			private var _isValidating:Boolean;
			private var _nowFrame:int=0;
			
			private var _cloudWidth:int;
			private var _cloudHeight:int;
			
			private var _showWidth:int;
			private var _showHeight:int;
			
			private var _cloudRowNum:int;
			private var _cloudColNum:int;
			private var _cloudLayer:Sprite = new Sprite();
			private var _cloudArr:Array = new Array(3);
			private var _xFrameMoveSpeed:int;
			private var _yFrameMoveSpeed:int;
			
			private var _centerPixelPoint:Point;
			private var _cloudBmpData:BitmapData;
			private var _scale:Number = 1;
			
			public function CloudLayer(cloudBmpData:BitmapData,cloudWidth:int,cloudHeight:int,showWidth:int,showHeight:int,xFrameMoveSpeed:Number,yFrameMoveSpeed:Number)
			{
				super();
				mouseEnabled = false;
				mouseChildren = false;
				_cloudBmpData = cloudBmpData;
				_cloudWidth = cloudWidth;
				_cloudHeight = cloudHeight;
				_showWidth = showWidth;
				_showHeight = showHeight;
				
				_cloudRowNum = Math.ceil(_showHeight/_cloudHeight)+1;
				_cloudColNum = Math.ceil(_showWidth/_cloudWidth)+1;
				
				_xFrameMoveSpeed = xFrameMoveSpeed;
				_yFrameMoveSpeed = yFrameMoveSpeed;
				
				for(var i:int=0; i<_cloudRowNum; i++){
					_cloudArr[i] = new Array(_cloudColNum);
					for(var j:int=0; j<_cloudColNum; j++){
						_cloudArr[i][j] = new Bitmap(_cloudBmpData);
						Bitmap(_cloudArr[i][j]).x = j*_cloudWidth;
						Bitmap(_cloudArr[i][j]).y = i*_cloudHeight;
						_cloudLayer.addChild(_cloudArr[i][j]);
					}
				}
				addChild(_cloudLayer);
			}
			
			public override function set visible(value:Boolean):void {
				super.visible = value;
				//
				if(value) {
					addEventListener(Event.ENTER_FRAME,onEnterFrame);
				}
				else {
					removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				}
			}
			
			protected function onEnterFrame(event:Event):void{
				validateItems();
				_nowFrame++;
			}
			
			public function set centerPixelPoint(value:Point):void{
				_centerPixelPoint = value;
				
				validateItems();
			}
			public function get centerPixelPoint():Point{
				return _centerPixelPoint;
			}
			protected function validateItems():void {
				if(_centerPixelPoint){
					_cloudLayer.x = _centerPixelPoint.x*_scale-(_nowFrame*_xFrameMoveSpeed+_centerPixelPoint.x-_showWidth/2)%_cloudWidth-_showWidth/2;						
					_cloudLayer.y = _centerPixelPoint.y*_scale-(_nowFrame*_yFrameMoveSpeed+_centerPixelPoint.y-_showHeight/2)%_cloudHeight-_showHeight/2;
				}	
			}
			public function set scale(value:Number):void{
				_scale = value;
			}
			public function get scale():Number{
				return _scale;
			}
		}
	}