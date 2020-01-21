
f1::
	p := StylePixWin.getSelPos()

	if not p
		TT("获取坐标失败")

	a := p.x1 "," p.y1 "," p.x2 "," p.y2
	b := (p.x1 + p.w // 2) "," (p.y1 + p.h // 2)
	c := a "`r`n" b
	clipboard :=  c


	TT("已复制到剪切板: `n"  c)

return



TT(msg, tmDestroy:= 2000) {
	ToolTip, % msg
	SetTimer, Lable_TTDestroy, % -Abs(tmDestroy) - 1
	return
	Lable_TTDestroy:
		ToolTip
	return
}


class StylePixWin {

	static cls := "ahk_class StylePix"

	getSelPos() {
		WinGet, HP, id, % this.cls

		if not HP
			return ""

		HP := "ahk_id " HP

		ControlGetText, x1, Edit1, % HP
		ControlgetText, y1, Edit2, % HP
		ControlgetText, w , Edit3, % HP
		ControlgetText, h , Edit4, % HP

		return {"x1": x1, "y1": y1, "w" : w, "h" : h, "x2" : x1 + w, "y2" : y1 + h}

	}

}