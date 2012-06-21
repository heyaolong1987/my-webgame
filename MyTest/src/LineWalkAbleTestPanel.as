package{
	import com.netease.core.algorithm.astar.AStar;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.core.UIComponent;
	
	/**
	 * @author heyaolong
	 * 
	 * 2012-6-18
	 */ 
	public class LineWalkAbleTestPanel extends mx.core.UIComponent{
		private var mapWidth:int=1000;
		private var mapHeight:int=600;
		private var tileWidth:int=10;
		private var tileHeight:int=10;
		private var row:int = mapHeight/tileHeight;
		private var col:int = mapWidth/tileWidth;
		private var sprite:Sprite = new Sprite();
		private var arcs:Array;
		private var startPoint:Point;
		private var endPoint:Point;
		private var routeSprite:Sprite = new Sprite();
		public function LineWalkAbleTestPanel()
		{
			mouseChildren = false;
			arcs = new Array(col);
			for(var i:int=0; i<col; i++){
				arcs[i] = new Array(row);
				for(var j:int=0; j<row; j++){
					if(i==0 || i==col-1 || j ==0 || j==row-1){
						arcs[i][j] = 1;
					}else{
						arcs[i][j] = Math.floor(Math.random()*7) == 0?1:0;
					}
				}
			}
			addAllChildren();
			addEventListener(MouseEvent.CLICK,onClick);
		}
		private function addAllChildren():void{
			addChild(sprite);
			addChild(routeSprite);
			for(var i:int=0; i<col; i++){
				for(var j:int=0; j<row; j++){
					if(arcs[i][j] == 1){
						sprite.graphics.beginFill(0xff0000);
						sprite.graphics.drawRect(i*tileWidth,j*tileHeight,tileWidth,tileHeight);
						sprite.graphics.endFill();
					}
					else{
						sprite.graphics.beginFill(0x000000);
						sprite.graphics.drawRect(i*tileWidth,j*tileHeight,tileWidth,tileHeight);
						sprite.graphics.endFill();
					}
				}
			}
		}
		
		
		private function onClick(event:MouseEvent):void{
			if(startPoint==null){
				startPoint = new Point();
				startPoint.x = Math.floor(event.localX/tileWidth);
				startPoint.y = Math.floor(event.localY/tileHeight);
			}
			else if(endPoint == null){
				endPoint = new Point();
				endPoint.x = Math.floor(event.localX/tileWidth);
				endPoint.y = Math.floor(event.localY/tileHeight);
				var info:Array = AStar.BresenhamLine(startPoint.x,startPoint.y,endPoint.x,endPoint.y);
				if(info){
					setLineWalkAble(info,startPoint.x,startPoint.y,endPoint.x,endPoint.y);
				}
				startPoint = null;
				endPoint = null;
			}
		}
		public function setLineWalkAble(route:Array,sx:int,sy:int,tx:int,ty:int):void{
			routeSprite.graphics.clear();
			for(var i:int=0;i<route.length;i++){
				routeSprite.graphics.beginFill(0x00ff00);
				routeSprite.graphics.drawRect(tileWidth*route[i][0],tileHeight*route[i][1],tileWidth,tileHeight);
				routeSprite.graphics.endFill();
				
			}
			routeSprite.graphics.lineStyle(1,0xffff00);
			routeSprite.graphics.moveTo(sx*tileWidth+tileWidth/2,sy*tileHeight+tileHeight/2);
			routeSprite.graphics.lineTo(tx*tileWidth+tileWidth/2,ty*tileHeight+tileHeight/2);
			
		}
	}
}