package com.netease.core.utils{
	import com.netease.core.events.RouteTweenEvent;
	import com.netease.core.manager.FrameManager;
	import com.netease.core.model.vo.map.moveobj.MoveObjVO;
	
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import mx.core.Container;
	
	/**
	 * @author heyaolong
	 * 
	 * 2012-5-22
	 */ 
	public class MovingTween extends EventDispatcher{
		
		public static var frameRate:int=30;
		
		private var _route:Array;
		private var _startTime:int;
		private var _duration:int;
		private var _currentRouteIndex:int;
		public var x:Number;
		public var y:Number;
		public var direction:int = -1;
		public var _currentStartX:int;
		public var _currentStartY:int;
		
		public var _currentEndX:int;
		public var _currentEndY:int;
		public var _currentRateX:Number;
		public var _currentRateY:Number;
		public var totalDis:Number;
		public var disList:Array;
		public var hasRouteDis:Number;
		public var container:Object;
		public var _lastMoveTime:int;
		
		public function MovingTween(container:Object=null){
			this.container = container;
			FrameManager.getInstance().registProcessFunction(stepMove);
		}
		public function setPos(x:Number,y:Number,direction:int=-1):void{
			var changed:Boolean = false;
			if(Math.floor(this.x) != Math.floor(x) || Math.floor(this.y) != Math.floor(y) || this.direction != direction){
				
				//trace(x-this.x,y-this.y,Math.floor(Math.sqrt((x-_currentStartX)*(x-_currentStartX)+(y-_currentStartY)*(y-_currentStartY))),_lastMoveTime);
				changed = true;
			}
			this.x = x;
			this.y = y;
			if(direction != -1){
				this.direction = direction;
			}
			if(changed){
				this.dispatchEvent(new RouteTweenEvent(RouteTweenEvent.POS_UPDATE,this,Math.floor(this.x),Math.floor(this.y),direction));
			}
		}
		/**
		 *寻路路径
		 * @param value
		 * 
		 */
		public function setRouteInfo(route:Array,startTime:int,duration:int):void{
			_route = route;
			_startTime = startTime;
			_lastMoveTime = _startTime;
			_duration = duration;
			totalDis = 0;
			disList = [];
			if(_route && route.length>0){
				setPos(_route[0][0],_route[0][1]);
				var dx:int;
				var dy:int;
				var dis:Number;
				var len:int = route.length;
				disList.push([dis,totalDis]);
				for(var i:int=0; i<len-1; i++){
					dx = route[i+1][0]-route[i][0];
					dy = route[i+1][1]-route[i][1];
					dis = Math.sqrt(dx*dx+dy*dy);
					totalDis += dis;
					disList.push([dis,totalDis]);					
				}
			}
			_currentRouteIndex = 0;
			toNextRoutePoint();
			
		}
		
		public function stepMove():void{
			if(_route == null){
				return;
			}
			var currentTime:int = getCurrentTime();
			var lastTime:int = _startTime+_duration-_lastMoveTime;
			var goTime:int = currentTime - _lastMoveTime;
			var currentDis:Number = Math.sqrt((x-_currentStartX)*(x-_currentStartX) + (y-_currentStartY)*(y-_currentStartY));
			var lastDis:Number = totalDis-(disList[_currentRouteIndex][1]+currentDis);
			var addDis:Number = lastDis*goTime/lastTime;
			if(addDis>lastDis){
				addDis = lastDis;
			}
			if(addDis < 0){
				addDis = 0;
			}
			var nextDis:Number = currentDis+addDis;
			if(nextDis > disList[_currentRouteIndex+1][0]){
				setPos(_currentEndX,_currentEndY,direction);
				_currentRouteIndex++;
				toNextRoutePoint();
			}
			else{
				setPos(_currentStartX+nextDis*_currentRateX,_currentStartY+nextDis*_currentRateY,direction);
			}
			//trace("rate",addDis,currentDis,lastDis,nextDis,_currentRateX,_currentStartY);
			_lastMoveTime = getTimer();
			
		}
		public function stop():void{
			_route = null;
			_startTime = 0;
			_currentRouteIndex = 0;
			_currentStartX = 0;
			_currentStartY = 0;
			_currentEndX = 0;
			_currentEndY = 0;
			x = 0;
			y = 0;
			direction = -1;
		}
		public function adjust():void{
			
		}
		private function toNextRoutePoint():void{
			if(_route && _currentRouteIndex < _route.length-1){
				_currentStartX = _route[_currentRouteIndex][0];
				_currentStartY = _route[_currentRouteIndex][1];
				_currentEndX = _route[_currentRouteIndex+1][0];
				_currentEndY = _route[_currentRouteIndex+1][1];
				_currentRateX = (_currentEndX-_currentStartX)/disList[_currentRouteIndex+1][0];
				_currentRateY = (_currentEndY-_currentStartY)/disList[_currentRouteIndex+1][0];
				direction = MapUtil.getDirection(_currentStartX,_currentStartY,_currentEndY,_currentEndY);
			}
			else{
				stop();
			}
		}
		private function getCurrentTime():int{
			return getTimer();
		}
	}
}