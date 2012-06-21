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
	import flash.text.engine.TextElement;
	
	/** 
	 * The TabElement class represents a &lt;tab/&gt; in the text flow. You assign tab stops as an array of TabStopFormat objects to the 
	 * <code>ParagraphElement.tabStops</code> property.
	 * 
	 * <p><strong>Note</strong>:This class exists primarily to support &lt;tab/&gt; in MXML markup. You can add tab characters (\t) directly 
	 * into the text like this:</p>
	 *
	 * <listing version="3.0" >
	 * spanElement1.text += '\t';
	 * </listing>
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 * @see flashx.textLayout.formats.TabStopFormat
	 * @see ParagraphElement#tabStops
	 * @see SpanElement
	 */
	 
	public final class TabElement extends SpecialCharacterElement
	{
		/** Constructor - creates a new TabElement instance. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function TabElement()
		{
			super();
			this.text = '\t';
		}			
		
		/** @private */
		override protected function get abstract():Boolean
		{
			return false;
		}		
	}
}
