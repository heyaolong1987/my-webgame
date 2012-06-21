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
package flashx.textLayout.conversion
{
	import flashx.textLayout.elements.TextFlow;
	
	/** 
	 * Interface for exporting text content from a 
	 * TextFlow instance to either String or XML format. 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public interface ITextExporter
	{	
		/** 
		 * Export text content from a TextFlow instance in String or XML format.
		 * <p>Set the <code>conversionType</code> parameter to either of the following values:
		 * <ul>
		 *   <li><code>flashx.textLayout.conversion.ConversionType.STRING_TYPE</code>;</li>
		 *   <li><code>flashx.textLayout.conversion.ConversionType.XML_TYPE</code>.</li>
		 * </ul>
		 * </p>
		 * @param source	The TextFlow to export
		 * @param conversionType 	Return a String (STRING_TYPE) or XML (XML_TYPE).
		 * @return Object	The exported content
		 * @includeExample examples\ITextExporterExample.as -noswf
		 * @see flashx.textLayout.conversion.ConversionType
	 	 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		function export(source:TextFlow, conversionType:String):Object;
	}
}
