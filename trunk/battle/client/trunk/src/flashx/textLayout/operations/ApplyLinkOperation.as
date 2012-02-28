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
	import flashx.textLayout.elements.FlowLeafElement;
	import flashx.textLayout.elements.LinkElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.edit.TextFlowEdit;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.edit.TextScrap;
	import flashx.textLayout.edit.TextFlowEdit;
	import flashx.textLayout.tlf_internal;
	use namespace tlf_internal;
	
	/**
	 * The ApplyLinkOperation class encapsulates a link creation or modification operation.
	 *
	 * @see flashx.textLayout.elements.LinkElement
	 * @see flashx.textLayout.edit.EditManager
	 * @see flashx.textLayout.events.FlowOperationEvent
	 * 
	 * @includeExample examples\ApplyLinkOperation_example.as -noswf
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */			
	public class ApplyLinkOperation extends FlowTextOperation
	{
		private var _textScrap:TextScrap;
		private var _hrefString:String;
		private var _target:String;
		private var _extendToLinkBoundary:Boolean;

		/** 
		 * Creates an ApplyLinkOperation object.
		 * 
		 * @param operationState	The text range to which the operation is applied.
		 * @param href The URI to be associated with the link.  If href is an empty string, 
		 * the URI of links in the selection are removed.
		 * @param target The target of the link.
		 * @param extendToLinkBoundary Whether to extend the selection to include the entire 
		 * text of any existing links overlapped by the selection, and then apply the change.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		function ApplyLinkOperation(operationState:SelectionState, href:String, target:String, extendToLinkBoundary:Boolean)
		{
			super(operationState);
		
			_hrefString = href;
			_target = target;
			_extendToLinkBoundary = extendToLinkBoundary;
		}
		
		/** 
		 * The URI to be associated with the link.  If href is an empty string, 
		 * the URI of links in the selection are removed.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function get href():String
		{
			return _hrefString;
		}
		public function set href(value:String):void
		{
			_hrefString = value;
		}
		
		/**
		 * The target of the link.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function get target():String
		{
			return _target;
		}
		public function set target(value:String):void
		{
			_target = value;
		}
		
		/**
		 * Whether to extend the selection to include the entire 
		 * text of any existing links overlapped by the selection, and then apply the change.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function get extendToLinkBoundary():Boolean
		{
			return _extendToLinkBoundary;
		}
		public function set extendToLinkBoundary(value:Boolean):void
		{
			_extendToLinkBoundary = value;
		}

		
		/** @private */
		public override function doOperation():Boolean
		{
			if (absoluteStart == absoluteEnd)
				return false;
			
			if (_extendToLinkBoundary)
			{
				var leaf:FlowLeafElement = textFlow.findLeaf(absoluteStart);
				var link:LinkElement = leaf.getParentByType(LinkElement) as LinkElement;
				if (link)
				{
					absoluteStart = link.getAbsoluteStart();
				}
				
				leaf = textFlow.findLeaf(absoluteEnd-1);
				link = leaf.getParentByType(LinkElement) as LinkElement;
				if (link)
				{
					absoluteEnd = link.getAbsoluteStart() + link.textLength;
				}
			}
			//save it off so that we can restore the flow on undo			
			_textScrap = TextFlowEdit.createTextScrap(textFlow, absoluteStart, absoluteEnd);
				
			if (_hrefString != "")
			{
				var madeLink:Boolean = TextFlowEdit.makeLink(textFlow, absoluteStart, absoluteEnd, _hrefString, _target);
				if (!madeLink) return false;
			}
			else
			{
				TextFlowEdit.removeLink(textFlow, absoluteStart, absoluteEnd);				
			} 
			return true;
		}
		
		/** @private */
		public override function undo():SelectionState
		{
			if (absoluteStart != absoluteEnd && _textScrap != null) 
				TextFlowEdit.replaceRange(textFlow, absoluteStart, absoluteEnd, _textScrap);
			return originalSelectionState;				
		}
	
		/** @private */
		public override function redo():SelectionState
		{
			if (absoluteStart != absoluteEnd)
			{
				if (_hrefString != "")
				{
					TextFlowEdit.makeLink(textFlow, absoluteStart, absoluteEnd, _hrefString, _target);
				}
				else
				{
					TextFlowEdit.removeLink(textFlow, absoluteStart, absoluteEnd);				
				} 
			}
			return originalSelectionState;	
		}
	}
}
