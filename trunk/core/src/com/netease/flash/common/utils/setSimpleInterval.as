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
	
	public function setSimpleInterval(closure:Function,
									  delay:Number,
									  ...args):uint
	{
		const id:uint = timeoutOrIntervalTimers.length;
		const timer:Timer = new Timer(delay, 0);
		timer.addEventListener(TimerEvent.TIMER, function(event:TimerEvent):void
		{
			closure.apply(null, args);
		});
		timer.start();
		timeoutOrIntervalTimers[id] = timer;
		return id+1;
	}
}
