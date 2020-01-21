/*
	ControlGetPos 命令取控件坐标
*/

#SingleInstance force
;Gui, -caption -sysmenu
Gui, add, button, x23 y20 w120 h130 gGo, button
Gui, show, w300, abcd
return


f1::
Go:
	ControlGetPos, xx, yy, ww, hh, Button1,abcd

	;~ 显示坐标参数
	SetTimer, msg, -100
	WinGetPos, xx1, yy1, , , abcd

	;~ 移动鼠标
	CoordMode, mouse, screen
	MouseMove,  % xx + xx1, % yy + yy1

return
msg:
	MsgBox, % "x" xx
	. "y" yy
	. "w" ww
	. "h" hh
return