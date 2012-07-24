package com.netease.core.view.map.layer{
	import com.netease.core.view.map.scene.SceneMap;
	import com.netease.model.vo.moveobj.CharVO;
	import com.netease.view.map.moveobj.Char;
	
	import flash.display.Scene;
	import flash.display.Sprite;

	/**
	 * @author heyaolong
	 * 
	 * 2012-7-24
	 */ 
	public class MoveLayer extends Sprite{
		private var _scene:SceneMap;
		private var _mapWidth:int;
		private var _mapHeight:int;
		public function MoveLayer(scene:SceneMap){
			_scene = scene;
			mouseChildren = false;
			mouseEnabled = false;
		}
		/**
		 *每帧调一次 
		 * 
		 */
		public function run():void{
			for each(var char:Char in _scene.charDic){
				char.run();
			}
		}
		
	}
}