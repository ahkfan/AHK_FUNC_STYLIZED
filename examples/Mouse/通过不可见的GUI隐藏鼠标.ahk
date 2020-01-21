;~ f1 隐藏 / 显示鼠标
a := 1
return

f1::hideCursor(a := !a)

hideCursor(Show := true) 
{	;~ 隐藏时无法点击
	static first := true
	static hwnd
	if (first) 
	{
		dllcall("ShowCursor", "Int", false)
		Gui, -caption -sysmenu +hwndhwnd +AlwaysOnTop
		Gui, show, hide w%A_ScreenWidth% h%A_ScreenHeight%
	}

	gui, % (show ? "hide" : "show")

	if (show)
		WinShow, ahk_class Shell_TrayWnd
	else
		winhide, ahk_class Shell_TrayWnd

	WinSet, Trans, 1, % "ahk_id " hwnd

}