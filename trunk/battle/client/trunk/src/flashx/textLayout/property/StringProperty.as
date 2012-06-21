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
package flashx.textLayout.property
{
	import flashx.textLayout.tlf_internal;
		
	use namespace tlf_internal;
	
	[ExcludeClass]
	/** A property description with a String as its value @private */
	public class StringProperty extends Property
	{
		public function StringProperty(nameValue:String, defaultValue:String, inherited:Boolean, category:String)
		{
			super(nameValue, defaultValue, inherited, category);
		}
		
		/** @private */
		public override function setHelper(currVal:*,newObject:*):*
		{ 
			if (newObject === null)
				newObject = undefined;
			
			if (newObject === undefined || newObject is String)
				return newObject;
			
			Property.errorHandler(this,newObject);
			return currVal;	
		}	
		
		/** @private */
		public override function hash(val:Object, seed:uint):uint
		{ 
			return doHash(val as String, seed);
		}
		
		/** @private */
		tlf_internal static function doHash(val:String, seed:uint):uint
		{
			if (val == null)
				return seed;
				
			var len:uint = val.length;
			var hash:uint = seed;

			// Incrementally hash integers composed of pairs of character codes in the string
			for (var ix:uint=0; ix<len/2; ix++)
			{
				hash = UintProperty.doHash((val.charCodeAt(2*ix) << 16) | val.charCodeAt(2*ix+1), hash);
			}
			
			// Handle last character code in an odd-length string
			if (len % 2 != 0)
				hash = UintProperty.doHash (val.charCodeAt(len-1), hash);
			
			return hash;
		}
	}
}
