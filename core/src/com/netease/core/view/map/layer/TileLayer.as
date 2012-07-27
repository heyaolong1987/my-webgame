package com.netease.core.view.map.layer{
	import com.netease.core.events.TileMouseEvent;
	import com.netease.core.interfaces.IPreciseClickAble;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 *
	 *@author heyaolong
	 *
	 *2012-1-1
	 */
	public class TileLayer extends Sprite implements IPreciseClickAble{
		private var _bmp:Bitmap=new Bitmap();
		private var _cacheBmp:Bitmap = new Bitmap();
		private var _nullBmpData:BitmapData;
		private var _tileWidth:int;
		private var _tileHeight:int;
		
		
		private var _showTileRow:int;
		private var _showTileCol:int;
		
		private var _loadTileRow:int;
		private var _loadTileCol:int;
		
		private var _showWidth:int;
		private var _showHeight:int;
		
		private var _loadWidth:int;
		private var _loadHeight:int;
		
		private var _startPoint:Point;
		private var _loadFunc:Function;
		private var _fillRect:Rectangle;
		private var _sTileCol:int;
		private var _sTileRow:int;
		private var _sTileX:int;
		private var _sTileY:int;
		
		private var _sx:int;
		private var _sy:int;
		
		private var _scrollX:int;
		private var _scrollY:int;
		private var _hasLoad:Array;
		private var _newHasLoad:Array;
		private var _cacheTileNum:int;
		
		/**
		 * 
		 * @param tileWidth
		 * @param tileHeight
		 * @param showTileRow
		 * @param showTileCol
		 * @param cacheTileNum
		 * @param loadFunc args: nowTileRow,nowTileCol,loadComplete
		 * 
		 */
		public function TileLayer(tileWidth:int,tileHeight:int,showTileRow:int,showTileCol:int,cacheTileNum:int,loadFunc:Function){
			_tileWidth = tileWidth;
			_tileHeight = tileHeight;
			_showTileCol = showTileCol;
			_showTileRow = showTileRow;
			
			_loadTileRow = _showTileRow+2;
			_loadTileCol = _showTileCol+2;
			
			_showWidth = _showTileCol*_tileWidth;
			_showHeight = _showTileRow*_tileHeight;
			_loadWidth = _loadTileCol*_tileWidth;
			_loadHeight = _loadTileRow*_tileHeight;
			_sx=-_tileWidth;
			_sy=-_tileHeight;
			_sTileX = -_tileWidth;
			_sTileY = -_tileHeight;
			_sTileRow = -1;
			_sTileCol = -1;
			_fillRect = new Rectangle(0,0,_tileWidth,_tileHeight);
			_cacheTileNum = cacheTileNum;
			_loadFunc = loadFunc;
			
			_hasLoad = new Array(_loadTileRow);
			_newHasLoad = new Array(_loadTileRow);
			
			for(var i:int=0;i<_loadTileRow;i++){
				_hasLoad[i] = new Array(_loadTileCol);
				_newHasLoad[i] = new Array(_loadTileCol);
				for(var j:int=0; j<_loadTileCol; j++){
					_hasLoad[i][j] = false;
					_newHasLoad[i][j] = false;
				}
			}
			_bmp.bitmapData = new BitmapData(_loadTileCol*_tileWidth,_loadTileRow*_tileHeight);
			_nullBmpData = new BitmapData(_tileWidth,_tileHeight);
			_bmp.x = -_tileWidth;
			_bmp.y = -_tileHeight;
			addChild(_bmp);
			addEventListener(MouseEvent.CLICK,onMouseClick);
			
		}
		private function onMouseClick(event:MouseEvent):void{
			dispatchEvent(new TileMouseEvent(TileMouseEvent.CLICK,new Point(event.localX,event.localY),new Point(event.localX-this._sx,event.localY-this._sy)));
		}
		public function set startPoint(value:Point):void{
			if(_startPoint&&value&&_startPoint.equals(value)){
				return;
			}
			_startPoint = value;
			onStartPointChanged();
		}
		protected function onStartPointChanged():void{
			var i:int,j:int,k:int,p:int;
			_sx = -_startPoint.x-_tileWidth;
			_sy = -_startPoint.y-_tileHeight;
			var newScrollX = (_sx-_sTileX)%_tileWidth;
			var newScrollY = (_sy-_sTileY)%_tileHeight;
			
			var newSTileRow:int =  (_startPoint.y+newScrollY)/_tileHeight-1;
			var newSTileCol:int =  (_startPoint.x+newScrollX)/_tileWidth-1;
			if(_sTileRow!=newSTileRow||_sTileCol!=newSTileCol){	
				var dTileRow:int = newSTileRow-_sTileRow;
				var dTileCol:int = newSTileCol-_sTileCol;
				k = dTileRow;
				for(var i=0;i<_loadTileRow;i++){
					p = dTileCol;
					for(var j=0;j<_loadTileCol;j++){
						if(k>=0&&k<_loadTileRow&&p>=0&&p<_loadTileCol){
							_newHasLoad[i][j] = _hasLoad[k][p];
						}
						else{
							_newHasLoad[i][j] = false;
						}
						p++;
					}
					k++;
				}
				var t:Array;
				t = _hasLoad;
				_hasLoad = _newHasLoad;
				_newHasLoad = t;
				_sTileRow = newSTileRow;
				_sTileCol = newSTileCol;
				_bmp.bitmapData.scroll(-dTileCol*_tileWidth,-dTileRow*_tileHeight);
			}
			var nowTileRow:int = _sTileRow;
			for(var i:int=0;i<_loadTileRow;i++){
				var nowTileCol:int = _sTileCol;
				for(var j:int=0;j<_loadTileCol;j++){
					if(_hasLoad[i][j]==false){
						_bmp.bitmapData.copyPixels(_nullBmpData,_fillRect,new Point(j*_tileWidth,i*_tileHeight));
						if(nowTileRow>=0&&nowTileCol>=0){
							_loadFunc.apply(this,[nowTileRow,nowTileCol,loadComplete]);
						}
					}
					nowTileCol++;
				}
				nowTileRow++;
			}
			_sTileX = _sTileCol*_tileWidth;
			_sTileY = _sTileRow*_tileHeight;
			
			_bmp.x = newScrollX-_tileWidth;
			_bmp.y = newScrollY-_tileHeight;
			
			trace(_sx,_sy,_sTileX,_sTileY,newScrollX,newScrollY,newSTileRow,newSTileCol);
			
		}
		protected function loadComplete(rowNum:int,colNum:int,res:Bitmap):void{	
			var a:int = (rowNum-_sTileRow);
			if(a<0||a>=_loadTileRow){
				return;
			}
			var b:int = (colNum-_sTileCol);
			if(b<0&&b>=_loadTileCol){
				return;
			}
			_hasLoad[a][b] = true;
			res.x = b*_tileWidth;
			res.y = a*_tileHeight;
			_bmp.bitmapData.copyPixels(res.bitmapData,_fillRect,new Point(b*_tileWidth,a*_tileHeight));
		}
		public function get startPoint():Point{
			return _startPoint;
		}
		
	}
}