;此为at指令编码转换的尝试

msgbox, % ret_1str2func("8613906910247", "ret_addf", "ret_changepos")
return

;---------- 此处转字符为 unioncode 编码
ret_x_string(long_str) {	;将字符串转为为unioncode码
	ret_x_code := ""
	Loop, parse, % long_str
		ret_x_code .= ret_x_char(A_LoopField)
	return ret_x_code
}
ret_x_char(single_char) {	;将字符转为unioncode码, 默认长度4位
	return (StrLen(ret_final := format("{1:x}",Ord(single_char))) = 4) ? ret_final : ret_addzero(ret_final, 4, "0")
}
ret_addzero(s_input,i_len := 4, s_add_char := "0") {	;若小于某个长度,前端用
	if (strlen(s_input) < i_len)
	{
		Loop % (i_len - strlen(s_input))
			s_input := s_add_char . s_input
		return s_input
	}
	else
		return s_input
}
;---------- 此处处理数据
ret_1str2func(s_inputstr, s_objf1name, s_objf2name) {
	;1个字符串用个函数处理
	obj1 := Func(s_objf1name)
	obj2 := Func(s_objf2name)
	return  obj2.call(obj1.call(s_inputstr))
}
ret_addf(s_inputstr) {
	;为奇数尾部添加f
	if mod(StrLen(s_inputstr), 2)
		return s_inputstr . "f"
	return s_inputstr
}

ret_changepos(s_inputstr) {
	;将字符串,奇数位字符与偶数位字符调换
	ls_a := []
	Loop, parse, % s_inputstr
		ls_a.push(A_LoopField)
	for i, v in ls_a
	{
		if mod(i, 2) {
			s_trans := v
			ls_a[i] := ls_a[i + 1]
			ls_a[i + 1] := v
		}
	}
	ret_s := ""
	for i, v in ls_a
		ret_s .= v
	return ret_s
}
