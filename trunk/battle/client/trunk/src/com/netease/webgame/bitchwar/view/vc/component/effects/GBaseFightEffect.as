package com.netease.webgame.bitchwar.view.vc.component.effects
{
	public class GBaseFightEffect extends GBaseEffect
	{
		private var _fighterArr:Array;
		private var _actionIndex:int;
		private var _actionList:Array;
		public function GBaseFightEffect(fighterArr:Array,actionIndex:int,actionList:Array)
		{
			_fighterArr = fighterArr;
			_actionIndex = actionIndex;
			_actionList = actionList;
		}
		override public function playEffect():void{
			super.playEffect();
		}
		
	}
}