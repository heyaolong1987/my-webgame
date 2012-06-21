package com.netease.core.map.moveobj{
	import com.greensock.TweenMax;
	import com.netease.core.utils.MovingTween;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.text.TextField;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.effects.Tween;
	
	/**
	 * @author heyaolong
	 * 
	 * 2012-5-17
	 */ 
	public class MoveObj extends Sprite{
		public var tween:TweenMax;
		public var moveData:MoveObjVO;
		public function MoveObj()
		{
			var txt:TextField = new TextField();
			txt.text = "我的名字叫啥啥啥";
			txt.textColor = 0xff0000;
			addChild(txt);
			mouseChildren = false;
			mouseEnabled = false;
		}
		public function tweenUpdate(value:Object):void{
			
		}
	}
}