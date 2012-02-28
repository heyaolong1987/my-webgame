////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2008-2009 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
//////////////////////////////////////////////////////////////////////////////////
package flashx.textLayout.compose
{
	import flash.geom.Rectangle;
	
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.tlf_internal;

	use namespace tlf_internal;
		
	[ExcludeClass]
	/** Helper class for implementations of IParcelList
	 * 
	 * @private
	 */
	public class Parcel extends Rectangle
	{
		public static const TOP_OF_COLUMN:int = 1;
		public static const BOT_OF_COLUMN:int = 2;
		public static const FULL_COLUMN:int = 3;
		
		/** Constructor. */
		public function Parcel(x:Number, y:Number, width:Number, height:Number, cont:ContainerController, col:int, colCoverage:int)
		{
			super(x,y,width,height);
			_controller   = cont;
			_column       =  col;
			_columnCoverage = colCoverage;
			_fitAny	  = false;
			_composeToPosition = false;
		}
		
		public function initialize(x:Number, y:Number, width:Number, height:Number, cont:ContainerController, col:int, colCoverage:int):Parcel
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			
			_controller   = cont;
			_column       =  col;
			_columnCoverage = colCoverage;
			_fitAny	  = false;
			_composeToPosition = false;
			
			return this;
		}
		
		private var _controller:ContainerController;
		private var _columnCoverage:int;
		private var _column:int;
		private var _fitAny:Boolean;
		private var _composeToPosition:Boolean;
		
		/** prevent any leaks. @private */
		tlf_internal function releaseAnyReferences():void
		{
			_controller = null;
		}
		
		public function replaceBounds(r:Rectangle):void
		{
			this.x = r.x;
			this.y = r.y;
			this.width = r.width;
			this.height = r.height;
		}
		
		public function get controller():ContainerController
		{ return _controller; }

		public function get topOfColumn():Boolean
		{ return (_columnCoverage&TOP_OF_COLUMN) == TOP_OF_COLUMN; }
		/** describes how this parcel covers its source column */
		public function get columnCoverage():int
		{ return _columnCoverage; }
		public function set columnCoverage(val:int):void
		{ _columnCoverage = val; }
		/** column number in the container */
		public function get column():int
		{ return _column; }
		public function get fitAny():Boolean
		{ return _fitAny; }
		public function set fitAny(value:Boolean):void
		{ _fitAny = value; }
		public function get composeToPosition():Boolean
		{ return _composeToPosition; }
		public function set composeToPosition(value:Boolean):void
		{ _composeToPosition = value; }
		/** Do explicit line breaking (no wrapping) */
		public function get measureWidth():Boolean
		{ return controller.measureWidth; }
		public function get measureHeight():Boolean
		{ return controller.measureHeight; }

	}
}
