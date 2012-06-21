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
	//import container.TextFrame;
	import flashx.textLayout.elements.IConfiguration;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.DivElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.FlowGroupElement;
	import flash.display.DisplayObjectContainer;
	
	[ExcludeClass]
	/** 
	 * @private
	 * PlainText import filter. Use this to import simple unformatted Unicode text.
	 * Newlines will be converted to paragraphs. Using the PlainTextImporter directly
	 * is equivalent to calling TextConverter.importToFlow(TextConverter.PLAIN_TEXT_FORMAT).
	 */
	internal class PlainTextImporter implements ITextImporter
	{
		protected var _config:IConfiguration;
		
		/** Constructor */
		public function PlainTextImporter(config:IConfiguration =  null)
		{
			_config = config;
		}
		
		/** Import text content, from an external source, and convert it into a TextFlow.
		 * @param source		source data to convert, may be string or XML
		 * @return TextFlow that was created from the source.
		 */
		public function importToFlow(source:Object):TextFlow
		{
			if (source is String)
				return importFromString(String(source));
			return null;
		}
		
		// LF or CR or CR+LF. Equivalently, LF or CR, the latter optionally followed by LF
		private static const _newLineRegex:RegExp = /\u000A|\u000D\u000A?/g;
		
		/** Import text content, from an external source, and convert it into a TextFlow.
		 * @param source		source data to convert
		 * @return textFlows[]	an array of TextFlow objects that were created from the source.
		 */
		protected function importFromString(source:String):TextFlow
		{
			var paragraphStrings:Array = source.split(_newLineRegex);

			var textFlow:TextFlow = new TextFlow(_config);
			var paraText:String;
			for each (paraText in paragraphStrings)
			{
				var paragraph:ParagraphElement  = new ParagraphElement();
				var span:SpanElement = new SpanElement();
				span.replaceText(0, 0, paraText);
				paragraph.replaceChildren(0, 0, span);			
				textFlow.replaceChildren(textFlow.numChildren, textFlow.numChildren, paragraph);
			}
			return textFlow;			
		}

		/** Errors encountered while parsing. 
		 * Value is a vector of Strings.
		 */
		public function get errors():Vector.<String>
		{
			return null;
		}
		
		/** Errors will cause exceptions if throwOnError is true. */
		public function get throwOnError():Boolean
		{
			return false;
		}
		
		/** Does nothing.  get always returns false */
		public function set throwOnError(value:Boolean):void
		{
			
		}
	}
}
