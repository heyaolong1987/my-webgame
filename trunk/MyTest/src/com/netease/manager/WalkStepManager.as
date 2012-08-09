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
		
		/**
		 * 算出移动方向 
		 * @param startX
		 * @param startY
		 * @param desX
		 * @param desY
		 * @return 
		 * 
		 */		
		public static function getDirection(dx:Number,dy:Number):int {
			if(dx>0){
				if(dy>0){
					if(dx>dy*2.4){
						return 0;
					}else if(dy>dx*2.4){
						return 6;
					}else
						return 7;
				}else{
					if(dx>-dy*2.4){
						return 0;
					}else if(-dy>dx*2.4){
						return 2;
					}else
						return 1;
				}
			}else{
				if(dy>0){
					if(-dx>dy*2.4){
						return 4;
					}else if(dy>-dx*2.4){
						return 6;
					}else
						return 5;
				}else{
					if(dx<dy*2.4){
						return 4;
					}else if(dy<dx*2.4){
						return 2;
					}else
						return 3;
				}
			}
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
				if(speed >= dis){
					if(endX-playerVO.x!= 0 || endY-playerVO.y!=0){
						playerVO.dir = getDirection(endX-playerVO.x,endY-playerVO.y);
					}
					playerVO.x = endX;
					playerVO.y = endY;
					//计算dir
					playerVO.route.shift();
				}
				else{
					endX = playerVO.x+speed*dx/dis;
					endY = playerVO.y+speed*dy/dis;
					if(endX-playerVO.x!= 0 || endY-playerVO.y!=0){
						playerVO.dir = getDirection(endX-playerVO.x,endY-playerVO.y);
					}
					playerVO.x = endX;
					playerVO.y = endY;
				}
			}
		}
	}
}