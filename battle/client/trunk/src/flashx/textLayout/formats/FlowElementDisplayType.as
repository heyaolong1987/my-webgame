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
package flashx.textLayout.formats
{
[ExcludeClass]
	/**
	 * An enumeration to describe how a FlowElement should be treated when composed. 
	 * @see text.elements.FlowElement#display
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 * These APIs are still in prototype phase
	 * @private
	 */
	public final class FlowElementDisplayType 
	{
			/** Element appears inline in the text; it is placed in its parent's geometry context */
		public static const INLINE:String = "inline";
			/** Element floats with the text, but supplies its own geometry context (e.g., a sidebar or table) */
		public static const FLOAT:String = "float";	
	}
}
