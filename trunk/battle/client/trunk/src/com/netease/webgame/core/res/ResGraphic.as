package com.netease.webgame.core.res
{
	import com.greensock.TweenLite;
	import com.netease.webgame.core.cacher.BitmapDataCacher;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.setTimeout;

	
	/**
	 * 角色资源的处理
	 * 
	 */	
	public class ResGraphic extends Sprite
	{
		
		// 资源中不循环动作结束时调用
		public var callBack:Function = null;
		public var enterFrameCallback:Function = null;
		
		private var _bitmap:Bitmap = new Bitmap();
		private var _dir:int = 0 ;
		private var _behavior:int = 0 ;
		public var _isStop:Boolean = false;
		private var _url:String = "";
		private var _currentFrame:int = 0;
		private var _mc:MovieClip;
		private var _cb :Function = null;
		private var _tween:TweenLite;
		
		public var fullDir:Boolean = false;
		
		/**
		 *  
		 * @param url
		 * @param mc
		 * @param motionType 0 = logicFrame, 1 = Tween, 2 = setTimeout
		 * 
		 */			
		public function ResGraphic( url:String = "", mc:MovieClip = null,motionType:uint = 0,useCommonFrame:Boolean = true ):void {
			if( !mc ) return;
			
			_url = url;
			_mc = mc;
			
			mouseEnabled = false;
			
			if( motionType == 0 ){
				addEventListener(Event.ENTER_FRAME , onEnterFrame );
			} else if( motionType == 1) {
				callRunTween();
			} else {
				callRunTimeout();
			}
			addChild( _bitmap );
			
			if( useCommonFrame ) {
				if( url.indexOf("Male") > 0 || url.indexOf("Female")> 0 || url.indexOf("F_W")> 0 || url.indexOf("M_W")> 0  ){
					mc.loop = ResFrame20.getInstance().loop;
					mc.bmp = ResFrame20.getInstance().bmp;
					mc.func = ResFrame20.getInstance().func;
					fullDir = true;
				} else{
					
					trace(url);
				}
				/*
				else if(url.indexOf("MON")||url.indexOf("NPC") ) {
				mc.loop = ResFrameCreature20.getInstance().loop;
				mc.bmp = ResFrameCreature20.getInstance().bmp;
				mc.func = ResFrameCreature20.getInstance().func;
				} else {
				
				}
				*/
			}
			
			if( mc.info ){
				fullDir = true;
			}
		} 
		
		private function callRunTween():void{
			onEnterFrame(null);
			if( _tween ){
				_tween.kill();
			}
			if( !_isStop ){
				_tween = TweenLite.delayedCall(0.001,callRunTween);
			}
		}
		
		private function callRunTimeout():void{
			onEnterFrame(null);
			if( !_isStop ){
				setTimeout(callRunTimeout,5);
			}
		}
		
		public function resume() : void {
			_isStop = false;	
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function stop():void
		{
			_isStop = true;	
			removeEventListener(Event.ENTER_FRAME, onEnterFrame );
		}
		
		public function play( dir:int,behavior:int ):void
		{
			_dir = dir;
			_behavior = behavior;
			_currentFrame = behavior ;
			_isStop = false;
			update();
		}
		
		public function pauseCallback() : void {
			_cb = callBack;
			callBack = null;
		}
		
		public function resumeCallback() : void {
			if( callBack == null ){
				callBack = _cb;
			}
		}
		
		private function _play():void
		{
			if( !_mc ){
				return;
			}
			if( _mc.loop[_currentFrame] < 0 ) {
				return;
			}
			_currentFrame = _mc.loop[_currentFrame];
			// 根据类型跳帧
			if( !_mc.func[_currentFrame] && _mc.bmp[_currentFrame] == _bmp ){
				// 跳一帧
				_currentFrame = _mc.loop[_currentFrame];
			}
			
			update();		
		}
		
		private function getClassName(id,dir,bmp):String{
			var newDir :int = dir==0?8:dir;
			var className:String = id +"_"+ newDir + "_" + bmp;
			return className;
		}
		private var _bmp:int;
		private function update() : void {
			// ？？？
			//if(_isStop)
			//return;
			if(!_mc) return;
			_bmp = _mc.bmp[_currentFrame];
			var bmdOld:* = _bitmap.bitmapData;
			var bmd:* = BitmapDataCacher.getInstance().getBitmapData(getClassName(_mc.id,_dir,_bmp));
			// 某些武器关键帧缺失
			if( bmd && bmd != _bitmap.bitmapData) {
				if( !bmdOld || !bmdOld.hasOwnProperty("name") || bmdOld.name != bmd.name ){
					_bitmap.bitmapData = bmd;
					_bitmap.x = Number(bmd.xoff.toFixed(2));
					_bitmap.y = Number(bmd.yoff.toFixed(2));
					
					// 解决空图像的问题！
					if( _bitmap.x == 0 && _bitmap.y == 0 ){
						_bitmap.bitmapData = null;
					}
				}
			}		
			// 如果需要callback, 注意，必须是最后一帧才能有callBack
			if( _mc.func[_currentFrame] && callBack!= null){// 
				// 这里要停下来，否则只有一帧的动作将可能调用callBack()很多次
				//_isStop = true;
				//if(callBack != null)
				if(_isStop)
					return;
				callBack(this);
			}
		}
		
		public function getBmpData():BitmapData {
			return BitmapDataCacher.getInstance().getBitmapData(getClassName(_mc.id,_dir,_bmp) );
		}
		
		public function getDiffPoint():Point {
			return new Point(_bitmap.x,_bitmap.y);
		}
		
		public function unload():void {
			// [-- gmn
			if( parent ){
				parent.removeChild( this );
			}
			// --] 
			stop();
			if( _bitmap && _bitmap.parent ) {
				removeChild( _bitmap );
			}
			removeEventListener(Event.ENTER_FRAME, onEnterFrame );
			// [-- gmn
			callBack = null;
			enterFrameCallback = null;
			_bitmap = null;
			_mc = null;
			_cb = null;
			if(_tween)
				_tween.kill();
			// --]
		}
		
		/**
		 * 释放函数 
		 * 
		 */			
		public function destory() :void{
			if( parent ){
				parent.removeChild( this );
			}
			unload();
			callBack = null;
			enterFrameCallback = null;
			_bitmap = null;
			_mc = null;
			_cb = null;
		}
		
		private function onEnterFrame( e:Event ):void
		{
			_play();
			if(enterFrameCallback != null){
				enterFrameCallback(this);
			}
		}
		
		public function get mc():MovieClip{
			return _mc;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get behavior() : int {
			return _behavior;
		}
		
		public function get dir() : int {
			return _dir;
		}
		public function set behavior( p_val : int ) : void {
			if( _behavior != p_val || _isStop){ // @author lihebin 这里被我改了，加了 || _isStop
				play( _dir , p_val );
			}
			_behavior = p_val;
		}
		
		public function set dir( p_val : int  ) : void {
			if( _dir != p_val ){
				play( p_val , _behavior );
			}
			_dir = p_val;
		}
		
		public function get headY():Number
		{
			return _mc.headY;
		}
		
		public function get baseY():Number
		{
			return _mc.baseY;
		}
		
		public function get baseX():Number{
			return _mc.baseX;
		}
		public function get bitmap():Bitmap{
			return _bitmap;
		}
		
		public override function set x(value:Number):void{
			super.x = value;
		}
		public override function set y(value:Number):void{
			super.y = value;
		}
	}
}