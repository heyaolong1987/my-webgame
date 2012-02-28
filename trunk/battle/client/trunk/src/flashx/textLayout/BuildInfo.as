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
package flashx.textLayout
{
	[ExcludeClass]
	/**
	 * Contains identifying information for the current build. 
	 * This may not be the form that this information is presented in the final API.
	 */
	public class BuildInfo
	{
		/**
		 * Contains the current version number. 
		 */
		public static const VERSION:String = "1.0";
		
		/**
		 * Contains the current build number. 
		 * It is static and can be called with <code>BuildInfo.kBuildNumber</code>
		 * <p>String Format: "BuildNumber (Changelist)"</p>
		 */
		public static const kBuildNumber:String = "595 (738907)";
		
		/**
		 * Contains the branch name. 
		 */
		public static const kBranch:String = "1.0";

		/**
		 * @private 
		 */
		public static const AUDIT_ID:String = "<AdobeIP 0000486>";
		
		/**
		 * @private 
		 */
		public function dontStripAuditID():String
		{
			return AUDIT_ID;
		}
	}
}	// package
