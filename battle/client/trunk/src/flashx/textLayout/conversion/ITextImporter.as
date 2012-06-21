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
	 * Interface for importing text content into a TextFlow from an external source. 
	 * @includeExample examples\ITextImporterExample.as -noswf
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	public interface ITextImporter
	{	
		/** 
		 * Import text content from an external source and convert it into a TextFlow.
		 * @param source		Data to convert
		 * @return TextFlow created from the source.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		function importToFlow(source:Object):TextFlow;

		/** 
		 * Errors encountered while parsing. This will be empty if there were no errors.
		 * Value is a vector of Strings.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		function get errors():Vector.<String>;
		
		/** 
		 * Parsing errors during import will cause exceptions if throwOnError is <code>true</code>. 
	 	 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		function get throwOnError():Boolean;
		function set throwOnError(value:Boolean):void;
	}
}
