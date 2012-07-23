package com.netease.model.vo.moveobj{
	import com.netease.core.model.vo.map.moveobj.MoveObjVO;
	import com.netease.model.constants.MapConstants;

	/**
	 * @author heyaolong
	 * 角色VO
	 * 2012-5-23
	 */ 
	public class CharVO extends MoveObjVO{
		public var race:int;
		public var teamId:int;
		public var hp:int;
		public var maxHp:int;
		public var mp:int;
		public var maxMp:int;
		
		public function CharVO()
		{
			type = MapConstants.MOVE_OBJ_TYPE_CHAR;
		}
	}
}