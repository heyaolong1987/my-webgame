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
package flashx.textLayout.elements
{
	import flashx.textLayout.debug.assert;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.formats.TextLayoutFormatValueHolder;
	import flashx.textLayout.tlf_internal;
	
	use namespace tlf_internal;

	[ExcludeClass]
	/** This class extends TextLayoutFormatValueHolder and add capabilities to hold privateData and userStyles.  @private */
	public class FlowValueHolder extends TextLayoutFormatValueHolder
	{
		private var _userStyles:Object;
		private var _privateData:Object;
		
		public function FlowValueHolder(initialValues:FlowValueHolder = null)
		{
			super(initialValues);
			initialize(initialValues);
		}
		
		private function initialize(initialValues:FlowValueHolder):void
		{
			if (initialValues)
			{
				for (var s:String in initialValues.userStyles)
					writableUserStyles()[s] = initialValues.userStyles[s];
				for (s in initialValues.privateData)
					writablePrivateData()[s] = initialValues.privateData[s];
			}
		}

		private function writableUserStyles():Object
		{ 
			if (_userStyles == null)
				_userStyles = new Object();
			return _userStyles;
		}
			
		public function get userStyles():Object
		{ return _userStyles; }
		public function set userStyles(val:Object):void
		{ _userStyles = val; }

		public function getUserStyle(styleProp:String):*
		{ return _userStyles ? _userStyles[styleProp] : undefined; }
		public function setUserStyle(styleProp:String,newValue:*):void
		{
			CONFIG::debug { assert(TextLayoutFormat.description[styleProp] === undefined,"bad call to setUserStyle"); }
			if (newValue === undefined)
			{
				if (_userStyles)
					delete _userStyles[styleProp];
			}
			else
				writableUserStyles()[styleProp] = newValue;
		}

		private function writablePrivateData():Object
		{
			if (_privateData == null)
				_privateData = new Object();
			return _privateData;
		}

		public function get privateData():Object
		{ return _privateData; }
		public function set privateData(val:Object):void
		{ _privateData = val; }

		public function getPrivateData(styleProp:String):*
		{ return _privateData ? _privateData[styleProp] : undefined; }

		public function setPrivateData(styleProp:String,newValue:*):void
		{
			if (newValue === undefined)
			{
				if (_privateData)
					delete _privateData[styleProp];
			}
			else
				writablePrivateData()[styleProp] = newValue;
		}
	}
}
