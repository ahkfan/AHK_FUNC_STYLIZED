; 数组与关联数组
arr_cpy(arr) {
	/*
		简介: 完全拷贝一个对象, 无法拷贝方法 (copy)

		原型: 无

		形参:
			[1] obj - type(object)
				任意层级的对象

		返回值:
			type(object)
			返回对象与源对象无引用关系

		测试:
		a := {"abc": {"ddd": 222, "ggg": 333}, "bcd":567}
		b := array_cpy(a)
		a.abc.ddd := 555
		MsgBox, % a.abc.ddd "-" b.abc.ddd
	*/

	if not isobject(arr) {
		ret := arr
	} else {
		ret := {}
		for k, v in arr
			ret[k] := arr_cpy(v)
	}
	return ret
}

arr_tkv(arr) {
	/*
		简介: 调换 数组 的 键值对 (trans key var), 不建议多维复杂类型的数组使用

		原型: 无

		形参:
			[1] arr - type(object)

		返回值:
			type(object)

	*/
	ret := {}
	for key, var in obj
		ret[var] := key
	return ret
}

arr_dbg1(arr) {
	/*
		简介: 用于调试数组与关联数组, 返回字符串, arr_dbg2/3类似

		原型: 无

		形参:
			[1] arr - type(object)
				要测试的数组

		返回值:
			type(string)

		测试:
			Clipboard := arr_dbg1([66, 77, {"K": 88, "D": 99}])
			;~ 剪切板数据为 "{1:66, 2:77, 3:{D:99, K:88}}"

	*/
    ret := ""
    if IsObject(arr) {
        ret .= "{"
        for key, var in arr
            ret .= key . ":" . arr_dbg1(var) . ", "
        if (key <> "")
            ret := SubStr(ret, 1, -2)
        ret .= "}"
    } else {
        if arr is number
            ret := arr
        else if (arr = "")
            ret = ""
        else
            ret := """" arr """"
    }
    return ret
}

arr_dbg2(arr) {
	/*
		简介: 用于调试数组与关联数组

		原型: 无

		形参:
			[1] arr - type(object)
				要测试的数组

		返回值:
			type(string)

		测试:
			MsgBox, % arr_dbg2([66, 77, {"K": 88, "D": 99}])

			弹窗内容:
			1=66
			2=77
			3={D :99, K :88}


	*/
    ret := ""
    for key, var in arr
        ret .= key "=" arr_dbg1(var) "`n"
    if (key <> "")
        ret := SubStr(ret, 1, -1)
    return ret
}

arr_dbg3(arr, crtPos := 0) {
	/*
		简介: 用于调试数组与关联数组

		原型: 无

		形参:
			[1] arr 	- type(object)
				要测试的数组

			[2] crtPos	- type(int)
				函数私有参数, 不填

		返回值:
			type(string)

		测试:
			MsgBox, % arr_dbg3([66, 77, {"K": 88, "D": 99}])

			弹窗内容:

			got (3) items in array, detail:

			1=66
			2=77
			3=array(2)
			--- D=99
			--- K=88

	*/

    sc := 3
    ret := ""
    if IsObject(arr) {

        if (crtPos = 0) {
            ret := "got (" arr.count() ") items in array, detail:`n`n"
			/*
            for key in arr
                ret .= "No." A_Index " > " key " `n"
            ret .= "`narray detail:`n"
			*/
            for key, var in arr
                ret .= key . "=" . arr_dbg3(var, crtPos + 1) "`n"
        } else {
            ret := "array(" arr.count() ")`n"
            fore := ""
            Loop, % crtPos * sc
                fore .= "-"
            fore .= " "
            for key, var in arr
                ret .= fore . key . "=" . arr_dbg3(var, crtPos + 1) "`n"
        }
        if (key <> "")
            ret := SubStr(ret, 1, -1)
    } else {
        if arr is number
            ret := arr
        else if (arr = "")
            ret = ""
        else
            ret := """" arr """"
    }
    return ret
}