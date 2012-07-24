package com.netease.manager{
	import com.netease.model.vo.moveobj.CharVO;
	import com.netease.model.vo.moveobj.PlayerVO;
	import com.netease.view.map.moveobj.Char;
	import com.netease.view.map.moveobj.Player;
	
	import flash.utils.getTimer;

	/**
	 * @author heyaolong
	 * 
	 * 2012-7-24
	 */ 
	public class WalkStepManager{
		
		public function WalkStepManager()
		{
		}
		public static function stepRoute(playerVO:CharVO):void{
			var currentTime:int = getTimer();
			var addTime:int = currentTime-playerVO.lastUpdateTime;
			playerVO.lastUpdateTime = currentTime;
			if(playerVO.route && playerVO.route.length>0){
				var startX:Number = playerVO.x;
				var startY:Number = playerVO.y;
				var endX:Number = playerVO.route[0][0];
				var endY:Number = playerVO.route[0][1];
				var dx:Number = endX-startX;
				var dy:Number = endY-startY;
				var dis:Number = Math.sqrt(dx*dx+dy*dy);
				var speed:Number = 1.0*playerVO.speed*addTime/25;
				if(speed > dis){
					playerVO.x = endX;
					playerVO.y = endY;
					//计算dir
					playerVO.route.shift();
				}
				else{
					playerVO.x += speed*dx/dis;
					playerVO.y += speed*dy/dis;
				}
			}
		}
	}
}