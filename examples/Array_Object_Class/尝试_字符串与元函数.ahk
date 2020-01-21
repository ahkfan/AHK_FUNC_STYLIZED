/* 注释记录: 元函数仅能作为基类使用

元函数的作用: 继承了元函数的实例对象 针对 访问 键 的3种特定形式而生效
具体表现是元函数可定义的3种方法:
	__Get(键)				;~ 实例对象 (对		不存在的键		访问/取值) 	时 执行, 传递参数为	首位键:  obj.首位键.次位键, 次位键不做传递参数
	__Set(键, 值)			;~ 实例对象 (给		任意键			赋值) 		时 执行, 传递参数为	首位键:	obj.键 := 123,
	__Call(键方法, 值数组*)	;~ 实例对象 (调用	不存在的键方法)				时 执行, 传递参数为键(键函数名), 传入的参数


元函数的定义: 元函数是作为 基类 而存在的, 用于 对象 的 继承

class Meta_Function {

	__Get() {

	}

	__Set() {

	}

	__Call() {

	}
}

实例对象继承元函数的方法
	方法1:
	obj := {base: Meta_Function}

	方法2:
	obj := {}
	obj.base := Meta_Function

	方法3:
	或如此以类定义形式设定基类, 继承元函数
	class obj extends Meta_Function
	{

	}

字符串可做元函数继承
"".base.base := 元函数名

该元函数的 this 变量中保存变量, 但this 与 字符串本身的地址不同

*/


"".base.base := String_Meta_Function
a := "是的,一切都是"
MsgBox, % a.toCharLs()[2]
msgbox, % a.len
return

;~ 字符串 元函数
class String_Meta_Function 
{
	;----------------------------------------
	;~ 调用不存在的键时, 即访问属性
	__Get(key) {
		static strPGet := String.Property_Get

		;~ 访问空键时或不存在方法时
		if not  ((key <> "") && strPGet.haskey(key)) {
			return ""
		}
		return strPGet[key](this)
	}


	;----------------------------------------
	;~ 尚不明确在元函数中取得字符串地址改变字符串本身内容的方法
	__Set(key, var) {
		static  strPSet := String.Property_Set

		return
	}


	;----------------------------------------
	;~ 调用不存在的键方法时调用该元函数方法
	__Call(method, args*) {
		static  strFunc := String.Functions

		;~ 访问空键时或不存在方法时
		if not  ((method <> "") && strFunc.haskey(method)) {
			return ""
		}

		;~ 存在对应方法时, 传递: 参数1 字符串本身 参数2 参数长度 和 所有参数
		return strFunc[method](this, args.count(), args*)
	}
}

;~ 字符串 属性与方法
class String {

	;~ 元函数 __Call() 跳转
	class Functions {

		;~ 将字符串转换为字符列表
		toCharLs(str) {
			return strsplit(str)
		}

	}

	;~ 元函数 __Get() 跳转
	class Property_Get {

		;~ 取得字符串长度
		len(str) {
			return strlen(str)
		}
	}

	;~ 元函数 __Set() 跳转, 未明确
	class Property_Set {

	}
}
