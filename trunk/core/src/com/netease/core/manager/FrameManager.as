package com.netease.core.manager
{
    import flash.display.Stage;
    import flash.events.*;
    import flash.utils.*;
    
    import mx.core.*;

    final public class FrameManager extends Object
    {
        private var m_addtionTime:int;
        private var m_lastTime:int;
        private const FRAME_INTERVAL:int = 42;
        private var m_arrProcessFunction:Array;
        private static var m_singleton:FrameManager;
		private var _stage:Stage;
        public function FrameManager()
        {
            this.m_arrProcessFunction = [];
            return;
        }// end function

        public function removeProcessFunction(param1:Function) : void
        {
            if (param1 == null || this.m_arrProcessFunction.indexOf(param1) == -1)
            {
                return;
            }
            var loc2:* = this.m_arrProcessFunction.length;
            var loc3:int = 0;
            while (loc3 < loc2)
            {
                
                if (this.m_arrProcessFunction[loc3] == param1)
                {
                    this.m_arrProcessFunction.splice(loc3, 1);
                    return;
                }
                loc3++;
            }
            return;
        }// end function

        public function registProcessFunction(param1:Function) : void
        {
            if (param1 == null || this.m_arrProcessFunction.indexOf(param1) != -1)
            {
                return;
            }
            this.m_arrProcessFunction.push(param1);
            return;
        }// end function

        private function processAll() : void
        {
            for each (var func:Function in this.m_arrProcessFunction)
            {
                func();
            }
            return;
        }// end function

        private function onEnterFrame(event:Event) : void
        {
            var loc2:* = getTimer();
            var loc3:* = loc2 - this.m_lastTime + this.m_addtionTime;
            var loc4:* = loc3 / this.FRAME_INTERVAL;
            this.m_addtionTime = loc3 % this.FRAME_INTERVAL;
            this.m_lastTime = loc2;
            if (loc3 < 100)
            {
                this.processAll();
                return;
            }
            if (loc4 > 24)
            {
                loc4 = 24;
            }
            while (loc4 > 0)
            {
                
                this.processAll();
                loc4 = loc4 - 1;
            }
            return;
        }// end function

        public function init(stage:Stage) : void
        {
			_stage = stage;
            _stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame, false, 0, true);
            return;
        }// end function

        public static function getInstance() : FrameManager
        {
            if (m_singleton == null)
            {
                m_singleton = new FrameManager();
            }
            return m_singleton;
        }// end function

    }
}

