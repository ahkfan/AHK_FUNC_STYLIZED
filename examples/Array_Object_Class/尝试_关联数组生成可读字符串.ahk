/*
obj_str_maker() 将AHK对象类型数据转换为可读的字符串, 用于debug
目前只做了格式生成, 之后考虑加入此类型字符串解析
*/

a := {"abcde": {"mixga": 123, 2: "6247"}
	, "parent":"unknown"
	, 5: [12345566, 9992345]
	, "kkl":{"adsbv": 523, "64ksdfc": [12345, 7345]}
	, "sss":{}}

MsgBox, % obj_str_make(a)
return

obj_str_make(obj, level := 0, objTag := "______obj_", foreOperate := "...", foreEnd := "|", End := "|") 
{
	static obj_Empty := "emp"
	static obj_keyNumOnly := "list"
	static obj_keyWithoutNum := "dict"
	static obj_keyBothNumWord := "mix"

	if (!isobject(obj) && !level)
	{
		return {"result": false, "detail" : "obj_str_maker() warning:`nthe First param is not a object`nDetail: " obj}
	}
		
	fore := ""
	Loop, % level
	{
		fore .= foreOperate
	}
		
	for key, var in obj 
	{

		if IsObject(var) 
		{
			i := 0
			for k in var
			{
				if k is integer
					i += 1
			}
				
			len := var.count()
			ret .= fore . foreEnd . key "=" objTag . (len ? (var.MaxIndex() ? ((i = len) ? obj_keyNumOnly : obj_keyBothNumWord) : obj_keyWithoutNum) : obj_Empty) End "`r`n" obj_str_make(var, level+1, objTag, foreOperate, foreEnd)
		} 
		else 
		{
			ret .= fore . foreEnd . key "=" RegExReplace(RegExReplace(var, "`r", "\r"), "`n", "\n") End "`r`n"
		}
	}

	;~ 添加行首
	if not level 
	{
		i := 0
		len := obj.count()
		for k in obj
		{
			if k is integer
				i += 1
		}
		ret :=  "___ROOT___=" objTag . (len ? (obj.MaxIndex() ? ((i = len) ? obj_keyNumOnly : obj_keyBothNumWord) : obj_keyWithoutNum) : obj_Empty) . End "`r`n" . ret . "_________`r`n" . "___END___"
	}
	return ret
}


