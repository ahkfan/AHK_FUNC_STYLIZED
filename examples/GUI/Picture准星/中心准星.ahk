; F5 显示/隐藏准心

#SingleInstance force
#UseHook
SetWinDelay, 0
CoordMode, mouse, screen

图片路径 := % A_ScriptDir "\准星.png"
	;用纯字符串的图片路径就注释上面那行，用下面的格式跟换准星
	;图片路径 = C:\文件夹\图片名.png

图片背景色值 := "FFFFFF"
	;双引号里面是背景色，16进制的rgb色

return

f5::
if winexist("ahk_id " move_WinID)
	Gui, destroy
else
{
	Gui, destroy
	gui, -caption -sysmenu +hwndmove_WinID  +AlwaysOnTop

	Gui, Add, Picture, v图片变量 x0 y0, % 图片路径
	GuiControlGet, 图片变量, Pos
	x := (A_ScreenWidth - 图片变量w) / 2
	y := (A_ScreenHeight - 图片变量h) / 2

	GUI, show, w%图片变量w% h%图片变量h%  x%x% y%y%

	WinGetPos, , ,xx, yy, ahk_id %move_WinID%
	WinSet, ExStyle, +0x20, ahk_id %move_WinID%
	WinSet, TransColor, ffffff, ahk_id %move_WinID%
}
return
