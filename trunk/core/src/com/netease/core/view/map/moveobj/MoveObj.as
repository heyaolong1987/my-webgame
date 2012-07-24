package com.netease.core.view.map.moveobj{
	import com.netease.core.display.ResGraphic;
	import com.netease.core.model.vo.map.moveobj.MoveObjVO;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * @author heyaolong
	 * 
	 * 2012-5-17
	 */ 
	public class MoveObj extends Sprite{
		public var moveData:MoveObjVO;
		private var _model:ResGraphic;
		private var  _dirChanged:Boolean = true;
		private var _avtar:Sprite = new Sprite();
		public function MoveObj(moveData:MoveObjVO)
		{
			this.moveData = moveData;
			var txt:TextField = new TextField();
			if(moveData.name){
				txt.text = moveData.name;
			}
			txt.textColor = 0xff0000;
			txt.cacheAsBitmap = true;
			addChild(txt);
			addChild(_avtar);
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		protected function loadModelRes():void{
			ResLoader.getInstance().load(url,this,loadModelComplete);
		}
		protected function loadModelComplete(client:Object,data:Object):void{
			_model = new ResGraphic(data as MovieClip);
		}
		
		public function dispose():void{
			
		}
		public function run():void{
			moveData.run();
			if(_dirChanged){
				_url = "../res/model/"+1001+"_"+moveData.dir+".swf";
				loadModelRes();
				_dirChanged = false;
			}
			_avtar.graphics.clear();
			if(_model){
				_avtar.graphics.beginBitmapFill(_model.bitmapData);
			}
		}
	}
}