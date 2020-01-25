/*  数组与关联数组

arr := arr()

arr.cpy(arr)

arr.swapKeyVar(arr)

arr.print(arr)

*/


arr()
{
	return __ClASS_AHKFS_ARRAY
}

class __ClASS_AHKFS_ARRAY
{
	;-------------------------------------------
	cpy(arr)
	{
		/*
			简介: 完全拷贝一个对象, 无法拷贝class中的方法, cpy = copy

			参1: arr 	{object}	任意层级的数组

			返回值:		(object)	返回对象与源对象无引用关系
		*/
		local
		switch type(arr)
		{
			case "Array":
				ret := []
				for _,v in arr
				{
					if IsObject(arr)
						ret.Push(arr_cpy(ret))
					ret.Push(v)
				}
			case "Associative Array":
				ret := {}
				for k,v in arr
				{
					if IsObject(arr)
						ret[k] := arr_cpy(ret)
					ret[k] := v
				}
			Default:
				Throw Exception("Invaild Value! Need an array, but pass a(n) " . type(arr), -1)
		}
		return ret
	}

	;-------------------------------------------
	swapKeyVar(arr)
	{
		/*
			简介: 调换 数组 的 键值对 (trans key var), 不建议多维复杂类型的数组使用

			参1: arr {Object}

			返回值: {Array}
		*/
		local
		if type(arr) != "Associative Array"
			Throw Exception("Invaild Value! Need an associative array, but pass a(n) " . type(array), -1)
		ret := {}
		for key, var in arr
			ret[var] := key
		return ret
	}

	;-------------------------------------------
	print(arr)
	{
		/*
		简介: 返回一个字符串形式的数组, 返回形式与ahk的定义形式相同: 如下
				[items*, [items*], {key: value}, ……]
		*/
		local
		ret := ""
		switch type(arr)
		{
			case "Array":
				ret .= "["
				for _, v in arr
				{
					if IsObject(v)
						ret .= arr_print(v) . ", "
					else if type(v) == "String"
						ret .= """" . v . """" . ", "
					else
						ret .= v . ", "
				}
				ret := SubStr(ret, 1, -2)
				ret .= "]"
			case "Associative Array":
				ret .= "{"
				for k,v in arr
				{
					if IsObject(v)
						ret .= """" . k . """" . ": " . arr_print(v) . ", "
					else if type(v) == "String"
						ret .= """" . k . """" . ": " . """" . v . """" . ", "
					else
						ret .= """" . k . """" . ": " . v . ", "
				}
				ret := SubStr(ret, 1, -2)
				ret .= "}"
			Default:
				Throw Exception("Invaild Value! Need an array, but pass a(n) " . type(arr), -1)
		}
		return ret
	}
	;-------------------------------------------
}