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
package flashx.textLayout.operations
{
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.edit.TextFlowEdit;
	import flashx.textLayout.edit.TextScrap;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.tlf_internal;


	use namespace tlf_internal;


	/**
	 * The PasteOperation class encapsulates a paste operation.
	 *
	 * <p>The specified range is replaced by the new content.</p>
	 * 
	 * <p><b>Note:</b> The edit manager is responsible for copying the 
	 * contents of the clipboard.</p>
	 * 
	 * @see flashx.textLayout.edit.EditManager
	 * @see flashx.textLayout.events.FlowOperationEvent
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */			
	public class PasteOperation extends FlowTextOperation
	{
		private var _textScrap:TextScrap;
		private var _tScrapUnderSelection:TextScrap;
		private var _numCharsAdded:int = 0;
		
		/** 
		 * Creates a PasteOperation object.
		 * 
		 * @param operationState Describes the insertion point or a range of text 
		 * to replace.
		 * @param textScrap The content to paste into the text flow.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function PasteOperation(operationState:SelectionState, textScrap:TextScrap)
		{
			super(operationState);
			_textScrap = textScrap;
		}
		
		/** @private */
		public override function doOperation():Boolean
		{
			if (_textScrap != null)
			{
				_tScrapUnderSelection = TextFlowEdit.createTextScrap(originalSelectionState.textFlow, originalSelectionState.absoluteStart, originalSelectionState.absoluteEnd);
				internalDoOperation();
			}
			return true;	
		}
		
		private function internalDoOperation():void
		{
			if (absoluteStart != absoluteEnd)	
			{
				TextFlowEdit.replaceRange(textFlow, absoluteStart, absoluteEnd, null);
				if (textFlow.interactionManager)
					textFlow.interactionManager.notifyInsertOrDelete(absoluteStart, absoluteStart - absoluteEnd);
			}
			
			var nextInsertPosition:int = TextFlowEdit.replaceRange(textFlow, absoluteStart, absoluteStart, _textScrap);
			if (textFlow.interactionManager)
				textFlow.interactionManager.notifyInsertOrDelete(absoluteStart, nextInsertPosition - absoluteStart);				
			_numCharsAdded = (nextInsertPosition - absoluteStart) /*- (absoluteEnd - absoluteStart) */;
		}
		
		/** @private */
		public override function undo():SelectionState
		{
			if (_textScrap != null)
			{
				TextFlowEdit.replaceRange(textFlow, absoluteStart, absoluteStart + _numCharsAdded, _tScrapUnderSelection);
				if (textFlow.interactionManager)
					textFlow.interactionManager.notifyInsertOrDelete(absoluteStart, -_numCharsAdded);
			}
			return originalSelectionState;	
		}
	
		/** @private */
		public override function redo():SelectionState
		{
			if (_textScrap != null)
				internalDoOperation();								
			return new SelectionState(textFlow, absoluteStart + _numCharsAdded, absoluteStart + _numCharsAdded,null);	
		}		

		/** 
		 * textScrap the text being pasted
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function get textScrap():TextScrap
		{ return _textScrap; }
		public function set textScrap(val:TextScrap):void
		{ _textScrap = val; }		
	}
}
