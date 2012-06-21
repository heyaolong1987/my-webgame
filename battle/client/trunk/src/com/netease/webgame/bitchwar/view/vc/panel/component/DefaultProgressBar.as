package com.netease.webgame.bitchwar.view.vc.panel.component {
	import com.greensock.TweenMax;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * 默认的进度条，用于登录加载程序、加载资源等不定时长加载完成的地方
	 * @author: shu
	 * Mar 18, 2011 1:24:46 PM
	 **/
	public class DefaultProgressBar extends Sprite {
		[Embed(source='/style/progressbar.swf', symbol='defaultProgressPopupBarBg')]
		private var _barBgCls:Class;
		/**背景*/
		private var _barBg:Sprite;
		
		[Embed(source='/style/progressbar.swf', symbol='defaultProgressPopupBar')]
		private var _progressBarCls:Class;
		/**进度条*/
		private var _progressBarMC:MovieClip;
		
		/***进度动画帧数***/
		private static const PROGRESS_EFFECT_FREAMS:int = 48;
		
		public function DefaultProgressBar() {
			super();
			if(_barBgCls) {
				_barBg = new _barBgCls() as Sprite;
				addChild(_barBg);
			}
			if(_progressBarCls) {
				_progressBarMC = MovieClip(new _progressBarCls());
				_progressBarMC.x = 27;
				_progressBarMC.y = 11;
				_progressBarMC.stop();
				addChild(_progressBarMC);
			}
		}
		
		/**
		 * 设置当前进度 0 - 1
		 ***/
		public function set progress(value:Number):void {
			//设置当前进度
			var frame:int = value * PROGRESS_EFFECT_FREAMS;
			_progressBarMC.gotoAndStop(frame);
		}
	}
}