package com.netease.webgame.bitchwar.manager
{
	import com.netease.webgame.bitchwar.model.vo.sound.SoundVO;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.utils.Timer;
	import flash.utils.setInterval;
	
	import mx.effects.SoundEffect;

	/**
	 * 声音播放的特效 
	 * @author zhp
	 * 
	 */	
	public class SoundManager
	{
		public static const SOUND_EFFECT_EVENT_FADE_OUT_COMPLETE:String  = 'SOUND_EFFECT_EVENT_FADE_OUT_COMPLETE';
		public static const SOUND_EFFECT_EVENT_FADE_IN_COMPLETE:String = 'SOUND_EFFECT_EVENT_FADE_IN_COMPLETE';
		
		public static function fadeInSound(vo:SoundVO, time:Number, resume:Boolean=false, volumn:int=100, endFunction:Function=null):void {
			if (vo == null) {
				return;
			}
			if (time > 0) {
				
			}
			vo.addEventListener(SoundVO.EVENT_START_PLAY_SOUND, startPlay);
			playDirectly(vo, resume, 0);
			
			function startPlay(event:Event):void {
				vo.removeEventListener(SoundVO.EVENT_START_PLAY_SOUND, startPlay);
				var timeInterval:Number = time/volumn;
				var timer:Timer = new Timer(timeInterval);
				timer.addEventListener(TimerEvent.TIMER, timeHandler);
				timer.start();
			}
			
			function timeHandler(event:TimerEvent):void {
				vo.setVolumn(vo.getVolumn() + 1);
				if (vo.getVolumn() <= 0 || vo.getVolumn() == volumn) {
					Timer(event.target).stop();
					Timer(event.target).removeEventListener(TimerEvent.TIMER, timeHandler);
					if (endFunction!=null) {
						endFunction.call();
					}
				}
			}
		}
		
		public static function fadeOutSound(vo:SoundVO, time:Number, endFunction:Function=null):void {
			if (vo == null) {
				return;
			}
			if (vo.getVolumn() <= 1) {
				stopDirectly(vo);
				if (endFunction != null) {
					endFunction.call();
				}
				return;
			}
			var timeInterval:Number = time/vo.getVolumn();
			var timer:Timer = new Timer(timeInterval);
			timer.addEventListener(TimerEvent.TIMER, timeHandler);
			timer.start();
			
			function timeHandler(event:TimerEvent):void {
				vo.setVolumn(vo.getVolumn() - 1);
				if (vo.getVolumn() <= 0) {
					vo.stop();
					Timer(event.target).stop();
					Timer(event.target).removeEventListener(TimerEvent.TIMER, timeHandler);
					if (endFunction!=null) {
						endFunction.call();
					}
				}
			}
		}
		
		public static function playDirectly(vo:SoundVO, resume:Boolean=false, volumn:int=100):void {
			if (vo) {
				vo.play(resume, volumn);
			}
		}
		
		public static function stopDirectly(vo:SoundVO):void {
			if (vo) {
				vo.stop();
			}
		}
		
	}
}