package com.netease.core.view.map.moveobj{
	import com.netease.core.interfaces.IPreciseClickAble;
	import com.netease.core.model.vo.map.moveobj.MoveObjVO;
	import com.netease.core.res.ClassLoader;
	import com.netease.core.res.ResLoader;
	import com.netease.view.map.avatar.AvatarPart;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	
	/**
	 * @author heyaolong
	 * 
	 * 2012-5-17
	 */ 
	public class MoveObj extends Sprite implements IPreciseClickAble{
		public var moveData:MoveObjVO;
		private var _model:AvatarPart;
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
			txt.y = -10;
			addChild(txt);
			addChild(_avtar);
			mouseChildren = false;
			mouseEnabled = false;
			_model = new AvatarPart();
		}
		protected function loadModelRes():void{
			var url:String = "../res/stage/model/1001.swf";
			ResLoader.getInstance().load(url,loadModelComplete,null);
		}
	
		protected function loadModelComplete(mc:MovieClip,args:Array):void{
			
		}
		
		public function dispose():void{
			
		}
		public function run():void{
			moveData.run();
			if(_dirChanged){
				loadModelRes();
				_dirChanged = false;
			}
			_model.setUrl("../res/stage/model/1001.swf");
			_model.setId("mode_1001_2"+"_"+moveData.dir,_model.currentFrame);
			_model.run();
			_avtar.graphics.clear();
			if(_model.bitmapData){
				var matrix:Matrix = new Matrix(1,0,0,1,-100,-170);
				_avtar.graphics.beginBitmapFill(_model.bitmapData,matrix);
				_avtar.graphics.drawRect(-100,-170,_model.bitmapData.width,_model.bitmapData.height);
				_avtar.graphics.endFill();
			}
		}
	}
}