#SingleInstance force
图片路径 := % A_ScriptDir "\准星.png"
图片背景色值 := "FFFFFF"	；YUANLAI

SetWinDelay, 0
CoordMode, mouse, screen
gui, -caption -sysmenu +hwndmove_WinID  +AlwaysOnTop

Gui, Add, Picture, v图片变量 x0 y0, % 图片路径
GuiControlGet, 图片变量, Pos

GUI, show, w%图片变量w% h%图片变量h%

WinGetPos, , ,xx, yy, ahk_id %move_WinID%
WinSet, ExStyle, +0x20, ahk_id %move_WinID%
WinSet, TransColor, ffffff, ahk_id %move_WinID%
Loop {
	MouseGetPos, x, y
	WinMove, ahk_id %move_WinID%, , % x - XX / 2, % Y - YY / 2
}
return
