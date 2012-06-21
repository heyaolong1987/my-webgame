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
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.elements.TCYElement;
	import flashx.textLayout.elements.FlowLeafElement;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.edit.TextScrap;
	import flashx.textLayout.edit.TextFlowEdit;
	import flashx.textLayout.tlf_internal;
	
	import flashx.textLayout.debug.assert;
	
	use namespace tlf_internal;
	
	/** 
	 * The ApplyTCYOperation class encapsulates a TCY transformation.
	 *
	 * @see flashx.textLayout.elements.TCYElement
	 * @see flashx.textLayout.edit.EditManager
	 * @see flashx.textLayout.events.FlowOperationEvent
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class ApplyTCYOperation extends FlowTextOperation
	{
		
		private var makeBegIdx:int;
		private var makeEndIdx:int;
		private var removeBegIdx:int;
		private var removeEndIdx:int;
		private var removeRedoBegIdx:int;
		private var removeRedoEndIdx:int;
		
		private var _textScrap:TextScrap;
		private var _tcyOn:Boolean;

		/** 
		 * Creates an ApplyTCYOperation object.
		 * 
		 * @param operationState Describes the range of text to which the operation is applied.
		 * @param tcyValue Specifies whether to apply TCY (<code>true</code>), or remove TCY (<code>false</code>).
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function ApplyTCYOperation(operationState:SelectionState, tcyOn:Boolean)
		{
			super(operationState);
			
			if(tcyOn)
			{
				makeBegIdx = operationState.absoluteStart;
				makeEndIdx = operationState.absoluteEnd;
			}
			else
			{
				removeBegIdx = operationState.absoluteStart;
				removeEndIdx = operationState.absoluteEnd;
			}
			
			_tcyOn = tcyOn;
		}

		/** 
		 * Indicates whether the operation applies or removes TCY formatting.
		 * 
		 * <p>If <code>true</code>, then the operation transforms the range into a 
		 * TCY element. If <code>false</code>, then the operation removes TCY formatting from
		 * the first TCY element in the range.</p>
		 * 
		 * @see flashx.textLayout.elements.TCYElement
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function get tcyOn():Boolean
		{
			return _tcyOn;
		}
		
		public function set tcyOn(val:Boolean):void
		{
			_tcyOn = val;
		}
		
		/** @private */
		public override function doOperation():Boolean
		{
			if (_tcyOn && makeEndIdx <= makeBegIdx)
			{
				return false;
			}
			else if(!_tcyOn && removeEndIdx <= removeBegIdx)
			{
				return false;
			}
			
			if (_tcyOn)
			{
				//save it off so that we can restore the flow on undo - make and remove need different scraps		
				_textScrap = TextFlowEdit.createTextScrap(textFlow, makeBegIdx, makeEndIdx);
				TextFlowEdit.makeTCY(textFlow, makeBegIdx, makeEndIdx);
			}
			else
			{
				var leaf:FlowLeafElement = textFlow.findLeaf(removeBegIdx);
				var tcyElem:TCYElement = leaf.getParentByType(TCYElement) as TCYElement
				CONFIG::debug{ assert(tcyElem != null, "Trying to remove TCY from a non-TCY element!"); }
				
				//collect the bounds for redo of removal - redo bounds are only the selection, while do bounds are the whole
				//tcyElement
				removeRedoBegIdx = removeBegIdx;
				removeRedoEndIdx = removeEndIdx;
				
				//now reset the beg and end idx's	
				removeBegIdx = tcyElem.getAbsoluteStart();
				removeEndIdx = removeBegIdx + tcyElem.textLength;
				
				//create the scrap of the whole TCY element
				_textScrap = TextFlowEdit.createTextScrap(textFlow, removeBegIdx, removeEndIdx);
			
				//use the removeRedoBegIdx/removeRedoEndIdx
				TextFlowEdit.removeTCY(textFlow, removeRedoBegIdx, removeRedoEndIdx);
			} 
			return true;				
		}
		
		/** @private */
		public override function undo():SelectionState
		{
			if (_textScrap != null) {
				if (_tcyOn)
				{
					TextFlowEdit.replaceRange(textFlow, makeBegIdx, makeEndIdx, _textScrap);
				}
				else
				{
					TextFlowEdit.replaceRange(textFlow, removeBegIdx, removeEndIdx, _textScrap);
				}
			}
			return originalSelectionState;				
		}
	
		/** @private */
		public override function redo():SelectionState
		{
			if(_textScrap != null)
			{
				if (_tcyOn)
				{
					TextFlowEdit.makeTCY(textFlow, makeBegIdx, makeEndIdx);
				}
				else
				{
					TextFlowEdit.removeTCY(textFlow, removeRedoBegIdx, removeRedoEndIdx);				
				} 
			}
			return originalSelectionState;
		}
	}
}
