package com.netease.core.utils{
	/**
	 * @author heyaolong
	 * 
	 * 2012-5-16
	 */ 
	public class NumberUtil{
		/**
		 * @param value，原始数值
		 * @param precision，保留的小数位数，默认值为0，返回整数
		 * @return 
		 */ 
		public static function round(value:Number, precision:int=0):Number {
			precision = Math.pow(10, precision);
			return Math.round(value*precision)/precision;
		}
		
		/**
		 * @param value，原始数值
		 * @param precision，保留的小数位数，默认值为0，返回整数
		 * @return 
		 */ 
		public static function ceil(value:Number, precision:int=0):Number {
			precision = Math.pow(10, precision);
			return Math.ceil(value*precision)/precision;
		}
		
		/**
		 * @param value，原始数值
		 * @param precision，保留的小数位数，默认值为0，返回整数
		 * @return 
		 */ 
		public static function floor(value:Number, precision:int=0):Number {
			precision = Math.pow(10, precision);
			return Math.floor(value*precision)/precision;
		}
		
		/**
		 * 将value转换成百分比显示。
		 * @Param
		 * 	value: 原始数值
		 *  precision: 保留位数(百分比后的位数)
		 *  round: 四舍五入或则舍弃
		 */ 
		public static function convert2Percent(value:Number, precision:int = 0, round:Boolean = true):String {
			var rtnNum:Number = isNaN(value)?0:value * 100;
			return (round ? NumberUtil.round(rtnNum, precision) : NumberUtil.floor(rtnNum, precision)) + "%";
		}
		
		/**
		 * 返回带正负符号的数字
		 * @param value
		 * @param toPer是否将数字转化成百分数
		 * @param needCovert2Int是否需要在转化成百分数时将数字*100；
		 * @return 
		 * 
		 */		
		public static function getNumberStrWithSymbol(value:Number, toPer:Boolean = false, needCovert2Int:Boolean = true):String {
			var numStr:String;
			if (toPer) {
				if (needCovert2Int) {
					numStr = convert2Percent(value);
				}else {
					numStr = convert2Percent(value/100);
				}
				
			}else {
				numStr = value.toString();
			}
			if (value > 0) {
				return '+' + numStr;
			}else if (value < 0) {
				return numStr;
			}
			return numStr;
		}
		
		public static function setFigure(value:Number):String {
			var result:String = String(Math.abs(value));
			var index:int;
			var end:String;
			if(result.indexOf(".")!=-1) {
				end = result.substr(result.indexOf("."));
				result = result.substr(0, result.indexOf("."));
			}
			for(index=result.length-3; index>0; index-=3) {
				result = result.substr(0, index) + "," + result.substr(index);
			}
			if(value<0) {
				result = "-" + result;
			}
			if(end!=null) {
				result = result + end;
			}
			return result;
		}
		
		/**
		 * 根据颜色码返回颜色字串
		 * @color 如：0xff0000
		 * @return 如：#ff0000
		 ***/
		public static function getColorStr(color:uint):String {
			var str:String = color.toString(16);
			var length:int = str.length;
			for(var i:int=length; i<6; i++) {
				str = "0" + str;
			}
			return "#"+str;
		}
		/**
		 * 格式成两位数,不考虑负数
		 * 如果是个位,自动添加一个0
		 * @num 如：5
		 * @return 如：05
		 ***/
		public static function getDoubleNumStr(num:uint):String {
			if(num<10){
				return "0"+num.toString();
			} else {
				return num.toString();
			}
		}
	}
}