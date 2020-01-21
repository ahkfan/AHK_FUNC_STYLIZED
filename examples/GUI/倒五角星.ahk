
loop, 6
	rtStr .= mc(" ", A_Index - 1) . mc("* ", 6 - A_index + 1) "`n"
MsgBox, % rtStr

return

mc(charInto, num) {
	rt := ""
	Loop, % num
		rt .= charInto
	return rt
}