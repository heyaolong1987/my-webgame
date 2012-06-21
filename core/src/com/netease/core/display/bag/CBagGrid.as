package com.netease.core.display.bag {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.listClasses.ListBase;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import com.netease.core.events.CDragEvent;
	import com.netease.core.manager.CDragManager;
	import com.netease.core.display.cell.BaseCell;
	
	/**
	 * @author heyaolong
	 * 
	 * 2011-10-28
	 */ 
	public class CBagGrid extends UIComponent{
		protected var _source:ArrayCollection;
		protected var _sourceChanged:Boolean;
		protected var _cellRenderer:Class;
		
		protected var _cellItems:Array;
		
		protected var _cellWidth:int;
		protected var _cellHeight:int;
		
		
		protected var _horizontalGap:int;
		protected var _verticalGap:int;
		
		protected var _dataChanged:Boolean=true;
		protected var _cellChanged:Boolean=true;
		protected var _totalCountChanged:Boolean=true;
		
		protected var _rowCount:int;
		protected var _columnCount:int;
		protected var _totalCount:int;
		
		protected var _currentPage:int;
		protected var _enableCellNum;
		
		protected var _selectedItem:BaseCell;
		protected var _selectionChanged:Boolean=true;
		protected var _dragEnabled:Boolean;
		public function CBagGrid()
		{
			super();
			addEventListener(MouseEvent.CLICK,mouseClickHandler);
			addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			invalidateProperties();
		}
		protected function mouseClickHandler(event:MouseEvent):void{
			
		}
		protected function mouseDownHandler(event:MouseEvent):void{
			if(event.target is BaseCell){
				_selectedItem = event.target as BaseCell;
			}
			if (dragEnabled && !CDragManager.getInstance().isDragging)
			{
				var dragEvent:CDragEvent = new CDragEvent(CDragEvent.DRAG_START,this,event.ctrlKey,event.shiftKey,event.altKey);
				dragEvent.localX = event.stageX;
				dragEvent.localY = event.stageY;
				
				dragEvent.buttonDown = true;
				dispatchEvent(dragEvent);
			}
		}
		
		/**
		 *格子宽度 
		 * @param value
		 * 
		 */
		public function set cellWidth(value:int):void{
			if(_cellWidth!=value){
				_cellWidth = value;
				cellChanged();
			}
		}
		/**
		 *格子宽度 
		 * @return 
		 * 
		 */
		public function get cellWidth():int{
			return _cellWidth;
		}
		
		/**
		 *格子高度 
		 * @param value
		 * 
		 */
		public function set cellHeight(value:int):void{
			if(_cellHeight!=value){
				_cellHeight = value;
				cellChanged();
			}
		}
		/**
		 *格子高度 
		 * @return 
		 * 
		 */
		public function get cellHeight():int{
			return _cellHeight;
		}
		
		/**
		 *水平间距 
		 * @return 
		 * 
		 */
		public function get horizontalGap():int {
			return _horizontalGap;
		}
		/**
		 *水平间距 
		 * @return 
		 * 
		 */
		public function set horizontalGap(value:int):void {
			if (_horizontalGap != value) {
				_horizontalGap = value;
				cellChanged();
			}
		}
		/**
		 *垂直间距 
		 * @return 
		 * 
		 */
		public function get verticalGap():int {
			return _verticalGap;
		}
		/**
		 *垂直间距 
		 * @return 
		 * 
		 */
		public function set verticalGap(value:int):void {
			if (_verticalGap != value) {
				_verticalGap = value;
				cellChanged();
			}
		}
		/**
		 *列数 
		 * @param value
		 * 
		 */
		public function set columnCount(value:int):void{
			if(_columnCount != value){
				_columnCount = value;
				setTotalCount();
			}
			
		}
		/**
		 *列数 
		 * @return
		 * 
		 */
		public function get columnCount():int{
			return _columnCount;
		}
		
		/**
		 *行数 
		 * @param value
		 * 
		 */
		public function set rowCount(value:int):void{
			if(_rowCount != value){
				_rowCount = value;
				setTotalCount();
			}
			
		}
		/**
		 *行数 
		 * @return
		 * 
		 */
		public function get rowCount():int{
			return _rowCount;
		}
		
		protected function setTotalCount():void{
			_totalCount = _rowCount*_columnCount;
			_totalCountChanged = true;
			_dataChanged = true;
			invalidateDisplayList();
		}
		public function set cellRenderer(value:Class):void{
			if(_cellRenderer!=value){
				_cellRenderer = value;
				cellChanged();
			}
		}
		public function get cellRenderer():Class{
			return _cellRenderer;
		}
		
		public function set currentPage(value:int):void{
			if(_currentPage!=value){
				_currentPage = value;
				_dataChanged = true;
				invalidateDisplayList();
			}
		}
		public function get currentPage():int{
			return _currentPage;
		}
		/**
		 *有效的格子数 
		 * @param value
		 * 
		 */
		public function set enableCellNum(value:int):void{
			if(_enableCellNum!=value){
				_enableCellNum = value;
				//cellChanged();
			}	
		}
		/**
		 * 有效的格子数 
		 * @return 
		 * 
		 */
		public function get enableCellNum():int{
			return _enableCellNum;
		}
		
		public function set dataProvider(value:ArrayCollection):void{
			if(_source){
				_source.removeEventListener(CollectionEvent.COLLECTION_CHANGE,sourceChangeHandler);
			}
			if(value){
				_source = value;
			}
			else{
				_source = new ArrayCollection([]);
			}
			_source = value;
			_source.addEventListener(CollectionEvent.COLLECTION_CHANGE,sourceChangeHandler);
			clearSelectionData();
			sourceChangeHandler(null);
		}
		public function get dataProvider():ArrayCollection{
			return _source;
		}
		
		
		
		/**
		 *清空选择的数据 
		 * 
		 */
		protected function clearSelectionData():void{
			_selectedItem = null;
		}
		/**
		 *数据源发生改变 
		 * @param event
		 * 
		 */
		protected function sourceChangeHandler(event:CollectionEvent=null):void {
			_dataChanged = true;
			invalidateDisplayList();
		}
		override protected function measure():void{
			super.measure();
			measuredWidth = cellWidth*columnCount+horizontalGap*(columnCount-1);
			measuredMinWidth = cellWidth*columnCount+horizontalGap*(columnCount-1);
			measuredHeight = cellHeight*rowCount+verticalGap*(rowCount-1);
			measuredMinHeight = cellHeight*rowCount+verticalGap*(rowCount-1);ListBase
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			trace(this.name+ " updateDisplayList");
			if(_totalCountChanged){
				createCells();
				_totalCountChanged = false;
			}
			if(_dataChanged){
				setCellsData();
				_dataChanged = false;
			}
			if(_cellChanged){
				layoutCells();
				_cellChanged = false;
			}
		}
		protected function setCellsData():void{
			trace(this.name +" setCellsData");
			if(cellRenderer){
				var nowIndex:int = _currentPage*_totalCount;
				var sourceLen:int = _source.length;
				var cell:BaseCell;
				var i:int;
				for(i=0; i<_totalCount; i++){
					cell = _cellItems[i];
					cell.cellIndex = nowIndex;
					if(nowIndex<sourceLen){
						cell.data = _source.getItemAt(nowIndex);
					}
					else{
						cell.data = null;
					}
					nowIndex++;
				}
			}
		}
		protected function createCells():void{
			trace(this.name +" createCells");
			if(cellRenderer){
				var i:int;
				var cell:BaseCell;
				_cellItems = [];
				for(i=0; i<_totalCount; i++){
					cell = new cellRenderer();
					_cellItems.push(cell);
					addChild(cell);
				}
			}
		}
		
		protected function layoutCells():void{
			trace(this.name +" layoutCells");
			if(_cellItems){
				var i:int;
				var j:int;
				var k:int=0;
				var nowX:int;
				var nowY:int;
				var addX:int = cellWidth+horizontalGap;
				var addY:int = cellHeight+verticalGap;
				var cell:BaseCell;
				for(i=0; i<_rowCount; i++){
					for(j=0; j<_columnCount; j++){
						cell = _cellItems[k];
						cell.x = nowX;
						cell.y = nowY;
						cell.cellWidth = cellWidth;
						cell.cellHeight = cellHeight;
						k++;
						nowX +=addX;
					}
					nowX = 0;
					nowY += addY;
				}
			}
		}
		protected function cellChanged():void{
			_cellChanged = true;
			invalidateDisplayList();
		}
		
		
		
		public function get dragImage():Bitmap{
			var bitmap:Bitmap = new Bitmap;
			bitmap.bitmapData = _selectedItem.icon.bitmapData;
			return bitmap;
		}
		public function set dragEnabled(value:Boolean):void{
			if(_dragEnabled!=value){
				_dragEnabled = value;
				if(value == false){
					removeEventListener(CDragEvent.DRAG_START, dragStartHandler);
					removeEventListener(CDragEvent.DRAG_COMPLETE,dragCompleteHandler);
				}
				else{
					addEventListener(CDragEvent.DRAG_START, dragStartHandler);
					addEventListener(CDragEvent.DRAG_COMPLETE, dragCompleteHandler);
				}
			}
		}
		
		protected function dragStartHandler(event:CDragEvent):void
		{
			CDragManager.getInstance().doDrag(this,null, event, dragImage,
				0, 0, 0.5);
		}
		protected function dragEnterHandler(event:CDragEvent):void
		{
			if (enabled)
			{
				//	CDragManager.acceptDragDrop(this);
				return;
			}
		}
		
		protected function dragOverHandler(event:CDragEvent):void
		{
			if (enabled)
			{	
				return;
			}
		}
		
		protected function dragExitHandler(event:CDragEvent):void
		{
		}
		
		protected function dragDropHandler(event:CDragEvent):void
		{   			
			if (enabled)
			{
				if (event.dragContainer == this)
				{
					
				}
			}
			
		}
		
		protected function dragCompleteHandler(event:CDragEvent):void
		{
			if (event.relatedObject != this)
			{
				
			}
		}
		
		public function get dragEnabled():Boolean{
			return _dragEnabled;
		}
	}
}