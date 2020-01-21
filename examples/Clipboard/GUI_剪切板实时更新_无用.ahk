#SingleInstance force
/*
	实时跟进剪切板内容
	可以直接在ui内部改动修改剪切板
	alt + c 不改变剪切板情况下复制到变量
	alt + v 通过 alt + c 复制的内容复制到剪切板再ctrl + v 发送

*/

SetKeyDelay, -1

gui, +hwnd@main +Resize +ToolWindow
Gui, font, s10
Gui, add, edit, x0 y0 h120 w350 HScroll hwnd@clipboard gevent_edit_set_clipboard
Gui, show, h120 w350,ClipWindow

exClip := ""
Loop {
	sleep 20
	if (pauseFlag = true) {
		Sleep, 3000
		continue
	}
	try {
	clip := clipboard
	if (exClip <> clip) {
		GuiControl, , % @clipboard, % clip
		exClip := clip
	}
	}
}
return

^esc::
	SendRaw, % exClip
return

!c::	;~ 临时剪切板复制
	KeyWait, c
	pauseFlag := true
	Clipboard := ""
	Send, ^c
	ClipWait, 0.2
	if (not ErrorLevel)
		nowClip := Clipboard

	clipboard := exClip
	pauseFlag := false
	return
return

!v::
	KeyWait, v
	pauseFlag := true
	Clipboard := ""
	if (nowClip <> "") {
		Clipboard := nowClip
		ClipWait, 0.2
		if (not ErrorLevel) {
			Send, ^v
		}
		Clipboard := exClip
	}
	pauseFlag := false
return

GuiClose() {
	ExitApp
}

event_edit_set_clipboard() {
	global
	pauseFlag := true
	settimer, SetNewClip, -1000
	return
	SetNewClip:
		GuiControlGet, content, , % @clipboard

		if (content <> clipboard) {
			clipboard := content
			exClip := content
		}

		pauseFlag := false
	return
}


GuiSize() {
	global
	pauseFlag := true

	SetTimer, aaa, -100
	return
	aaa:
		WinGetPos, , , w, h, % "ahk_id " @main
		GuiControlGet, p, pos, % @clipboard
		GuiControl, move, % @clipboard, % "x0 y0 w" (w) " h" (h - 39)
		pauseFlag := false
	return

}