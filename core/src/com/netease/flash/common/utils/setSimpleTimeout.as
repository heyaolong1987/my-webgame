// Copyright (c) 2010, NetEase.com,Inc. All rights reserved.
//
// Author: Yang Bo (pop.atry@gmail.com)
//
// Use, modification and distribution are subject to the "New BSD License"
// as listed at <url: http://www.opensource.org/licenses/bsd-license.php >.

package com.netease.flash.common.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public function setSimpleTimeout(closure:Function,
									 delay:Number,
									 ...args):uint
	{
		const id:uint = timeoutOrIntervalTimers.length;
		const timer:Timer = new Timer(delay, 1);
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(event:TimerEvent):void
		{
			closure.apply(null, args);
			clearSimpleTimeout(id+1);
		});
		timer.start();
		timeoutOrIntervalTimers[id] = timer;
		return id+1;
	}
}
