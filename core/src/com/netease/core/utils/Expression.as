package com.netease.core.utils{
	import flash.display3D.IndexBuffer3D;

	/**
	 * @author heyaolong
	 * 对表达式进行计算，支持+ - * / ()操作符,支持传入参数，参数名必须为英文字符，不支持负数常量，最大精度为4位小数
	 * 2012-5-16
	 */ 
	public class Expression{
		private static const STRING_TYPE_OPERATOR:int = 0;
		private static const STRING_TYPE_NUMBER:int = 1;
		private static const STRING_TYPE_VARIABLE:int = 2;
		public function Expression()
		{
		}
		private static function getRpnExpression(exp:String):Array
		{
			var rpnStack:Array = [];
			var opStack:Array = [];
			var len:int = exp.length;
			var digit:String = "";
			var digitType:int;
			for(var i:int=0; i<len; i++)
			{
				var char:String = exp.charAt(i);
				//如果是数字或小数点，添加到数字字符串中
				if((char>="0" && char<="9") || char=="."){
					if(digit.length == 0){
						digitType = STRING_TYPE_NUMBER;
					}
					digit = digit + char;
				}
				else if((char>="a" && char<="z") || (char>="A"&&char<="Z")){
					if(digit.length == 0){
						digitType = STRING_TYPE_VARIABLE;
					}
					digit = digit + char;
				}
				else if(isOperator(char))//如果是运算符
				{
					if(digit.length>0)
					{
						rpnStack.push([digitType,digit]);
						digit="";
					}
					//弹出操作符并添加到逆波兰表达式，直至遇到左括号或优先级较低的操作符
					while(opStack.length>0)
					{
						var op:String =String(opStack.pop());
						if(op =="(" || getOpPriority(op)<getOpPriority(char)){
							opStack.push(op);
							break;
						}
						else{
							rpnStack.push([STRING_TYPE_OPERATOR,op]);
						}
					}
					//将当前操作符压入堆栈中
					opStack.push(char);
				}
				else if(char=="(")//遇到左括号，直接压入堆栈中
				{
					opStack.push(char);
				}
				else if(char==")")//遇到右括号
				{
					if(digit.length>0)//先将数字添加到逆波兰表达式
					{
						rpnStack.push([digitType,digit]);
						digit="";
					}
					while(opStack.length>0)//弹出运算符并添加到逆波兰表达式，直至遇到左括号
					{
						var op:String = String(opStack.pop());
						if(op == "(")
						{
							break;
						}
						else
						{
							rpnStack.push([STRING_TYPE_OPERATOR,op]);
						}
					}           
				}
				
			}
			//到达字符串末尾后，首先将数字添加到逆波兰表达式
			if(digit.length > 0)
			{
				rpnStack.push([digitType,digit]);
			}
			//弹出所有操作符并添加到逆波兰表达式
			while(opStack.length > 0)
			{
				var op:String = String(opStack.pop());
				rpnStack.push([STRING_TYPE_OPERATOR,op]);
			}
			return rpnStack;
		}
		private static function isOperator(value:String):Boolean{
			if(value == "+" || value =="-" || value == "*" || value == "/"){
				return true;
			}
			return false;
		}
		private static function getOpPriority(op:String):int
		{
			switch(op)
			{
				case "+":
				case "-":
					return 1;
				case "*":
				case "/":
					return 2;
				default:
					return 0;
			}
		}
		
		/**
		 * 获取表达式的值，传入表达式和需要替换的参数值
		 * @param exp
		 * @param args
		 * @param precision 每次中间运算结果的精度
		 * @return 
		 * 
		 */
		public static function getValue(exp:String,args:Object,precision:int=4):Number
		{
			return getValueByRpn(getRpnExpression(exp),args,precision);
		}
		private static function getValueByRpn(rpnExp:Array,args:Object,precision):Number
		{
			var len:int = rpnExp.length;
			var stack:Array = [];
			for(var i:int=0; i<len; i++)
			{   
				var s:Array =rpnExp[i];
				if(s[0] == STRING_TYPE_NUMBER){
					stack.push(s[1]);
				}
				else if(s[0] == STRING_TYPE_VARIABLE){
					stack.push(args[s[1]]);
				}
				else if(s[0] == STRING_TYPE_OPERATOR){
					var b:Number = Number(stack.pop());
					var a:Number = Number(stack.pop());
					var result:Number = getOpValue(a,b,s[1],precision);
					stack.push(result);
				}
			}
			return stack[0];
		}
		private static function getOpValue(a:Number, b:Number, op:String,precision:int):Number
		{
			a = NumberUtil.round(a,precision);
			b = NumberUtil.round(b,precision);
			var result:Number;
			switch(op)
			{
				case "+":
					result = a+b;
					break;
				case "-":
					result = a-b;
					break;
				case "*":
					result = a*b;
					break;
				case "/":
					result = a/b;
					break;
				default:
					result =  0;
			}
			return NumberUtil.round(result,precision);
		}
	}
}