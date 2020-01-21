/*	当鼠标在某个范围内时显示界面


*/

#SingleInstance force

#Persistent
窗口1 := "ahk_exe notepad.exe"
窗口2 := "ahk_class WeChatLoginWndForPC"
按钮尺寸 := 90
;窗口1 := "ahk_Class SciTEWindow"
;窗口2 := "lib"
CoordMode, mouse, screen
SetTimer, CheckMOUSE, 200
return

CheckMOUSE:
	IfWinActive, % 窗口1
	{
		guiCHUANG := true
		切至 := 窗口2
	}
	IfWinActive, % 窗口2
	{
		guiCHUANG := true
		切至 := 窗口1
	}

	if guiCHUANG
		{ ;窗口存在时
			MouseGetPos, xx, yy
			if ((xx >= 0) && (xx <= 100) && (yy >= 0) && (xx <= 100)) {
				;鼠标在那个范围时创建窗口
				if (Not winexist("cuttheWinNowNow")) {

					gui, color, 000000, 000000
					gui, -caption +alwaysontop +Hwnd按钮窗口标题
					gui, add, button,x0 y0 w%按钮尺寸% h%按钮尺寸% g切换窗口, 切换窗口
					gui, show, NA x0 y0 w%按钮尺寸% h%按钮尺寸%, cuttheWinNowNow
					winset, trans, 160, % "ahk_id " 按钮窗口标题
					}
				}
			else {
				;鼠标不在那个范围内时
				if winexist("cuttheWinNowNow")
					gui, Destroy
				}
		}
	guiCHUANG := false
	return

切换窗口:
	gui, Destroy
	SetTimer, CheckMOUSE, Off
	WinActivate, % 切至
	切至 :=
	Sleep 500
	SetTimer, CheckMOUSE, on
	return