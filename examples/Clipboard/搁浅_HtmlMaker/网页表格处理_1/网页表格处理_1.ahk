ls := []
loop, read, h.txt
{
	a := SubStr(A_LoopReadLine, 2)
	a := RegExReplace(a, ">.*")
	ls.push(a)
}

Clipboard := % ls_dbg(ls)

ls_dbg(ls) {								;~ 将列表内容返回为 [123, "aaa", ["123", 666]]样式的字符串, 适用于多维列表
	local rtStr := "", i, v
	if not isobject(ls) {
		if ls is number
			rtStr := ls
		else if (ls = "")
			rtStr = ""
		else
			rtStr = "%ls%"
	} else {
		rtStr := "["
		for i, v in ls
			rtStr .= ls_dbg(v) . ","
		if ls.count()
			StringTrimRight, rtStr, rtStr, 1
		rtStr .= "]"
	}
	return rtStr
}
