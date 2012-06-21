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
	import flashx.textLayout.debug.assert;
	import flashx.textLayout.formats.FormatValue;
	import flashx.textLayout.tlf_internal;
		
	use namespace tlf_internal;
	
	[ExcludeClass]
	/** A property description with a Number or a Percent as its value. @private */
	public class NumberOrPercentProperty extends Property
	{
		private var _minNumberValue:Number;
		private var _maxNumberValue:Number;
		private var _minPercentValue:Number;
		private var _maxPercentValue:Number;
		
		/** Value will be a % terminated string or a number */
		public function NumberOrPercentProperty(nameValue:String, defaultValue:Object, inherited:Boolean, category:String, minValue:Number, maxValue:Number, minPercentValue:String, maxPercentValue:String)
		{
			super(nameValue, defaultValue, inherited, category);
			
			// the nested properties don't need the true default
			_minNumberValue = minValue;
			_maxNumberValue = maxValue;
			_minPercentValue = toNumberIfPercent(minPercentValue);
			_maxPercentValue = toNumberIfPercent(maxPercentValue);
		}
		
		public function get minNumberValue():Number
		{ return _minNumberValue; }
		public function get maxNumberValue():Number
		{ return _maxNumberValue; } 
		public function get minPercentValue():Number
		{ return _minPercentValue; }
		public function get maxPercentValue():Number
		{ return _maxPercentValue; }
		
		static private function toNumberIfPercent(o:Object):Number
		{
			if (!(o is String))
				return NaN;
			var s:String = String(o);
			var len:int = s.length;
			
			return len != 0 && s.charAt(len-1) == "%" ? parseFloat(s) : NaN;
		}

		/** @private */
		public override function setHelper(currVal:*,newObject:*):*
		{ 
			if (newObject === null)
				newObject = undefined;
			
			if (newObject === undefined || newObject == FormatValue.INHERIT)
				return newObject;

			var newVal:Number = toNumberIfPercent(newObject);
			if (!isNaN(newVal))
			{
				if (checkLowerLimit() && newVal < _minPercentValue)
				{
					Property.errorHandler(this,newObject);
					return currVal;
				}
				if (checkUpperLimit() && newVal > _maxPercentValue)
				{
					Property.errorHandler(this,newObject);
					return currVal;
				}
				return newVal.toString()+"%";
			}

			newVal = parseFloat(newObject);
			// Nan --> return the current value
			if (isNaN(newVal))
			{
				Property.errorHandler(this,newObject);
				return currVal;
			}
			if (checkLowerLimit() && newVal < _minNumberValue)
			{
				Property.errorHandler(this,newObject);
				return currVal;
			}
			if (checkUpperLimit() && newVal > _maxNumberValue)
			{
				Property.errorHandler(this,newObject);
				return currVal;
			}
			return newVal;
		}
		
		/** @private */
		public override function hash(val:Object, seed:uint):uint
		{ 
			if (val == FormatValue.INHERIT)
				return UintProperty.doHash(inheritHashValue, seed);
			if (val is String)
				return StringProperty.doHash(String(val), seed);
			return NumberProperty.doHash(val as Number, seed);
		}
		
		public function computeActualPropertyValue(propertyValue:Object,percentInput:Number):Number
		{
			var percent:Number = toNumberIfPercent(propertyValue);
			if (isNaN(percent))
				return Number(propertyValue);
				
			// its a percent - calculate and clamp
			var rslt:Number =  percentInput * (percent / 100);
			if (rslt < _minNumberValue)
				return _minNumberValue;
			if (rslt > _maxNumberValue)
				return _maxNumberValue;
			return rslt;			
		}
	}
}
