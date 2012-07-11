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
	public class AstarTestPanel extends mx.core.UIComponent{
		private var mapWidth:int=1000;
		private var mapHeight:int=600;
		private var tileWidth:int=40;
		private var tileHeight:int=40;
		private var row:int = mapHeight/tileHeight;
		private var col:int = mapWidth/tileWidth;
		private var sprite:Sprite = new Sprite();
		private var arcs:Array;
		private var startPoint:Point;
		private var endPoint:Point;
		private var routeSprite:Sprite = new Sprite();
		public function AstarTestPanel()
		{
			mouseChildren = false;
			arcs = new Array(col);
			for(var i:int=0; i<col; i++){
				arcs[i] = new Array(row);
				for(var j:int=0; j<row; j++){
					if(i==0 || i==col-1 || j ==0 || j==row-1){
						arcs[i][j] = 1;
					}else{
						arcs[i][j] = Math.floor(Math.random()*2) == 0?1:0;
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
				var info:Array = AStar.find(arcs,startPoint.x,startPoint.y,endPoint.x,endPoint.y);
				if(info){
					var route:Array = info[0];
					var path:Array = info[1];
					var hasVisitArr:Array = info[2];
					if(route){
						setRoute(route,path,hasVisitArr);
					}
				}
				
				startPoint = null;
				endPoint = null;
			}
		}
		private var txtArr:Array = [];
		public function setRoute(route:Array,path:Array,hasVisitArr:Array):void{
			routeSprite.graphics.clear();
			for(var i:int=0;i<txtArr.length;i++){
				removeChild(txtArr[i]);
				
			}
			txtArr = [];
			for(var i:int=0; i<col; i++){
				for(var j:int=0; j<row; j++){
					if(hasVisitArr[i]&&hasVisitArr[i][j]){
						routeSprite.graphics.beginFill(0x00ff00);
						routeSprite.graphics.drawRect(i*tileWidth,j*tileHeight,tileWidth,tileHeight);
						routeSprite.graphics.endFill();
						var txt:TextField = new TextField();
						txt.text = hasVisitArr[i][j][1].value;
						txt.x = i*tileWidth;
						txt.y = j*tileHeight;
						txt.textColor = 0x0000ff;
						addChild(txt);
						txtArr.push(txt);
					}
				}
			}
			
			routeSprite.graphics.moveTo(route[0][0]*tileWidth+tileWidth/2,route[0][1]*tileHeight+tileHeight/2);
			for(var i:int=1;i<route.length;i++){
				routeSprite.graphics.lineStyle(3,0x0000ff);
				routeSprite.graphics.lineTo(route[i][0]*tileWidth+tileWidth/2,route[i][1]*tileHeight+tileHeight/2);
			}
			
			routeSprite.graphics.moveTo(path[0][0]*tileWidth+tileWidth/2,path[0][1]*tileHeight+tileHeight/2);
			for(var i:int=1;i<path.length;i++){
				routeSprite.graphics.lineStyle(3,0xff0000);
				routeSprite.graphics.lineTo(path[i][0]*tileWidth+tileWidth/2,path[i][1]*tileHeight+tileHeight/2);
			}
			
		}
	}
}