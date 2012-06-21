package com.netease.model.vo.moveobj{
	import com.netease.model.constants.MapConstants;

	/**
	 * @author heyaolong
	 * 
	 * 2012-5-23
	 */ 
	public class OtherPlayerVO extends CharVO{
		
		public function OtherPlayerVO()
		{
			type = MapConstants.MOVE_OBJ_TYPE_OTHER_PLAYER;
		}
	}
}