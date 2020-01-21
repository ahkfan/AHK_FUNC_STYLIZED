#SingleInstance force
SetNumLockState , AlwaysOn
GUIX.init()
Key_GetParse("+c")			;~ 快捷键: shift + C			打开资源管理器, 获取未粘粘列表
Key_PutParse("+v")			;~ 快捷键: shift + V			粘粘未粘粘列表首位值
Key_ClearAll("+Esc")		;~ 快捷键: shift + Esc		完全清空两个列表,
Key_DelSome("+Delete")		;~ 快捷键: shift + Delete	shift执行多选后, 从列表 左删到右 或 从右删到左
return

Key_PutParse(key) {
	hotkey, % key, LB_ClipInto
	return
	LB_ClipInto:
	if not GUIX.ls1.MaxIndex() {
		MsgBox, % "粘粘列表已空"
		return
	}
	var := GUIX["ls1"][1]
	if not strlen(var)
		return
	clipboard := ""
	clipboard := var
	ClipWait
	one2one(1, 1)

	keywait, v
	send, ^v
	GUIX.FreshAll()
	return
}

Key_DelSome(key) {
	hotkey, % key, LB_KeyKey_DelSome
	return
	LB_KeyKey_DelSome:
		if not GUIX.currentLb
			return
		guicontrolget, var, , % GUIX.currentLb
		chooseList := StrSplit(var , "|")
		if not chooseList.MaxIndex()
			return
		iId := GUIX.currentId
		for i, v in ls_Reverse(chooseList*)
			one2one(iId, v)
		GUIX.FreshAll()
	return
}

Key_ClearAll(key) {		;~ 清空两个列表的函数
	hotkey, % key, LB_KeyKey_ClearAll
	return

	LB_KeyKey_ClearAll:
		GUIX.ClearAll()
	return
}

Key_GetParse(key) {
	hotkey, % key, LB_KeyGetDir
	return

	LB_KeyGetDir:
		sDir := GetExplorerDir()
		if not sDir
			return
		Loop, files, % sDir "\*.*", F
			if !(GUIX.d1.HasKey(A_LoopFileName) or GUIX.d2.HasKey(A_LoopFileName)) {
				(GUIX.d1)[A_LoopFileName] := ""
				GUIX.ls1.push(A_LoopFileName)
			}
		GUIX.FreshLb(1)
	return
}

one2one(iId, Index) {
	if not Index
		return
	oId := (iId = 1) ? 2 : 1
	var := GUIX["ls" . iId][Index]
	GUIX["ls" . oId].InsertAt(1, var)
	GUIX["d" . oId][var] := ""
	GUIX["d" . iId].delete(var)
	GUIX["ls" . iId].RemoveAt(Index)
}

class GUIX {
	init() {

		Gui, +AlwaysOntop
		Gui, add, Edit, 		ReadOnly	hwnd@e1, % "未粘贴: 0          "
		Gui, add, Edit, x150 y6 ReadOnly	hwnd@e2, % "已粘贴: 0          "
		Gui, add, listbox, x10  y28 w125 h300 hwnd@lb1 Multi AltSubmit g#lb1
		Gui, add, listbox, x150 y28 w125 h300 hwnd@lb2 Multi AltSubmit g#lb2
		Gui, show, % "x" . (A_ScreenWidth - 350) " y" (10), AHK_FileParseTool
		this.currentLb := ""
		this.currentId := ""
		this.e1 := @e1
		this.e2 := @e2
		this.ls1 := []
		this.ls2 := []
		this.d1 := {}
		this.d2 := {}
		this.hwnd_lb1 := @lb1
		this.hwnd_lb2 := @lb2
	}
	FreshAll() {
		this.FreshLb(1)
		this.FreshLb(2)
	}
	FreshLb(id) {
		lb_Clear(this["hwnd_lb" . id])
		lb_ReSet(this["hwnd_lb" . id], (this["ls" . id])*)
		num := this["ls" . id].MaxIndex()
		GuiControl, , % this["e" . id], % ((id = 1) ? "未" : "已") . "粘粘: " . (num ? num : 0)
	}

	ClearAll() {
		lb_Clear(this.hwnd_lb1)
		GuiControl, , % this.e1, 未粘粘: 0
		this.ls1 := []
		this.d1 := {}
		lb_Clear(this.hwnd_lb2)
		GuiControl, , % this.e2, 已粘粘: 0
		this.ls2 := []
		this.d2 := {}
	}
}

GuiCLose() {
	ExitApp
	return
}

#lb1(hwnd) {	;~ 未粘粘列表的事件
	GUIX.currentLb := hwnd
	iId := GUIX.currentId := 1
	if (A_GuiEvent = "DoubleClick") {
		GuiControlGet, i, , % hwnd
		one2one(iId, i)
		GUIX.FreshAll()
	}
}

#lb2(hwnd) {	;~ 已粘粘列表的事件
	GUIX.currentLb := hwnd
	iId := GUIX.currentId := 2
	if (A_GuiEvent = "DoubleClick") {
		GuiControlGet, i, , % hwnd
		one2one(iId, i)
		GUIX.FreshAll()
	}
}

lb_Clear(hwnd) {		;~ 清除listbox中内容
	GuiControl, , % hwnd, % " "
	GuiControl, , % hwnd, % "|"
}

lb_ReSet(hwnd, list*) {	;~ 重置listbox中内容
	local i, v, s
	GuiControl, , % hwnd, % " "
	GuiControl, , % hwnd, % "|"
	for i, v in list
		s .= v "|"
	GuiControl, , % hwnd, % s
}

ls_Reverse(ls*) {							;~ 取列表的倒序
	local rtLs := [], len
	len := ls.MaxIndex()
	Loop, % len
		rtLs.push(ls[len - A_Index + 1])
	return rtLs
}

GetExplorerDir() {
	if not winactive("ahk_class CabinetWClass ahk_exe explorer.exe") or winactive("ahk_class Progman ahk_exe explorer.exe")
		return ""

	if winactive("ahk_class CabinetWClass ahk_exe explorer.exe") {
		ControlGetText, theDir, ToolBarWindow323
		theDir := RegExReplace(theDir, "地址\:\s*")
		if (theDir = "桌面")
			theDir := A_Desktop
		if not regexmatch(theDir, "i)^[a-z]\:\\")
			theDir := ""
	} else if winactive("ahk_class Progman ahk_exe explorer.exe") {
		theDir := A_Desktop
	}

	if not theDir
		return ""
	return theDir
}