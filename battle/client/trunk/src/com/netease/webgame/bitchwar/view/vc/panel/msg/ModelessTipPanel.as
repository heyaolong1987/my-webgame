package com.netease.webgame.bitchwar.view.vc.panel.msg
{
	import com.greensock.TweenMax;
	import com.netease.webgame.bitchwar.constants.Config;
	import com.netease.webgame.bitchwar.constants.message.MsgConstants;
	import com.netease.webgame.bitchwar.model.vo.msg.MsgVO;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;

	public class ModelessTipPanel extends Canvas
	{
		
		private var moveEffects:Array;
		private var showEffect:TweenMax;
		private var hideEffect:TweenMax;
		private var fastHideEffect:TweenMax;
		public function ModelessTipPanel()
		{
		}
		public function showModelessTip(vo:MsgVO):void{
			var tipMsg:TipMsg = new TipMsg();
			tipMsg.msgVO = vo;
			tipMsg.x=0;
			tipMsg.y = height-tipMsg.height-30;
			tipMsg.alpha = 1;
			tipMsg.width = width;
			tipMsg.tweeningProperties = null;
			//立即将所有当前end的tween跳转到完结状态
			for each(var moveEffect:TweenMax in moveEffects) {
				if(moveEffect.totalProgress != 1) {
					moveEffect.complete();
				}
			}
			moveEffects = [];
			//将上次正在淡出的item跳转到显示出来的状态
			if (showEffect!=null && showEffect.totalProgress != 1) {
				showEffect.complete();
			}
			//将当前所有item往上移动
			if (numChildren > 0) {
				playMoveEffect(getChildren());					
			} else{
				playMoveEffect([]);
			}
			//
			addChildAt(tipMsg, 0);
			//将待添加的item显示出来
			playShowEffect(tipMsg);
			
		}
		//待添加的item显示出来以后
		private function showEndHandler(msg:TipMsg):void {
			//如果当前条目数超过了最大显示条目(最多超过1，超过1就会进入此被删除)
			if(numChildren > MsgConstants.MAX_MODELESS_TIP_NUM) {
				//将正在隐藏的msg直接移除
				if(hideEffect != null && hideEffect.totalProgress != 1){
					removeTipMsg(hideEffect.target as TipMsg);
				}
				if (fastHideEffect !=null && fastHideEffect.totalProgress != 1) {
					removeTipMsg(fastHideEffect.target as TipMsg);
				}
				//将最顶层的msg隐藏
				if(numChildren > MsgConstants.MAX_MODELESS_TIP_NUM) {
					playFastHideEffect(getChildAt(numChildren-1) as TipMsg);
				}
				else {
					playHideEffect(getChildAt(numChildren-1) as TipMsg);
				}
			} else if (numChildren > 0) {
				//否则，将最顶层的msg隐藏
				if (hideEffect == null || hideEffect.totalProgress == 1) {
					playHideEffect(getChildAt(numChildren-1) as TipMsg);
				}
			}
		}
		
		private function hideEndHandler(msg:TipMsg):void {
			removeTipMsg(msg);
			//循环将剩余的msg隐藏
			if (numChildren > 0) {
				playHideEffect(getChildAt(numChildren-1) as TipMsg);
			}
		}
		
		private function removeTipMsg(msg:TipMsg):void {
			if (msg != null && contains(msg)) {
				TweenMax.killTweensOf(msg);
				removeChild(msg);
			}
		}
		private function playMoveEffect(items:Array):void {
			var moveEffect:TweenMax;
			for each(var item:TipMsg in items) {
				moveEffect = TweenMax.to(item, 0.5, {y:item.y - MsgConstants.MODELESS_TIP_HEIGHT});
				moveEffects.push(moveEffect);
			}
		}
		
		private function playShowEffect(item:TipMsg):void {
			item.alpha = 0.1;
			showEffect = TweenMax.to(item, 0.5, {alpha:1, onComplete:showEndHandler, onCompleteParams:[item]});
		}
		
		private function playHideEffect(item:TipMsg):void {
			item.alpha = 1;
			hideEffect = TweenMax.to(item, 0.5, {alpha:0.1, delay:1, onComplete:hideEndHandler, onCompleteParams:[item]});
		}
		
		private function playFastHideEffect(item:TipMsg):void {
			item.alpha = 1;
			fastHideEffect = TweenMax.to(item, 0.2, {alpha:0.1, onComplete:hideEndHandler, onCompleteParams:[item]});
		}
		
	}
}