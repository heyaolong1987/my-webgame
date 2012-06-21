package com.netease.model.vo.moveobj{
	import com.netease.model.constants.MapConstants;

	/**
	 * @author heyaolong
	 * 
	 * 2012-5-23
	 */ 
	public class PlayerVO extends CharVO{
		
		public function PlayerVO()
		{
			type = MapConstants.MOVE_OBJ_TYPE_PLAYER;
		}
	}
}