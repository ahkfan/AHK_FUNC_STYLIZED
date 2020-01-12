;~字符串

str_regex_get_all(src, RegEx)
{
	/*
	简介: 用单个匹配正则表达式调出所有匹配结果

	参1: type(String)
		匹配的字符串

	参2: 正则表达式

	返回值: 混合型数组, 匹配结果
		{
			"len" : 字符串长度,
			1: 匹配字符串1,
			2: 匹配字符串2,
		}

	测试:
		a := "1|123,123|555,666|123"
		get := RegExAll(a, "\d+\,\d+")
		Loop, % get.len
			MsgBox, % get[A_Index]
	*/
	result := []
	result.len := 0
	while (p := RegExMatch(src, RegEx, ret))
		result.len += 1, result.push(ret), src := SubStr(src, p+StrLen(ret) - 1)
	return result
}
