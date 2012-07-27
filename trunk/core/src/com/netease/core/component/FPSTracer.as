package com.netease.core.component {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import mx.core.UIComponent;

	/**
	 * FPS显示神器
	 * @author shu，转自网络，改编了一下
	 */
	public class FPSTracer extends UIComponent {
		private var _stage:Stage;
		private var _parent:Sprite;
		private var memory:Number;
		private var fps:Number;
		private var fMem:TextFormat;
		private var fFps:TextFormat;
		private var tMem:TextField;
		private var tFps:TextField;
		private var renderBmp:Bitmap;
		private var renderBmd:BitmapData;
		private var _maxFPS:int = 100;
		private var _maxMem:int = 500;

		private var stepper:int=0;
		private var counter:int;
		private var oldTime:Number;
		private var timeArr:Array = [];
		private var _isOpen:Boolean = false;
		public function FPSTracer(){
		}
		public function switchFPSTracer():void {
			if(_isOpen) {
				close();
			}else {
				open();
			}
			_isOpen = !_isOpen;
		}
		
		public function get maxFPS():int {
			return _maxFPS;
		}
		
		public function set maxFPS(value:int):void {
			_maxFPS = value;
		}
		
		public function get maxMem():int {
			return _maxMem;
		}
		
		public function set maxMem(value:int):void {
			_maxMem = value;
		}
		public function set isOpen(value:Boolean):void{
			_isOpen = value;
			if(_isOpen) {
				open();
			}else {
				close();
			}
		}
		private function open():void {
			addEventListener(Event.ENTER_FRAME, tracerHandle);
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			mouseEnabled = true;
			//
			fMem = new TextFormat();
			fFps = new TextFormat();
			renderBmd=new BitmapData(80, 80, true, 0xff000000);
			renderBmp=new Bitmap(renderBmd);
			tMem = new TextField();
			tFps = new TextField();
            tMem.mouseEnabled = false;
			tMem.selectable = false;
			tFps.mouseEnabled = false;
			tFps.selectable = false;
			fMem.color = 0xffffffff;
			fMem.size = 10;
			fMem.font = "arial";
			tMem.defaultTextFormat = fMem;
			fFps.color = 0xffffff00;
			fFps.size = 10;
			fFps.font = "arial";
			tFps.defaultTextFormat = fFps;
			this.addChild(tFps);
			this.addChild(tMem);
			tMem.y=12;
			this.addChild(renderBmp);
			renderBmp.y=0;
			tFps.text="FPS:";
			tMem.text="MEM:";
            this.setChildIndex(renderBmp, 0);
			this.setChildIndex(tFps, 1);
			this.setChildIndex(tMem, 2);
			visible = true;
		}
		
		private function close():void {
			mouseChildren = false;
			mouseEnabled = false;
			removeEventListener(Event.ENTER_FRAME, tracerHandle);
			removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			if(stage) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, outHandler);
				stage.removeEventListener(MouseEvent.MOUSE_OUT, outHandler);
			}
			if(renderBmp && contains(renderBmp)) {
				removeChild(renderBmp);
				renderBmp = null;
			}
			if(tFps && contains(tFps)) {
				removeChild(tFps);
				renderBmp = null;
			}
			if(tMem && contains(tMem)) {
				removeChild(tMem);
				renderBmp = null;
			}
			visible = false;
		}
		
		private function downHandler(event:Event):void {
			removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			if(stage) {
				stage.addEventListener(MouseEvent.MOUSE_UP, outHandler);
				stage.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			}
			startDrag();
		}
		
		private function outHandler(event:Event):void{
			stopDrag();
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			if(stage) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, outHandler);
				stage.removeEventListener(MouseEvent.MOUSE_OUT, outHandler);
			}
		}
		
		private function tracerHandle(evt:Event):void {
			if (stepper<=80) {
				stepper++;
			}
			var nowTime:int = getTimer();
			
			if (timeArr.length==0) {
				timeArr.push(nowTime);
			}
			else{
				var oldTime:int = timeArr[timeArr.length-1];
				if(timeArr.length>=100){
					timeArr.shift();
				}
				timeArr.push(nowTime);
				fps = int(1 / (nowTime - oldTime) * 1000 * 100) / 100;
				memory = int(System.totalMemory * 10 / 1024 / 1024)/10;
				if ((stepper <= 80)&&(stepper >1)) {
					renderBmd.setPixel32(stepper, 80-fps / maxFPS * 50, 0xffffff00);
					renderBmd.setPixel32(stepper, 80-memory / maxMem * 50, 0xffffffff);
				} else if (stepper>80) {
					stepper = 0;
					renderBmd.scroll( -1, 0);
					renderBmd.fillRect(new Rectangle(79, 0, 1, 80), 0xff000000);
					renderBmd.setPixel32(79, 80-fps / maxFPS * 50, 0xffffff00);
					renderBmd.setPixel32(79, 80-memory / maxMem * 50, 0xffffffff);
				}
				
			}
			if(nowTime>counter+200){
				tFps.text="FPS:"+int(1000/((timeArr[timeArr.length-1] - timeArr[0])/timeArr.length)*100)/100;
				tMem.text="MEM:"+memory+"MB";
				counter = nowTime;
			}
			
			
		}

	}

}