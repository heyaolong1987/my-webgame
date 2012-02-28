package com.netease.webgame.bitchwar.utils {
	
	
	
	public class DateUtil {
		
		public static const NORMAL_FORMATTER:String = "YYYY-MM-DD hh:mm:ss";
		public static const MILLIS_PER_DAY:Number = 86400000;
		public static const MILLIS_PER_HOUR:Number = 3600000;
		public static const SECOND_PER_HOUR:Number = 3600;
		
		public function DateUtil() {
			
		}
		/**
		 * 时间格式化函数
		 * @param format，含有通配符的时间格式
		 * 		Y表示年份，支持2位或者4位，1996年，96年
		 * 		M表示月份，支持1位或者2位，1位没有前导0（即1月显示为1月，如果是2位则显示01月）
		 * 		D表示日期，支持1位或者2位，1位没有前导0
		 * 		h表示当前小时，支持1位或者2位，1位没有前导0（目前是24小时制，如有需要12小时制，请自选修改并写明注释）
		 * 		m表示当前分钟，支持1位或者2位，1位没有前导0
		 * 		s表示当前秒数，支持1位或者2位，1位没有前导0
		 * 		
		 * 		YYYY-MM-DD hh:mm:ss	——>	2009-09-23 12:00:00
		 * 		YYYY-M-D h:m:s	——>	2009-9-23 12:0:0
		 * 		YYYY年M年D日 h时m分s秒	——>	2009年9月23日 12时0分0秒
		 * 		
		 * @return 替换后的时间格式
		 */ 
		public static function formatDateTimeFromDate(date:Date, format:String="YYYY-MM-DD hh:mm:ss"):String {
			format = formatTimePart(/Y+/, format, date.fullYear);
			format = formatTimePart(/M+/, format, date.month+1);
			format = formatTimePart(/D+/, format, date.date);
			format = formatTimePart(/h+/, format, date.hours);
			format = formatTimePart(/m+/, format, date.minutes);
			format = formatTimePart(/s+/, format, date.seconds);
			return format;
		}
		
		/**
		 * 参见formatDateTimeFromDate函数
		 */ 
		public static function formatDateTime(time:Number, format:String="YYYY-MM-DD hh:mm:ss"):String {
			time = Math.max(time, 0);
			return formatDateTimeFromDate(new Date(time), format);
		}
		
		/**
		 * 精确到小时，超过24小时也以小时计
		 */ 
		public static function formatTimeHours(ms:Number, format:String="h小时m分s秒", showZeroValue:Boolean=false):String {
			ms = Math.max(ms, 0);
			var timeMs:int = ms / 1000;
			var seconds:int = timeMs % 60;
			var minutes:int = (timeMs / 60) % 60;
			var hours:int = (timeMs / 3600);
			format = formatTimePart(/h+/, format, hours);
			format = formatTimePart(/m+/, format, minutes);
			format = formatTimePart(/s+/, format, seconds);
			if(!showZeroValue){
				var reg:RegExp = /\d+\D+/g;
				var zeroReg:RegExp = /\d+/;
				var result:Object;
				var zeroObj:Object;
				var zeroStr:String;
				while(result=reg.exec(format)) {
					zeroObj = zeroReg.exec(result[0]);
					if(zeroObj){
						zeroStr = zeroObj[0];
						if(parseInt(zeroStr)==0){
							reg.lastIndex = 0;
							format = format.replace(result[0], "");
						}
					}
					//在这里直接返回，因为若在这里不返回的话。　01:00:00后面的秒数会被处理，从而变成01:00
					return format;
				} 
			}
			return format;
		}
		
		/**
		 * 精确到天，超过24小时以天计
		 */ 
		public static function formatTime(ms:Number, format:String="D天h小时m分s秒", showZeroValue:Boolean=false):String{
			ms = Math.max(ms, 0);
			var timeMs:Number = ms / 1000;
			var seconds:int = timeMs % 60;
			var minutes:int = (timeMs / 60) % 60;
			var hours:int = (timeMs / 3600) % 24;
			var days:int = (timeMs / 86400);
			format = formatTimePart(/D+/, format, days);
			format = formatTimePart(/h+/, format, hours);
			format = formatTimePart(/m+/, format, minutes);
			format = formatTimePart(/s+/, format, seconds);
			if(!showZeroValue){
				var reg:RegExp = /\d+\D+/g;
				var zeroReg:RegExp = /\d+/;
				var result:Object;
				var zeroObj:Object;
				var zeroStr:String;
				while(result=reg.exec(format)) {
					zeroObj = zeroReg.exec(result[0]);
					if(zeroObj){
						zeroStr = zeroObj[0];
						if(parseInt(zeroStr)==0){
							reg.lastIndex = 0;
							format = format.replace(result[0], "");
						}
					}
					//在这里直接返回，因为若在这里不返回的话。　01:00:00后面的秒数会被处理，从而变成01:00
					return format;
				} 
			}
			return format;
		}
		
		public static function generateTime(ms:Number):String {
			ms = Math.max(ms, 0);
			var timeMs:Number = (ServerTimer.timeVO.sysTime - ms) / 1000;
			var seconds:int = timeMs % 60;
			var minutes:int = (timeMs / 60) % 60;
			var hours:int = (timeMs / 3600) % 24;
			var days:int = (timeMs / 86400);
			if(days>30){
				return "一个月前";
			}
			else if(days>6){
				return "一周前"
			}
			else if(days>0){
				return days + "天前";
			}
			if(hours>0){
				return hours + "小时前";
			}
			if(minutes>29){
				return "半小时前";
			}
			if(minutes>0){
				return minutes + "分钟前";
			}
			return "刚才";
		}
		
		/**
		 * 检查是否是同一天
		 * @param offsetMilliSeconds 偏移毫秒数，譬如检测标志时间点是8点，则昨天的12点和今天的7点都是同一天，此时传递8×3600×1000<br>默认是0，代表凌晨0点
		 */ 
		public static function checkTheSameDay(current:Number, target:Number, offsetMilliSeconds:Number=0):Boolean {
			if(isNaN(target)) {
				return false;
			}
			return formatDateTime(current-offsetMilliSeconds, "YYYYMMDD")==formatDateTime(target-offsetMilliSeconds, "YYYYMMDD");
		}
		
		public static function checkCoolDown(current:Number, target:Number, interval:Number):Boolean {
			if(isNaN(target)) {
				return true;
			}
			return (current-target)>=interval;
		}
		
		private static function formatTimePart(reg:RegExp, format:String, value:int):String {
			var item:Array;
			var result:String;
			var string:String;
			while(item = reg.exec(format) as Array){
				result = item[0];
				string = String(value);
				while(string.length<result.length){ //如果实际长度小于格式化长度
					string = "0" + string;
				}
				format = format.replace(reg, string);
			}
			return format;
		}
		/***
		 * 根据presenttime获取可用时间段描述，用于任务以及任务道具使用时间限制
		 * @return 含有三个字串元素的数组(不限制则某元素为"")，[当天的时间段限制, 星期几限制, 年月日限制]
		 * @param preTime 时间段需求值，为一个6个元素的数组，2个2个的分，分别代表当天的时间段限制、星期几限制、年月日限制
		 * r[0] = timesInDay != null ? timesInDay.getFirst() : 0;
		 * r[1] = timesInDay != null ? timesInDay.getSecond() : 0;
		 * r[2] = daysInWeek != null ? daysInWeek.getFirst() : 0;
		 * r[3] = daysInWeek != null ? daysInWeek.getSecond() : 0;
		 * r[4] = times != null ? times.getFirst() : 0;
		 * r[5] = times != null ? times.getSecond() : 0;
		 ***/
		public static function generateCanUseTimeStr(preTime:Array):Array {
//			var rtn:Array = ["不限制一天中使用时间段", "不限制一周中使用日", "不限制使用年月日"];
			var rtn:Array = ["", "", ""];
			if(preTime==null || preTime.length!=6){
				return rtn;
			}
			//
			if(preTime[1] > 0) {
//				var curTimeInDay:Number = preTime[0] / 1000;
//				var hour:Number = curTimeInDay/3600;
//				var minute:Number = curTimeInDay%3600/60;
				rtn[0] = int(preTime[0] / 1000 / 3600) + ":" +  NumberUtil.getDoubleNumStr(preTime[0] / 1000 % 3600 / 60) + " - " +
					int(preTime[1] / 1000 / 3600) + ":" +  NumberUtil.getDoubleNumStr(preTime[1] / 1000 % 3600 / 60);				
			}
			if(preTime[3] > 0) {
				if(preTime[3] == 7){
					rtn[1] = "星期" + preTime[2] + " - 星期天";
				}else {
					rtn[1] = "星期" + preTime[2] + " - 星期" + preTime[3];
				}
				
			}
			if(preTime[5] > 0) {
				rtn[2] = formatDateTimeFromDate(new Date(preTime[4]), "YYYY-MM-DD") + " - " + formatDateTimeFromDate(new Date(preTime[5]), "YYYY-MM-DD");
			}
			return rtn;
		}
		
		/**
		 *根据当前时间,获得问候语, 
		 * 问候语：上午好（0：00-12：00）、中午好(12:00-14:00)、晚上好(18:00-24:00)  
		 */		
		public static function getTimeWords(date:Date):String {
			//date.hours返回的是0-23,所以需要+1便于理解
			var hours:Number = date.hours+1;
			if(hours < 12){
				return "上午好";
			}
			if(hours >= 12 && hours <= 14){
				return "中午好";
			}
			if(hours >= 18 && hours <= 24){
				return "晚上好";
			}
			return null;
		}
		
		
		/**
		 * 取到当天确切时间
		 */
		public static function getMillisecondsByDate(date:Date):Number {
			var hours:Number = date.hours * 3600 * 1000;
			var minutes:Number = date.minutes * 60 * 1000;
			var seconds:Number = date.seconds * 1000;
			var milliseconds:Number = date.milliseconds
			var dateTime :Number = hours + minutes + seconds + milliseconds
			return dateTime;
		}
	}
}