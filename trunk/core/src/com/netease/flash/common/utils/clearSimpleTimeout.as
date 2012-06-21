// Copyright (c) 2010, NetEase.com,Inc. All rights reserved.
//
// Author: Yang Bo (pop.atry@gmail.com)
//
// Use, modification and distribution are subject to the "New BSD License"
// as listed at <url: http://www.opensource.org/licenses/bsd-license.php >.

package com.netease.flash.common.utils
{
	import flash.utils.Timer;
	
	public function clearSimpleTimeout(id:uint):void
	{
		if(id > 0) {
			var index:int = id-1;
			const timer:Timer = timeoutOrIntervalTimers[index];
			if(timer)
			{
				timer.stop();
			}
			do
			{
				delete timeoutOrIntervalTimers[index];
			}
			while (index in timeoutOrIntervalTimers);
		}
	}
}
