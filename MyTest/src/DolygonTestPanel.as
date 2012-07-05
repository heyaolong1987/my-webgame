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
	 * 2012-7-4
	 */ 
	public class DolygonTestPanel extends UIComponent{
		private var mapWidth:int=1000;
		private var mapHeight:int=600;
		private var tileWidth:int=100;
		private var tileHeight:int=100;
		private var row:int = mapHeight/tileHeight;
		private var col:int = mapWidth/tileWidth;
		private var sprite:Sprite = new Sprite();
		private var arcs:Array;
		private var startPoint:Point;
		private var endPoint:Point;
		private var routeSprite:Sprite = new Sprite();
		
		private var flag:Array;
		public function DolygonTestPanel()
		{
			mouseChildren = false;
			arcs = new Array(col);
			flag = new Array(col);
			for(var i:int=0; i<col; i++){
				arcs[i] = new Array(row);
				flag[i] = new Array(row);
				for(var j:int=0; j<row; j++){
					flag[i][j] = 0;
					if(i==0 || i==col-1 || j ==0 || j==row-1){
						arcs[i][j] = 1;
					}else{
						arcs[i][j] = Math.floor(Math.random()*2.5) == 0?1:0;
					}
				}
			}
			bfs();
			addAllChildren();
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
					
					var txt:TextField = new TextField();
					txt.textColor = 0x00ff00;
					txt.x = i*tileWidth;
					txt.y = j*tileHeight;
					txt.text = flag[i][j];
					routeSprite.addChild(txt);
					//routeSprite.graphics.beginFill(0xff0000);
					//routeSprite.graphics.drawRect(,tileWidth,tileHeight);
					//routeSprite.graphics.endFill();
				}
			}
		}
		private function bfs():void{
			var addArr:Array = [[0,1],[-1,0],[0,-1],[1,0]];
			var i:int,j:int,k:int,x:int,y:int,tx:int,ty:int;
			var id:int = 1;
			for(i=0; i<col; i++){
				for(j=0; j<row; j++){
					if(flag[i][j]==0){
						id = dfs(arcs,flag,i,j,id,0);
					}
				}
			}
		}
		private function dfs(arcs:Array,flag:Array,x:int,y:int,id:int,d:int):int{
			flag[x][y] = id;
			var addArr:Array = [[0,1],[1,0],[0,-1],[-1,0]];
			var i:int;
			var tx:int;
			var ty:int;
			for(i=0;i<4;i++){
				tx = x+addArr[(i+d)%4][0];
				ty = y+addArr[(i+d)%4][1];
				if(tx>=0&&tx<col && ty>=0 && ty<row){
					if(flag[tx][ty] == 0 && arcs[x][y] == arcs[tx][ty]){
						id =  dfs(arcs,flag,tx,ty,id+1,(i+d+3)%4);
					}
				}
			}
			return id;
		}
		
	}
}